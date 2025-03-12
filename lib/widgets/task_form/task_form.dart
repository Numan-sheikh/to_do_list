import 'package:flutter/material.dart';
import 'submit_button/submit_button.dart';

class TaskForm extends StatelessWidget {
  final TextEditingController taskController = TextEditingController();
  final String selectedCategory;
  final String selectedDate;
  final List<String> subtasks;
  final Function(String) onCategorySelected;
  final Function(String) onDateSelected;
  final Function(List<String>) onSubtasksUpdated;

  TaskForm({
    super.key,
    required this.selectedCategory,
    required this.selectedDate,
    required this.subtasks,
    required this.onCategorySelected,
    required this.onDateSelected,
    required this.onSubtasksUpdated,
  });

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

          // Card Displaying Selected Category, Date, and Subtasks
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildInfoRow(Icons.category, "Category", selectedCategory),
                  const Divider(),
                  _buildInfoRow(Icons.calendar_today, "Due Date", selectedDate),
                  const Divider(),
                  _buildSubtaskList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Bottom Navigation Bar Style Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomButton(Icons.category, "Category", () {
                _selectCategory(context);
              }),
              _buildBottomButton(Icons.calendar_today, "Due Date", () {
                _selectDate(context);
              }),
              _buildBottomButton(Icons.playlist_add, "Subtask", () {
                _addSubtask(context);
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

  // Helper Method for Category, Date Rows
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(value, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Helper Method for Subtask List
  Widget _buildSubtaskList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.list, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text("Subtasks", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 5),
        ...subtasks.map((subtask) => Padding(
              padding: const EdgeInsets.only(left: 30, top: 5),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 10),
                  Text(subtask),
                ],
              ),
            )),
      ],
    );
  }

  // Helper Method for Bottom Bar Buttons
  Widget _buildBottomButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _selectCategory(BuildContext context) async {
    // Example: Show a dialog to pick a category
    String? newCategory = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Category"),
          content: const Text("Example categories: Work, Personal, Shopping"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "Work"),
              child: const Text("Work"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, "Personal"),
              child: const Text("Personal"),
            ),
          ],
        );
      },
    );

    if (newCategory != null) {
      onCategorySelected(newCategory);
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate.toLocal().toString().split(' ')[0]);
    }
  }

  void _addSubtask(BuildContext context) {
    // Implement subtask logic here
  }
}
