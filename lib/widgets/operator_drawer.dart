import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/constants.dart';
import '../providers/auth_provider.dart';

class OperatorDrawer extends StatelessWidget {
  const OperatorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              AppStrings.operatorDashboard,
              style: AppTextStyles.heading2,
            ),
          ),
          _tile(
            context,
            AppStrings.operatorDashboard,
            Icons.dashboard_customize_outlined,
            AppRoutes.operatorDashboard,
          ),
          _tile(
            context,
            AppStrings.scanAndLog,
            Icons.qr_code_scanner_outlined,
            AppRoutes.scanLog,
          ),
          _tile(
            context,
            AppStrings.tasks,
            Icons.assignment_outlined,
            AppRoutes.tasks,
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
