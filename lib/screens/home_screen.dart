import 'package:flutter/material.dart';
import '../widgets/task_form/task_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showTaskForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet cover most of the screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: TaskForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("To-Do List")),
      body: const Center(child: Text("Your tasks will appear here")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
