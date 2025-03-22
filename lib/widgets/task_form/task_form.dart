import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import 'submit_button/submit_button.dart';
import 'category_button/category_button_logic.dart';
import 'calendar_button/calendar_button_logic.dart';

class TaskForm extends StatefulWidget {
  final Function(String, String, String, List<String>) onTaskSubmit;
  final Task? initialTask;

  const TaskForm({
    super.key,
    required this.onTaskSubmit,
    this.initialTask,
  });

  @override
  TaskFormState createState() => TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController subtaskController = TextEditingController();

  String selectedCategory = "None";
  String selectedDate = "No Date";
  List<String> subtasks = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null) {
      final task = widget.initialTask!;
      taskController.text = task.title;
      selectedCategory = task.category;
      selectedDate = task.dueDate;
      subtasks = List<String>.from(task.subtasks);
    }
  }

  @override
  void dispose() {
    taskController.dispose();
    subtaskController.dispose();
    super.dispose();
  }

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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              prefixIcon: const Icon(Icons.task),
            ),
          ),
          const SizedBox(height: 15),

          // Card with Category, Date, Subtasks
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

          // Bottom Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomButton(Icons.category, "Category", _selectCategory),
              _buildBottomButton(Icons.calendar_today, "Due Date", _selectDate),
              _buildBottomButton(Icons.playlist_add, "Subtask", _addSubtask),
            ],
          ),

          const SizedBox(height: 20),

          // Submit Button
          SubmitButton(
            taskController: taskController,
            onSubmit: () {
              widget.onTaskSubmit(
                taskController.text,
                selectedCategory,
                selectedDate,
                subtasks,
              );
            },
          ),
        ],
      ),
    );
  }

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

  Widget _buildBottomButton(
      IconData icon, String label, VoidCallback onPressed) {
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

  // ✅ Category Selection Logic
  void _selectCategory() async {
    String? newCategory = await CategoryButtonLogic.selectCategory(context);
    if (!mounted) return;
    if (newCategory != null) {
      setState(() {
        selectedCategory = newCategory;
      });
    }
  }

  // ✅ Date & Time Selection
  void _selectDate() async {
    Map<String, String>? dateTime =
        await CalendarButtonLogic.selectDueDateTime(context);
    if (!mounted) return;
    setState(() {
      selectedDate = "${dateTime["date"]} at ${dateTime["time"]}";
    });
  }

  // ✅ Subtask Modal
  void _addSubtask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: subtaskController,
                  decoration: const InputDecoration(
                    labelText: "Enter Subtask",
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (subtaskController.text.isNotEmpty) {
                      setState(() {
                        subtasks.add(subtaskController.text);
                        subtaskController.clear();
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add Subtask"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
