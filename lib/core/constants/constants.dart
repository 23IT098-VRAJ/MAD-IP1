import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0F4C5C);
  static const Color secondary = Color(0xFF2F8F9D);
  static const Color accent = Color(0xFFF4A261);
  static const Color danger = Color(0xFFD62828);
  static const Color success = Color(0xFF2A9D8F);
  static const Color warning = Color(0xFFE9C46A);
  static const Color background = Color(0xFFF6F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFDCE2E8);
  static const Color textPrimary = Color(0xFF14213D);
  static const Color textSecondary = Color(0xFF5C677D);
  static const Color disabled = Color(0xFF9AA5B1);
}

class AppSizes {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;

  static const double iconSm = 18;
  static const double iconMd = 22;
  static const double iconLg = 28;

  static const double buttonHeight = 48;
  static const double inputHeight = 54;
  static const double appBarElevation = 0;
}

class AppStrings {
  static const String appTitle = 'SmartFab Material Tracker';
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle =
      'Sign in to continue production operations';
  static const String username = 'Username';
  static const String password = 'Password';
  static const String signIn = 'Sign In';
  static const String signOut = 'Sign Out';
  static const String invalidCredentials =
      'Invalid credentials. Please try again.';
  static const String admin = 'Admin';
  static const String operator = 'Operator';

  static const String adminDashboard = 'Admin Dashboard';
  static const String operatorDashboard = 'Operator Dashboard';
  static const String materials = 'Materials';
  static const String processes = 'Processes';
  static const String users = 'Users';
  static const String reports = 'Reports';
  static const String inventoryHistory = 'Inventory History';
  static const String syncCenter = 'Sync Center';
  static const String scanAndLog = 'Scan & Log';
  static const String tasks = 'Assigned Tasks';

  static const String addMaterial = 'Add Material';
  static const String editMaterial = 'Edit Material';
  static const String addProcess = 'Add Process';
  static const String editProcess = 'Edit Process';
  static const String addUser = 'Add User';
  static const String editUser = 'Edit User';

  static const String materialName = 'Material Name';
  static const String barcode = 'Barcode / QR Value';
  static const String unitType = 'Unit Type';
  static const String unitCost = 'Unit Cost';
  static const String stock = 'Stock';
  static const String minStock = 'Minimum Stock';
  static const String quantityUsed = 'Quantity Used';
  static const String additionalCost = 'Additional Processing Cost';
  static const String desiredMargin = 'Desired Margin (%)';
  static const String processName = 'Process Name';
  static const String notes = 'Notes';

  static const String save = 'Save';
  static const String update = 'Update';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String search = 'Search';
  static const String noData = 'No data available';
  static const String noMaterials =
      'No materials found. Add your first material.';
  static const String noProcesses =
      'No processes found. Add your first process.';
  static const String noUsers = 'No users found. Add a user to continue.';
  static const String noTasks = 'No assigned tasks right now.';
  static const String noHistory = 'No consumption logs yet.';

  static const String rawMaterialCost = 'Raw Material Cost';
  static const String manufacturingCost = 'Manufacturing Cost';
  static const String finalProductPrice = 'Final Product Price';
  static const String profitMargin = 'Profit Margin';
  static const String suggestedPrice = 'Suggested Selling Price';

  static const String exportCsv = 'Export CSV';
  static const String exportPdf = 'Export PDF';
  static const String syncNow = 'Sync Now';
  static const String pendingSync = 'Pending Sync Records';
  static const String lastSynced = 'Last Synced';
  static const String lowStockAlerts = 'Low Stock Alerts';

  static const String requiredField = 'This field is required';
  static const String invalidNumber = 'Enter a valid number';
  static const String operationSuccessful = 'Operation completed successfully';
  static const String operationFailed = 'Operation failed. Please retry.';
  static const String generatedReport = 'Report generated';
  static const String fullName = 'Full Name';
  static const String role = 'Role';
  static const String dashboardOverview = 'Production Overview';
  static const String totalMaterials = 'Total Materials';
  static const String totalLogs = 'Total Logs';
  static const String openTasks = 'Open Tasks';
  static const String lowStock = 'Low Stock';
  static const String scanBarcodeHint = 'Scan barcode or type code';
  static const String taskMarkedDone = 'Task updated';
  static const String stockInsufficient =
      'Insufficient stock for this material';
  static const String materialNotFound = 'Material not found for this barcode';
  static const String csvPreview = 'CSV Preview';
  static const String pdfGenerated = 'PDF generated in memory successfully';
  static const String operatorUsageHistory = 'Operator Usage History';
}

class AppRoutes {
  static const String login = '/login';
  static const String roleRouter = '/role-router';
  static const String adminDashboard = '/admin-dashboard';
  static const String materials = '/materials';
  static const String processes = '/processes';
  static const String users = '/users';
  static const String inventoryHistory = '/inventory-history';
  static const String reports = '/reports';
  static const String syncCenter = '/sync-center';
  static const String operatorDashboard = '/operator-dashboard';
  static const String scanLog = '/scan-log';
  static const String tasks = '/tasks';
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}
