class ReportSummary {
  ReportSummary({
    required this.rawMaterialCost,
    required this.processingCost,
    required this.manufacturingCost,
    required this.suggestedSellingPrice,
    required this.profitMarginValue,
  });

  final double rawMaterialCost;
  final double processingCost;
  final double manufacturingCost;
  final double suggestedSellingPrice;
  final double profitMarginValue;
}
