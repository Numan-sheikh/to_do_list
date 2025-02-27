import 'package:flutter/material.dart';
import 'category_button/category_button.dart';
import 'calendar_button/calendar_button.dart';
import 'subtask_button/subtask_button.dart';
import 'submit_button/submit_button.dart';

class TaskForm extends StatelessWidget {
  const TaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensures the bottom sheet is not fullscreen
        children: [
          const Text(
            "Add Task",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: "Task Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryButton(),
              CalendarButton(),
              SubtaskButton(),
              SubmitButton(),
            ],
          ),
        ],
      ),
    );
  }
}
