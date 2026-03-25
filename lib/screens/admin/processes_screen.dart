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

class ProcessesScreen extends StatefulWidget {
  const ProcessesScreen({super.key});

  @override
  State<ProcessesScreen> createState() => _ProcessesScreenState();
}

class _ProcessesScreenState extends State<ProcessesScreen> {
  Future<void> _openAddDialog() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController name = TextEditingController();
    final TextEditingController cost = TextEditingController();
    final TextEditingController notes = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppStrings.addProcess),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppTextField(
                    label: AppStrings.processName,
                    controller: name,
                    validator: _required,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  AppTextField(
                    label: AppStrings.additionalCost,
                    controller: cost,
                    keyboardType: TextInputType.number,
                    validator: _number,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  AppTextField(
                    label: AppStrings.notes,
                    controller: notes,
                    maxLines: 3,
                    validator: _required,
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
                await this.context.read<AppDataProvider>().addProcess(
                  name: name.text.trim(),
                  additionalCost: double.parse(cost.text.trim()),
                  notes: notes.text.trim(),
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
      title: AppStrings.processes,
      drawer: const AdminDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
      body: dataProvider.processes.isEmpty
          ? const EmptyStateWidget(
              message: AppStrings.noProcesses,
              icon: Icons.settings_suggest_outlined,
            )
          : ListView.builder(
              itemCount: dataProvider.processes.length,
              itemBuilder: (BuildContext context, int index) {
                final process = dataProvider.processes[index];
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(process.name, style: AppTextStyles.heading3),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        '${AppStrings.additionalCost}: ${process.additionalCost.toStringAsFixed(2)}',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        '${AppStrings.notes}: ${process.notes}',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      AppButton(
                        label: AppStrings.delete,
                        variant: AppButtonVariant.destructive,
                        icon: Icons.delete_outline,
                        onPressed: () => dataProvider.deleteProcess(process.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
