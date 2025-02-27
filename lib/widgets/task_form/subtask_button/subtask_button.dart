import 'package:flutter/material.dart';

class SubtaskButton extends StatelessWidget {
  final Function(String) onSubtaskAdded; // Callback function

  const SubtaskButton({super.key, required this.onSubtaskAdded});

  void _showAddSubtaskDialog(BuildContext context) {
    TextEditingController subtaskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Subtask"),
          content: TextField(
            controller: subtaskController,
            decoration: const InputDecoration(hintText: "Enter subtask"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (subtaskController.text.isNotEmpty) {
                  onSubtaskAdded(subtaskController.text);
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showAddSubtaskDialog(context),
      icon: const Icon(Icons.add),
      label: const Text("Subtask"),
    );
  }
}
