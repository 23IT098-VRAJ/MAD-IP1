import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/helpers.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final AppDataProvider dataProvider = context.read<AppDataProvider>();
    final AuthProvider authProvider = context.read<AuthProvider>();

    authProvider.clearError();

    final bool success = await authProvider.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      dataProvider: dataProvider,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? AppStrings.invalidCredentials,
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.roleRouter);
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ResponsiveUtils.isTablet(context);
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final AppDataProvider dataProvider = context.watch<AppDataProvider>();

    if (dataProvider.isLoading) {
      return const Scaffold(body: AppLoader());
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet
                    ? ResponsiveUtils.rWidth(context, 0.55)
                    : ResponsiveUtils.rWidth(context, 0.95),
              ),
              child: AppCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(AppStrings.appTitle, style: AppTextStyles.heading2),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        AppStrings.loginSubtitle,
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: AppSizes.lg),
                      AppTextField(
                        label: AppStrings.username,
                        controller: _usernameController,
                        prefixIcon: Icons.person_outline,
                        validator: (String? value) {
                          if ((value ?? '').trim().isEmpty) {
                            return AppStrings.requiredField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.md),
                      AppTextField(
                        label: AppStrings.password,
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: Icons.lock_outline,
                        validator: (String? value) {
                          if ((value ?? '').trim().isEmpty) {
                            return AppStrings.requiredField;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.lg),
                      AppButton(
                        label: AppStrings.signIn,
                        onPressed: authProvider.isLoading ? null : _submit,
                        icon: Icons.login,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        'Use admin/admin123 or operator/operator123',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
