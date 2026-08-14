class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final DateTime time;
  final bool isDone;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.isDone = false,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? date,
    DateTime? time,
    bool? isDone,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time.toIso8601String(),
      'isDone': isDone,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      date: DateTime.parse(map['date'] as String),
      time: DateTime.parse(map['time'] as String),
      isDone: map['isDone'] as bool? ?? false,
    );
  }
}