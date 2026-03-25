import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state_widget.dart';

class InventoryHistoryScreen extends StatefulWidget {
  const InventoryHistoryScreen({super.key});

  @override
  State<InventoryHistoryScreen> createState() => _InventoryHistoryScreenState();
}

class _InventoryHistoryScreenState extends State<InventoryHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppDataProvider dataProvider = context.watch<AppDataProvider>();
    final String query = _searchController.text.trim();
    final logs = dataProvider.filteredUsageLogs(query);

    return AppScaffold(
      title: AppStrings.inventoryHistory,
      drawer: const AdminDrawer(),
      body: Column(
        children: <Widget>[
          AppTextField(
            label: AppStrings.search,
            controller: _searchController,
            prefixIcon: Icons.search,
          ),
          const SizedBox(height: AppSizes.md),
          Expanded(
            child: logs.isEmpty
                ? const EmptyStateWidget(
                    message: AppStrings.noHistory,
                    icon: Icons.history_outlined,
                  )
                : ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final log = logs[index];
                      return AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              log.materialName,
                              style: AppTextStyles.heading3,
                            ),
                            const SizedBox(height: AppSizes.xs),
                            Text(
                              'Qty: ${log.quantityUsed.toStringAsFixed(2)}',
                              style: AppTextStyles.caption,
                            ),
                            Text(
                              'Raw: ${log.rawMaterialCost.toStringAsFixed(2)}',
                              style: AppTextStyles.caption,
                            ),
                            Text(
                              'Operator: ${log.operatorName}',
                              style: AppTextStyles.caption,
                            ),
                            Text(
                              DateFormat(
                                'dd MMM yyyy, hh:mm a',
                              ).format(log.timestamp),
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
