import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/constants.dart';
import '../providers/auth_provider.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              AppStrings.adminDashboard,
              style: AppTextStyles.heading2,
            ),
          ),
          _tile(
            context,
            AppStrings.adminDashboard,
            Icons.dashboard_outlined,
            AppRoutes.adminDashboard,
          ),
          _tile(
            context,
            AppStrings.materials,
            Icons.inventory_2_outlined,
            AppRoutes.materials,
          ),
          _tile(
            context,
            AppStrings.processes,
            Icons.settings_suggest_outlined,
            AppRoutes.processes,
          ),
          _tile(
            context,
            AppStrings.users,
            Icons.people_outline,
            AppRoutes.users,
          ),
          _tile(
            context,
            AppStrings.inventoryHistory,
            Icons.history_outlined,
            AppRoutes.inventoryHistory,
          ),
          _tile(
            context,
            AppStrings.reports,
            Icons.bar_chart_outlined,
            AppRoutes.reports,
          ),
          _tile(
            context,
            AppStrings.syncCenter,
            Icons.sync_outlined,
            AppRoutes.syncCenter,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(AppStrings.signOut),
            onTap: () {
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  ListTile _tile(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
