class UsageLog {
  UsageLog({
    required this.id,
    required this.materialId,
    required this.materialName,
    required this.quantityUsed,
    required this.unitCost,
    required this.additionalProcessingCost,
    required this.marginPercent,
    required this.operatorId,
    required this.operatorName,
    required this.timestamp,
  });

  final String id;
  final String materialId;
  final String materialName;
  final double quantityUsed;
  final double unitCost;
  final double additionalProcessingCost;
  final double marginPercent;
  final String operatorId;
  final String operatorName;
  final DateTime timestamp;

  double get rawMaterialCost => unitCost * quantityUsed;

  double get manufacturingCost => rawMaterialCost + additionalProcessingCost;

  double get finalProductPrice =>
      manufacturingCost * (1 + (marginPercent / 100));

  double get profitMarginValue => finalProductPrice - manufacturingCost;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'materialId': materialId,
      'materialName': materialName,
      'quantityUsed': quantityUsed,
      'unitCost': unitCost,
      'additionalProcessingCost': additionalProcessingCost,
      'marginPercent': marginPercent,
      'operatorId': operatorId,
      'operatorName': operatorName,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory UsageLog.fromMap(Map<dynamic, dynamic> map) {
    return UsageLog(
      id: map['id'] as String,
      materialId: map['materialId'] as String,
      materialName: map['materialName'] as String,
      quantityUsed: (map['quantityUsed'] as num).toDouble(),
      unitCost: (map['unitCost'] as num).toDouble(),
      additionalProcessingCost: (map['additionalProcessingCost'] as num)
          .toDouble(),
      marginPercent: (map['marginPercent'] as num).toDouble(),
      operatorId: map['operatorId'] as String,
      operatorName: map['operatorName'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
