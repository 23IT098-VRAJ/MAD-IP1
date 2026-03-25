import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';

import '../models/app_user.dart';
import '../models/material_item.dart';
import '../models/process_item.dart';
import '../models/report_summary.dart';
import '../models/task_item.dart';
import '../models/usage_log.dart';
import '../services/cloud_sync_service.dart';

class AppDataProvider extends ChangeNotifier {
  AppDataProvider({required CloudSyncService cloudSyncService})
    : _cloudSyncService = cloudSyncService;

  static const String _boxName = 'smartfab_box';
  static const String _materialsKey = 'materials';
  static const String _processesKey = 'processes';
  static const String _usersKey = 'users';
  static const String _tasksKey = 'tasks';
  static const String _logsKey = 'logs';
  static const String _pendingSyncKey = 'pending_sync';
  static const String _lastSyncedKey = 'last_synced';

  final CloudSyncService _cloudSyncService;
  final Uuid _uuid = const Uuid();

  Box<dynamic>? _box;
  bool _isLoading = true;

  List<MaterialItem> _materials = <MaterialItem>[];
  List<ProcessItem> _processes = <ProcessItem>[];
  List<AppUser> _users = <AppUser>[];
  List<TaskItem> _tasks = <TaskItem>[];
  List<UsageLog> _usageLogs = <UsageLog>[];
  List<Map<String, dynamic>> _pendingSync = <Map<String, dynamic>>[];
  DateTime? _lastSyncedAt;

  bool get isLoading => _isLoading;
  List<MaterialItem> get materials =>
      List<MaterialItem>.unmodifiable(_materials);
  List<ProcessItem> get processes => List<ProcessItem>.unmodifiable(_processes);
  List<AppUser> get users => List<AppUser>.unmodifiable(_users);
  List<TaskItem> get tasks => List<TaskItem>.unmodifiable(_tasks);
  List<UsageLog> get usageLogs => List<UsageLog>.unmodifiable(_usageLogs);
  List<Map<String, dynamic>> get pendingSync =>
      List<Map<String, dynamic>>.unmodifiable(_pendingSync);
  DateTime? get lastSyncedAt => _lastSyncedAt;

  List<MaterialItem> get lowStockMaterials {
    return _materials
        .where((MaterialItem item) => item.stock <= item.minStock)
        .toList(growable: false);
  }

  AppUser? findUserByUsername(String username) {
    final String normalized = username.trim().toLowerCase();
    for (final AppUser user in _users) {
      if (user.username.trim().toLowerCase() == normalized && user.isActive) {
        return user;
      }
    }
    return null;
  }

