import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final TextEditingController taskController;

  const SubmitButton({super.key, required this.taskController});

  void _handleSubmit(BuildContext context) {
    if (taskController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task Added: ${taskController.text}")),
      );
      Navigator.pop(context); // Close bottom sheet after submission
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a task name!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _handleSubmit(context),
      icon: const Icon(Icons.check),
      label: const Text("Add Task"),
    );
  }
}
