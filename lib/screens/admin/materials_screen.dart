import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state_widget.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  Future<void> _openAddDialog() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController name = TextEditingController();
    final TextEditingController barcode = TextEditingController();
    final TextEditingController unit = TextEditingController();
    final TextEditingController unitCost = TextEditingController();
    final TextEditingController stock = TextEditingController();
    final TextEditingController minStock = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppStrings.addMaterial),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppTextField(
                    label: AppStrings.materialName,
                    controller: name,
                    validator: _required,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  AppTextField(
                    label: AppStrings.barcode,
                    controller: barcode,
                    validator: _required,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  AppTextField(
                    label: AppStrings.unitType,
                    controller: unit,
                    validator: _required,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  AppTextField(
                    label: AppStrings.unitCost,
                    controller: unitCost,
                    keyboardType: TextInputType.number,
                    validator: _number,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  AppTextField(
                    label: AppStrings.stock,
                    controller: stock,
                    keyboardType: TextInputType.number,
                    validator: _number,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  AppTextField(
                    label: AppStrings.minStock,
                    controller: minStock,
                    keyboardType: TextInputType.number,
                    validator: _number,
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
                await this.context.read<AppDataProvider>().addMaterial(
                  name: name.text.trim(),
                  barcode: barcode.text.trim(),
                  unitType: unit.text.trim(),
                  unitCost: double.parse(unitCost.text.trim()),
                  stock: double.parse(stock.text.trim()),
                  minStock: double.parse(minStock.text.trim()),
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
  }

  String? _required(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return AppStrings.requiredField;
    }
    return null;
  }

  String? _number(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return AppStrings.requiredField;
    }
    if (double.tryParse(value ?? '') == null) {
      return AppStrings.invalidNumber;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AppDataProvider dataProvider = context.watch<AppDataProvider>();

    return AppScaffold(
      title: AppStrings.materials,
      drawer: const AdminDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
      body: dataProvider.materials.isEmpty
          ? const EmptyStateWidget(
              message: AppStrings.noMaterials,
              icon: Icons.inventory_2_outlined,
            )
          : ListView.builder(
              itemCount: dataProvider.materials.length,
              itemBuilder: (BuildContext context, int index) {
                final material = dataProvider.materials[index];
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(material.name, style: AppTextStyles.heading3),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        '${AppStrings.barcode}: ${material.barcode}',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        '${AppStrings.unitType}: ${material.unitType}',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        '${AppStrings.unitCost}: ${material.unitCost.toStringAsFixed(2)}',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        '${AppStrings.stock}: ${material.stock.toStringAsFixed(2)}',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      AppButton(
                        label: AppStrings.delete,
                        variant: AppButtonVariant.destructive,
                        icon: Icons.delete_outline,
                        onPressed: () =>
                            dataProvider.deleteMaterial(material.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
