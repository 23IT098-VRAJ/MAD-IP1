import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../providers/app_data_provider.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_scaffold.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDataProvider dataProvider = context.watch<AppDataProvider>();
    final summary = dataProvider.buildReportSummary();

    return AppScaffold(
      title: AppStrings.reports,
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _summaryCard(AppStrings.rawMaterialCost, summary.rawMaterialCost),
            _summaryCard('Processing Cost', summary.processingCost),
            _summaryCard(
              AppStrings.manufacturingCost,
              summary.manufacturingCost,
            ),
            _summaryCard(
              AppStrings.suggestedPrice,
              summary.suggestedSellingPrice,
            ),
            _summaryCard(AppStrings.profitMargin, summary.profitMarginValue),
            const SizedBox(height: AppSizes.md),
            AppButton(
              label: AppStrings.exportCsv,
              icon: Icons.table_chart_outlined,
              onPressed: () {
                final String csv = dataProvider.buildCsvReport();
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(AppStrings.csvPreview),
                      content: SingleChildScrollView(
                        child: Text(csv, style: AppTextStyles.caption),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(AppStrings.cancel),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: AppSizes.sm),
            AppButton(
              label: AppStrings.exportPdf,
              icon: Icons.picture_as_pdf_outlined,
              onPressed: () async {
                final Uint8List bytes = await dataProvider.buildPdfReport();
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${AppStrings.pdfGenerated} (${bytes.lengthInBytes} bytes)',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String label, double value) {
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: AppTextStyles.body),
          Text(value.toStringAsFixed(2), style: AppTextStyles.heading3),
        ],
      ),
    );
  }
}
