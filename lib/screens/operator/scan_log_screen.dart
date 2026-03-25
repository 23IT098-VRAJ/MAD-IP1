import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../models/app_user.dart';
import '../../providers/app_data_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/operator_drawer.dart';

class ScanLogScreen extends StatefulWidget {
  const ScanLogScreen({super.key});

  @override
  State<ScanLogScreen> createState() => _ScanLogScreenState();
}

class _ScanLogScreenState extends State<ScanLogScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _additionalCostController =
      TextEditingController();
  final TextEditingController _marginController = TextEditingController(
    text: '20',
  );

  bool _isScannerVisible = false;

  @override
  void dispose() {
    _barcodeController.dispose();
    _qtyController.dispose();
    _additionalCostController.dispose();
    _marginController.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return AppStrings.requiredField;
    }
    if (double.tryParse(value ?? '') == null &&
        value != _barcodeController.text) {
      return AppStrings.invalidNumber;
    }
    return null;
  }

  Future<void> _submitLog() async {
    final bool valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    final AppUser? user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      return;
    }

    final AppDataProvider dataProvider = context.read<AppDataProvider>();
    final bool success = await dataProvider.logConsumption(
      barcode: _barcodeController.text.trim(),
      quantityUsed: double.parse(_qtyController.text.trim()),
      additionalProcessingCost: double.parse(
        _additionalCostController.text.trim(),
      ),
      marginPercent: double.parse(_marginController.text.trim()),
      operator: user,
    );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.stockInsufficient)),
      );
      return;
    }

    _qtyController.clear();
    _additionalCostController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.operationSuccessful)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.scanAndLog,
      drawer: const OperatorDrawer(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              AppCard(
                child: Column(
                  children: <Widget>[
                    AppTextField(
                      label: AppStrings.barcode,
                      controller: _barcodeController,
                      validator: (String? value) => (value ?? '').trim().isEmpty
                          ? AppStrings.requiredField
                          : null,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    AppButton(
                      label: _isScannerVisible
                          ? 'Hide Scanner'
                          : 'Open Scanner',
                      icon: Icons.qr_code_scanner_outlined,
                      onPressed: () {
                        setState(() {
                          _isScannerVisible = !_isScannerVisible;
                        });
                      },
                    ),
                    if (_isScannerVisible) ...<Widget>[
                      const SizedBox(height: AppSizes.sm),
                      SizedBox(
                        height: 250,
                        child: MobileScanner(
                          onDetect: (BarcodeCapture capture) {
                            final String? value =
                                capture.barcodes.first.rawValue;
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _barcodeController.text = value;
                              _isScannerVisible = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              AppCard(
                child: Column(
                  children: <Widget>[
                    AppTextField(
                      label: AppStrings.quantityUsed,
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      validator: _required,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    AppTextField(
                      label: AppStrings.additionalCost,
                      controller: _additionalCostController,
                      keyboardType: TextInputType.number,
                      validator: _required,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    AppTextField(
                      label: AppStrings.desiredMargin,
                      controller: _marginController,
                      keyboardType: TextInputType.number,
                      validator: _required,
                    ),
                    const SizedBox(height: AppSizes.md),
                    AppButton(
                      label: AppStrings.save,
                      icon: Icons.save_outlined,
                      onPressed: _submitLog,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
