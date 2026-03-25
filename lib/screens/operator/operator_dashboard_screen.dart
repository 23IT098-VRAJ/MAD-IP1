import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../models/app_user.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/operator_drawer.dart';

class OperatorDashboardScreen extends StatelessWidget {
  const OperatorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDataProvider dataProvider = context.watch<AppDataProvider>();
    final AppUser? user = context.watch<AuthProvider>().currentUser;

    final int taskCount = user == null
        ? 0
        : dataProvider.tasksForUser(user.id).length;

    return AppScaffold(
      title: AppStrings.operatorDashboard,
      drawer: const OperatorDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              AppStrings.dashboardOverview,
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSizes.sm),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Hello, ${user?.fullName ?? AppStrings.operator}',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text('Assigned tasks: $taskCount', style: AppTextStyles.body),
                  Text(
                    'Total logs recorded: ${dataProvider.usageLogs.length}',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            AppCard(
              child: ListTile(
                leading: const Icon(Icons.qr_code_scanner_outlined),
                title: const Text(AppStrings.scanAndLog),
                subtitle: const Text(AppStrings.scanBarcodeHint),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.scanLog),
              ),
            ),
            AppCard(
              child: ListTile(
                leading: const Icon(Icons.assignment_outlined),
                title: const Text(AppStrings.tasks),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.tasks),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
