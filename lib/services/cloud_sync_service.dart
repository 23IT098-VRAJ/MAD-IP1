class CloudSyncService {
  CloudSyncService._({required bool isEnabled}) : _isEnabled = isEnabled;

  final bool _isEnabled;

  bool get isEnabled => _isEnabled;

  static Future<CloudSyncService> create() async {
    return CloudSyncService._(isEnabled: false);
  }

  Future<void> syncRecords(List<Map<String, dynamic>> records) async {
    if (!_isEnabled || records.isEmpty) {
      return;
    }
  }
}
