import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_scaffold.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDataProvider dataProvider = context.watch<AppDataProvider>();

    return AppScaffold(
      title: AppStrings.adminDashboard,
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              AppStrings.dashboardOverview,
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSizes.md),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: <Widget>[
                _metricCard(
                  AppStrings.totalMaterials,
                  dataProvider.materials.length.toString(),
                  Icons.inventory_2_outlined,
                ),
                _metricCard(
                  AppStrings.totalLogs,
                  dataProvider.usageLogs.length.toString(),
                  Icons.fact_check_outlined,
                ),
                _metricCard(
                  AppStrings.openTasks,
                  dataProvider.tasks
                      .where((task) => !task.completed)
                      .length
                      .toString(),
                  Icons.assignment_late_outlined,
                ),
                _metricCard(
                  AppStrings.lowStock,
                  dataProvider.lowStockMaterials.length.toString(),
                  Icons.warning_amber_outlined,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            const Text(
              AppStrings.lowStockAlerts,
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: AppSizes.sm),
            if (dataProvider.lowStockMaterials.isEmpty)
              const AppCard(
                child: Text(AppStrings.noData, style: AppTextStyles.body),
              )
            else
              ...dataProvider.lowStockMaterials.map(
                (material) => AppCard(
                  child: ListTile(
                    leading: const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                    ),
                    title: Text(material.name),
                    subtitle: Text(
                      '${AppStrings.stock}: ${material.stock.toStringAsFixed(2)} ${material.unitType}',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String title, String value, IconData icon) {
    return SizedBox(
      width: 170,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: AppColors.secondary),
            const SizedBox(height: AppSizes.sm),
            Text(value, style: AppTextStyles.heading2),
            const SizedBox(height: AppSizes.xs),
            Text(title, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
