class TaskItem {
  TaskItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.completed,
  });

  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool completed;

  TaskItem copyWith({bool? completed}) {
    return TaskItem(
      id: id,
      userId: userId,
      title: title,
      description: description,
      dueDate: dueDate,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'completed': completed,
    };
  }

  factory TaskItem.fromMap(Map<dynamic, dynamic> map) {
    return TaskItem(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: DateTime.parse(map['dueDate'] as String),
      completed: map['completed'] as bool,
    );
  }
}
