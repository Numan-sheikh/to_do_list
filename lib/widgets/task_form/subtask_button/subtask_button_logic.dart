import 'package:flutter/material.dart';

class SubtaskManager extends ChangeNotifier {
  final List<String> _subtasks = [];

  List<String> get subtasks => _subtasks;

  void addSubtask(String subtask) {
    _subtasks.add(subtask);
    notifyListeners();
  }

  void removeSubtask(int index) {
    _subtasks.removeAt(index);
    notifyListeners();
  }

  void clearSubtasks() {
    _subtasks.clear();
    notifyListeners();
  }
}
