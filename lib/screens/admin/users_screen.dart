import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../models/app_user.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state_widget.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Future<void> _openAddDialog() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController fullName = TextEditingController();
    final TextEditingController username = TextEditingController();
    final TextEditingController password = TextEditingController();
    UserRole selectedRole = UserRole.operator;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(AppStrings.addUser),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppTextField(
                        label: AppStrings.fullName,
                        controller: fullName,
                        validator: _required,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      AppTextField(
                        label: AppStrings.username,
                        controller: username,
                        validator: _required,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      AppTextField(
                        label: AppStrings.password,
                        controller: password,
                        validator: _required,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      DropdownButtonFormField<UserRole>(
                        value: selectedRole,
                        items: UserRole.values
                            .map(
                              (UserRole role) => DropdownMenuItem<UserRole>(
                                value: role,
                                child: Text(role.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (UserRole? role) {
                          if (role == null) {
                            return;
                          }
                          setState(() {
                            selectedRole = role;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: AppStrings.role,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(AppStrings.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    if (!(formKey.currentState?.validate() ?? false)) {
                      return;
                    }
                    final NavigatorState navigator = Navigator.of(context);
                    await this.context.read<AppDataProvider>().addUser(
                      username: username.text.trim(),
                      password: password.text.trim(),
                      role: selectedRole,
                      fullName: fullName.text.trim(),
                    );
                    if (!mounted) {
                      return;
                    }
                    navigator.pop();
                  },
                  child: const Text(AppStrings.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String? _required(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return AppStrings.requiredField;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AppDataProvider dataProvider = context.watch<AppDataProvider>();

    return AppScaffold(
      title: AppStrings.users,
      drawer: const AdminDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.person_add_alt_1_outlined),
      ),
      body: dataProvider.users.isEmpty
          ? const EmptyStateWidget(
              message: AppStrings.noUsers,
              icon: Icons.people_outline,
            )
          : ListView.builder(
              itemCount: dataProvider.users.length,
              itemBuilder: (BuildContext context, int index) {
                final AppUser user = dataProvider.users[index];
                return AppCard(
                  child: ListTile(
                    leading: Icon(
                      user.role == UserRole.admin
                          ? Icons.admin_panel_settings
                          : Icons.engineering,
                    ),
                    title: Text(user.fullName),
                    subtitle: Text(
                      '${user.username} - ${user.role.name.toUpperCase()}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
