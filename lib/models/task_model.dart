import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String category;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  List<Subtask> subtasks;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  String priority;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.subtasks,
    required this.priority,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? category,
    DateTime? dueDate,
    List<Subtask>? subtasks,
    bool? isCompleted,
    String? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      subtasks: subtasks ?? this.subtasks,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}

@HiveType(typeId: 1)
class Subtask {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  Subtask({required this.title, this.isCompleted = false});

  Subtask copyWith({String? title, bool? isCompleted}) {
    return Subtask(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
