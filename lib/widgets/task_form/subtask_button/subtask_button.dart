import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subtask_button_logic.dart';

class SubtaskButton extends StatelessWidget {
  const SubtaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubtaskManager>(
      builder: (context, subtaskManager, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Button to add a new subtask
            ElevatedButton.icon(
              onPressed: () => _showSubtaskDialog(context, subtaskManager),
              icon: const Icon(Icons.add),
              label: const Text("Add Subtask"),
            ),
            const SizedBox(height: 10),

            // Displaying the list of subtasks
            Column(
              children: subtaskManager.subTasks.map((subtask) {
                return ListTile(
                  title: Text(subtask),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => subtaskManager.removeSubtask(subtask),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  // Function to show a dialog for adding a subtask
  void _showSubtaskDialog(BuildContext context, SubtaskManager subtaskManager) {
    TextEditingController subtaskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
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
            ElevatedButton(
              onPressed: () {
                if (subtaskController.text.isNotEmpty) {
                  subtaskManager.addSubtask(subtaskController.text);
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
}
