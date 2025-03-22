import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final TextEditingController taskController;
  final VoidCallback onSubmit;

  const SubmitButton({
    super.key,
    required this.taskController,
    required this.onSubmit,
  });

  void _handleSubmit(BuildContext context) {
    if (taskController.text.isNotEmpty) {
      onSubmit(); // Just call the callback
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
