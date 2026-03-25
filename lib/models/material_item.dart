class MaterialItem {
  MaterialItem({
    required this.id,
    required this.name,
    required this.barcode,
    required this.unitType,
    required this.unitCost,
    required this.stock,
    required this.minStock,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String barcode;
  final String unitType;
  final double unitCost;
  final double stock;
  final double minStock;
  final DateTime createdAt;

  MaterialItem copyWith({
    String? id,
    String? name,
    String? barcode,
    String? unitType,
    double? unitCost,
    double? stock,
    double? minStock,
    DateTime? createdAt,
  }) {
    return MaterialItem(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      unitType: unitType ?? this.unitType,
      unitCost: unitCost ?? this.unitCost,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'barcode': barcode,
      'unitType': unitType,
      'unitCost': unitCost,
      'stock': stock,
      'minStock': minStock,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MaterialItem.fromMap(Map<dynamic, dynamic> map) {
    return MaterialItem(
      id: map['id'] as String,
      name: map['name'] as String,
      barcode: map['barcode'] as String,
      unitType: map['unitType'] as String,
      unitCost: (map['unitCost'] as num).toDouble(),
      stock: (map['stock'] as num).toDouble(),
      minStock: (map['minStock'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
