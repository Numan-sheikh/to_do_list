import 'package:flutter/material.dart';

class SubtaskManager extends ChangeNotifier {  // Manages subtasks
  final List<String> _subTasks = [];

  List<String> get subTasks => _subTasks;

  void addSubtask(String subtask) {
    _subTasks.add(subtask);
    notifyListeners();
  }

  void removeSubtask(String subtask) {
    _subTasks.remove(subtask);
    notifyListeners();
  }
}
