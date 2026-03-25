import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_scaffold.dart';

class SyncCenterScreen extends StatelessWidget {
  const SyncCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDataProvider provider = context.watch<AppDataProvider>();

    return AppScaffold(
      title: AppStrings.syncCenter,
      drawer: const AdminDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${AppStrings.pendingSync}: ${provider.pendingSync.length}',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  '${AppStrings.lastSynced}: ${provider.lastSyncedAt == null ? AppStrings.noData : DateFormat('dd MMM yyyy, hh:mm a').format(provider.lastSyncedAt!)}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          AppButton(
            label: AppStrings.syncNow,
            icon: Icons.sync,
            onPressed: () async {
              await context.read<AppDataProvider>().syncNow();
              if (!context.mounted) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.operationSuccessful)),
              );
            },
          ),
          const SizedBox(height: AppSizes.md),
          Expanded(
            child: ListView.builder(
              itemCount: provider.pendingSync.length,
              itemBuilder: (BuildContext context, int index) {
                final item = provider.pendingSync[index];
                return AppCard(
                  child: Text(item['action'] as String? ?? AppStrings.noData),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
