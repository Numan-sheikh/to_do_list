import 'package:flutter/material.dart';
import 'category_button/category_button.dart';
import 'calendar_button/calendar_button.dart';
import 'subtask_button/subtask_button.dart';
import 'submit_button/submit_button.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController taskController = TextEditingController();
  
  // Variables to hold selected values
  String selectedCategory = "None";
  String selectedDate = "No Date Selected";
  List<String> subtasks = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task Input Field
          TextField(
            controller: taskController,
            decoration: InputDecoration(
              labelText: "Task Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              prefixIcon: const Icon(Icons.task),
            ),
          ),
          const SizedBox(height: 15),

          // Live Preview Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📌 Selected Category: $selectedCategory", style: const TextStyle(fontSize: 16)),
                  Text("📅 Due Date: $selectedDate", style: const TextStyle(fontSize: 16)),
                  Text("✅ Subtasks:", style: const TextStyle(fontSize: 16)),
                  if (subtasks.isEmpty) const Text("  - No subtasks added", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  for (String subtask in subtasks) Text("  - $subtask", style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CategoryButton(onCategorySelected: (category) {
                setState(() => selectedCategory = category);
              }),
              CalendarButton(onDateSelected: (date) {
                setState(() => selectedDate = date);
              }),
              SubtaskButton(onSubtaskAdded: (subtask) {
                setState(() => subtasks.add(subtask));
              }),
            ],
          ),

          const SizedBox(height: 20),

          // Submit Button
          SubmitButton(taskController: taskController),
        ],
      ),
    );
  }
}
