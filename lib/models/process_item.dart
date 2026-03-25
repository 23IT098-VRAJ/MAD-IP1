class ProcessItem {
  ProcessItem({
    required this.id,
    required this.name,
    required this.additionalCost,
    required this.notes,
    required this.createdAt,
  });

  final String id;
  final String name;
  final double additionalCost;
  final String notes;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'additionalCost': additionalCost,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ProcessItem.fromMap(Map<dynamic, dynamic> map) {
    return ProcessItem(
      id: map['id'] as String,
      name: map['name'] as String,
      additionalCost: (map['additionalCost'] as num).toDouble(),
      notes: map['notes'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
