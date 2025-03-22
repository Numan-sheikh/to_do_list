class Task {
  String title;
  String category;
  String dueDate;
  List<String> subtasks;
  bool isCompleted;

  Task({
    required this.title,
    this.category = "None",
    this.dueDate = "No Date",
    this.subtasks = const [],
    this.isCompleted = false,
  });
}