  Future<AppUser> ensureUserProfile({
    required String username,
    required String fullName,
    UserRole role = UserRole.operator,
  }) async {
    final AppUser? existing = findUserByUsername(username);
    if (existing != null) {
      return existing;
    }

    return addUser(
      username: username,
      password: '',
      role: role,
      fullName: fullName,
    );
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _box = await Hive.openBox<dynamic>(_boxName);
    _materials = _readList(_materialsKey, MaterialItem.fromMap);
    _processes = _readList(_processesKey, ProcessItem.fromMap);
    _users = _readList(_usersKey, AppUser.fromMap);
    _tasks = _readList(_tasksKey, TaskItem.fromMap);
    _usageLogs = _readList(_logsKey, UsageLog.fromMap);
    _pendingSync =
        ((_box?.get(_pendingSyncKey) as List<dynamic>?) ?? <dynamic>[])
            .map((dynamic item) => Map<String, dynamic>.from(item as Map))
            .toList();

    final String? synced = _box?.get(_lastSyncedKey) as String?;
    _lastSyncedAt = synced == null ? null : DateTime.tryParse(synced);

    if (_users.isEmpty) {
      _seedInitialData();
      await _persistAll();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<T> _readList<T>(
    String key,
    T Function(Map<dynamic, dynamic> map) fromMap,
  ) {
    final List<dynamic> raw = (_box?.get(key) as List<dynamic>?) ?? <dynamic>[];
    return raw
        .map((dynamic item) => fromMap(Map<dynamic, dynamic>.from(item as Map)))
        .toList();
  }

  void _seedInitialData() {
    _users = <AppUser>[
      AppUser(
        id: _uuid.v4(),
        username: 'admin',
        password: 'admin123',
        role: UserRole.admin,
        fullName: 'Factory Admin',
      ),
      AppUser(
        id: _uuid.v4(),
        username: 'operator',
        password: 'operator123',
        role: UserRole.operator,
        fullName: 'Line Operator',
      ),
    ];

    _materials = <MaterialItem>[
      MaterialItem(
        id: _uuid.v4(),
        name: 'Industrial Steel Sheet',
        barcode: 'STL-1001',
        unitType: 'kg',
        unitCost: 78,
        stock: 1200,
        minStock: 200,
        createdAt: DateTime.now(),
      ),
      MaterialItem(
        id: _uuid.v4(),
        name: 'Copper Wire',
        barcode: 'CPR-2002',
        unitType: 'm',
        unitCost: 12,
        stock: 400,
        minStock: 100,
        createdAt: DateTime.now(),
      ),
    ];

    _processes = <ProcessItem>[
      ProcessItem(
        id: _uuid.v4(),
        name: 'Laser Cutting',
        additionalCost: 220,
        notes: 'Energy + setup',
        createdAt: DateTime.now(),
      ),
    ];

    _tasks = <TaskItem>[
      TaskItem(
        id: _uuid.v4(),
        userId: _users
            .firstWhere((AppUser user) => user.role == UserRole.operator)
            .id,
        title: 'Record Steel Sheet Consumption',
        description: 'Scan and log batch usage for line A',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        completed: false,
      ),
    ];
  }

  Future<void> _persistAll() async {
    final Box<dynamic>? box = _box;
    if (box == null) {
      return;
    }

    await box.put(
      _materialsKey,
      _materials.map((MaterialItem item) => item.toMap()).toList(),
    );
    await box.put(
      _processesKey,
      _processes.map((ProcessItem item) => item.toMap()).toList(),
    );
    await box.put(
      _usersKey,
      _users.map((AppUser item) => item.toMap()).toList(),
    );
    await box.put(
      _tasksKey,
      _tasks.map((TaskItem item) => item.toMap()).toList(),
    );
    await box.put(
      _logsKey,
      _usageLogs.map((UsageLog item) => item.toMap()).toList(),
    );
    await box.put(_pendingSyncKey, _pendingSync);
    await box.put(_lastSyncedKey, _lastSyncedAt?.toIso8601String());
  }

  Future<void> addMaterial({
    required String name,
    required String barcode,
    required String unitType,
    required double unitCost,
    required double stock,
    required double minStock,
  }) async {
    final MaterialItem material = MaterialItem(
      id: _uuid.v4(),
      name: name,
      barcode: barcode,
      unitType: unitType,
      unitCost: unitCost,
      stock: stock,
      minStock: minStock,
      createdAt: DateTime.now(),
    );

    _materials = <MaterialItem>[..._materials, material];
    _queueSync('add_material', material.toMap());
    await _persistAndNotify();
  }

  Future<void> updateMaterial(MaterialItem updated) async {
    _materials = _materials
        .map((MaterialItem item) => item.id == updated.id ? updated : item)
        .toList();
    _queueSync('update_material', updated.toMap());
    await _persistAndNotify();
  }

  Future<void> deleteMaterial(String materialId) async {
    _materials = _materials
        .where((MaterialItem item) => item.id != materialId)
        .toList();
    _queueSync('delete_material', <String, dynamic>{'id': materialId});
    await _persistAndNotify();
  }

  Future<void> addProcess({
    required String name,
    required double additionalCost,
    required String notes,
  }) async {
    final ProcessItem process = ProcessItem(
      id: _uuid.v4(),
      name: name,
      additionalCost: additionalCost,
      notes: notes,
      createdAt: DateTime.now(),
    );

    _processes = <ProcessItem>[..._processes, process];
    _queueSync('add_process', process.toMap());
    await _persistAndNotify();
  }

  Future<void> deleteProcess(String processId) async {
    _processes = _processes
        .where((ProcessItem item) => item.id != processId)
        .toList();
    _queueSync('delete_process', <String, dynamic>{'id': processId});
    await _persistAndNotify();
  }

  Future<AppUser> addUser({
    required String username,
    required String password,
    required UserRole role,
    required String fullName,
  }) async {
    final String normalizedUsername = username.trim().toLowerCase();
    final AppUser? existing = findUserByUsername(normalizedUsername);
    if (existing != null) {
      return existing;
    }

    final AppUser user = AppUser(
      id: _uuid.v4(),
      username: normalizedUsername,
      password: password,
      role: role,
      fullName: fullName,
    );

    _users = <AppUser>[..._users, user];
    _queueSync('add_user', user.toMap());
    await _persistAndNotify();
    return user;
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    _tasks = _tasks
        .map(
          (TaskItem task) => task.id == taskId
              ? task.copyWith(completed: !task.completed)
              : task,
        )
        .toList();
    await _persistAndNotify();
  }

  MaterialItem? findMaterialByBarcode(String barcode) {
    try {
      return _materials.firstWhere(
        (MaterialItem item) => item.barcode == barcode,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> logConsumption({
    required String barcode,
    required double quantityUsed,
    required double additionalProcessingCost,
    required double marginPercent,
    required AppUser operator,
  }) async {
    final MaterialItem? material = findMaterialByBarcode(barcode);
    if (material == null || material.stock < quantityUsed) {
      return false;
    }

    final UsageLog log = UsageLog(
      id: _uuid.v4(),
      materialId: material.id,
      materialName: material.name,
      quantityUsed: quantityUsed,
      unitCost: material.unitCost,
      additionalProcessingCost: additionalProcessingCost,
      marginPercent: marginPercent,
      operatorId: operator.id,
      operatorName: operator.fullName,
      timestamp: DateTime.now(),
    );

    _usageLogs = <UsageLog>[log, ..._usageLogs];
    _materials = _materials
        .map(
          (MaterialItem item) => item.id == material.id
              ? item.copyWith(stock: item.stock - quantityUsed)
              : item,
        )
        .toList();

    _queueSync('add_log', log.toMap());
    await _persistAndNotify();
    return true;
  }

  ReportSummary buildReportSummary({double marginPercent = 20}) {
    final double rawMaterialCost = _usageLogs.fold<double>(
      0,
      (double sum, UsageLog log) => sum + log.rawMaterialCost,
    );

    final double processingCost = _usageLogs.fold<double>(
      0,
      (double sum, UsageLog log) => sum + log.additionalProcessingCost,
    );

    final double manufacturingCost = rawMaterialCost + processingCost;
    final double suggestedSellingPrice =
        manufacturingCost * (1 + (marginPercent / 100));
    final double profitMarginValue = suggestedSellingPrice - manufacturingCost;

    return ReportSummary(
      rawMaterialCost: rawMaterialCost,
      processingCost: processingCost,
      manufacturingCost: manufacturingCost,
      suggestedSellingPrice: suggestedSellingPrice,
      profitMarginValue: profitMarginValue,
    );
  }

  String buildCsvReport() {
    final List<List<dynamic>> rows = <List<dynamic>>[
      <String>[
        'Date',
        'Material',
        'Qty',
        'Unit Cost',
        'Raw Cost',
        'Process Cost',
        'Final Price',
        'Operator',
      ],
      ..._usageLogs.map((UsageLog log) {
        return <dynamic>[
          DateFormat('yyyy-MM-dd HH:mm').format(log.timestamp),
          log.materialName,
          log.quantityUsed,
          log.unitCost,
          log.rawMaterialCost,
          log.additionalProcessingCost,
          log.finalProductPrice,
          log.operatorName,
        ];
      }),
    ];

    return const ListToCsvConverter().convert(rows);
  }

  Future<Uint8List> buildPdfReport() async {
    final pw.Document document = pw.Document();
    final ReportSummary summary = buildReportSummary();

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Text('SmartFab Cost Breakdown Report'),
            pw.SizedBox(height: 12),
            pw.Text(
              'Raw Material Cost: ${summary.rawMaterialCost.toStringAsFixed(2)}',
            ),
            pw.Text(
              'Processing Cost: ${summary.processingCost.toStringAsFixed(2)}',
            ),
            pw.Text(
              'Manufacturing Cost: ${summary.manufacturingCost.toStringAsFixed(2)}',
            ),
            pw.Text(
              'Suggested Price: ${summary.suggestedSellingPrice.toStringAsFixed(2)}',
            ),
            pw.Text(
              'Profit Margin Value: ${summary.profitMarginValue.toStringAsFixed(2)}',
            ),
            pw.SizedBox(height: 16),
            pw.Text('Usage Log Count: ${_usageLogs.length}'),
          ];
        },
      ),
    );

    return document.save();
  }

  Future<void> syncNow() async {
    if (_pendingSync.isEmpty) {
      _lastSyncedAt = DateTime.now();
      await _persistAndNotify();
      return;
    }

    final List<Map<String, dynamic>> payload = List<Map<String, dynamic>>.from(
      _pendingSync,
    );
    await _cloudSyncService.syncRecords(payload);
    _pendingSync = <Map<String, dynamic>>[];
    _lastSyncedAt = DateTime.now();
    await _persistAndNotify();
  }

  List<TaskItem> tasksForUser(String userId) {
    return _tasks.where((TaskItem item) => item.userId == userId).toList();
  }

  List<UsageLog> filteredUsageLogs(String query) {
    if (query.isEmpty) {
      return _usageLogs;
    }
    final String normalized = query.toLowerCase();
    return _usageLogs.where((UsageLog log) {
      return log.materialName.toLowerCase().contains(normalized) ||
          log.operatorName.toLowerCase().contains(normalized);
    }).toList();
  }

  void _queueSync(String action, Map<String, dynamic> data) {
    _pendingSync = <Map<String, dynamic>>[
      ..._pendingSync,
      <String, dynamic>{
        'id': _uuid.v4(),
        'action': action,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      },
    ];
  }

  Future<void> _persistAndNotify() async {
    await _persistAll();
    notifyListeners();
  }
}
