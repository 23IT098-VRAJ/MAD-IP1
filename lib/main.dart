import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/constants.dart';
import 'core/theme/theme.dart';
import 'providers/app_data_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/inventory_history_screen.dart';
import 'screens/admin/materials_screen.dart';
import 'screens/admin/processes_screen.dart';
import 'screens/admin/reports_screen.dart';
import 'screens/admin/sync_center_screen.dart';
import 'screens/admin/users_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/role_router_screen.dart';
import 'screens/operator/operator_dashboard_screen.dart';
import 'screens/operator/scan_log_screen.dart';
import 'screens/operator/tasks_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final AppDataProvider appDataProvider = AppDataProvider();
  await appDataProvider.init();

  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<AppDataProvider>.value(value: appDataProvider),
      ],
      child: const SmartFabApp(),
    ),
  );
}

class SmartFabApp extends StatelessWidget {
  const SmartFabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: <String, WidgetBuilder>{
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.roleRouter: (_) => const RoleRouterScreen(),
        AppRoutes.adminDashboard: (_) => const AdminDashboardScreen(),
        AppRoutes.materials: (_) => const MaterialsScreen(),
        AppRoutes.processes: (_) => const ProcessesScreen(),
        AppRoutes.users: (_) => const UsersScreen(),
        AppRoutes.inventoryHistory: (_) => const InventoryHistoryScreen(),
        AppRoutes.reports: (_) => const ReportsScreen(),
        AppRoutes.syncCenter: (_) => const SyncCenterScreen(),
        AppRoutes.operatorDashboard: (_) => const OperatorDashboardScreen(),
        AppRoutes.scanLog: (_) => const ScanLogScreen(),
        AppRoutes.tasks: (_) => const TasksScreen(),
      },
    );
  }
}
