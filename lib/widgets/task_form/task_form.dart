import 'package:flutter/material.dart';
import 'subtask_list.dart';
import 'category_selector.dart';
import 'task_buttons.dart';

class TaskForm extends StatefulWidget {
  final TextEditingController titleController;
  final VoidCallback onSave;

  const TaskForm({super.key, required this.titleController, required this.onSave});

  @override
  TaskFormState createState() => TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  final TextEditingController _subTaskController = TextEditingController();
  final List<String> _subTasks = [];
  bool _showSubTaskField = false;
  Map<String, dynamic>? selectedCategory;

  void _addSubTask() {
    if (_subTaskController.text.isNotEmpty) {
      setState(() {
        _subTasks.add(_subTaskController.text);
        _subTaskController.clear();
      });
    }
  }

  void _selectCategory() async {
    final selected = await showCategorySelector(context);
    if (selected != null) {
      setState(() => selectedCategory = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.titleController,
            decoration: const InputDecoration(
              labelText: "New Task",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          if (_showSubTaskField)
            TextField(
              controller: _subTaskController,
              decoration: InputDecoration(
                labelText: "Add a Subtask",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addSubTask,
                ),
              ),
            ),
          const SizedBox(height: 10),
          SubtaskList(subTasks: _subTasks, onRemove: (task) {
            setState(() => _subTasks.remove(task));
          }),
          TaskButtons(
            onSave: widget.onSave,
            onCategorySelect: _selectCategory,
            onToggleSubTask: () {
              setState(() => _showSubTaskField = !_showSubTaskField);
            },
          ),
        ],
      ),
    );
  }
}
