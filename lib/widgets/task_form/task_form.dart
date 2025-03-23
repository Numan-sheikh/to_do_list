import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import 'submit_button/submit_button.dart';
import 'category_button/category_button_logic.dart';
import 'calendar_button/calendar_button_logic.dart';

class TaskForm extends StatefulWidget {
  final Function(String, String, DateTime?, List<Subtask>, String) onTaskSubmit;
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
  DateTime? selectedDate;
  String selectedPriority = "Medium";

  List<Subtask> subtasks = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null) {
      final task = widget.initialTask!;
      taskController.text = task.title;
      selectedCategory = task.category;
      selectedDate = task.dueDate;
      selectedPriority = task.priority;
      subtasks = List<Subtask>.from(task.subtasks);
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
    final viewInsets = MediaQuery.of(context).viewInsets;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  labelText: "Task Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.task),
                ),
              ),
              const SizedBox(height: 15),

              // Card with Info
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _buildInfoRow(
                          Icons.category, "Category", selectedCategory),
                      const Divider(),
                      _buildInfoRow(
                        Icons.calendar_today,
                        "Due Date",
                        selectedDate != null
                            ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at ${selectedDate!.hour.toString().padLeft(2, '0')}:${selectedDate!.minute.toString().padLeft(2, '0')}"
                            : "No Date",
                      ),
                      const Divider(),
                      _buildInfoRow(Icons.flag, "Priority", selectedPriority),
                      const Divider(),
                      _buildSubtaskList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Bottom buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomButton(
                      Icons.category, "Category", _selectCategory),
                  _buildBottomButton(
                      Icons.calendar_today, "Due Date", _selectDate),
                  _buildBottomButton(
                      Icons.priority_high, "Priority", _selectPriority),
                  _buildBottomButton(
                      Icons.playlist_add, "Subtask", _addSubtask),
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
                    selectedPriority,
                  );
                },
              ),
            ],
          ),
        ),
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
        ...subtasks.map(
          (sub) => Padding(
            padding: const EdgeInsets.only(left: 20, top: 5),
            child: Row(
              children: [
                Checkbox(
                  value: sub.isCompleted,
                  onChanged: (val) {
                    setState(() {
                      final index = subtasks.indexOf(sub);
                      if (index != -1) {
                        subtasks[index] =
                            sub.copyWith(isCompleted: val ?? false);
                      }
                    });
                  },
                ),
                Expanded(child: Text(sub.title)),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: () {
                    setState(() {
                      subtasks.remove(sub);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
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

  void _selectCategory() async {
    String? newCategory = await CategoryButtonLogic.selectCategory(context);
    if (!mounted) return;
    if (newCategory != null) {
      setState(() {
        selectedCategory = newCategory;
      });
    }
  }

  void _selectDate() async {
    DateTime? pickedDateTime =
        (await CalendarButtonLogic.selectDueDateTime(context)) as DateTime?;
    if (!mounted) return;
    if (pickedDateTime != null) {
      setState(() {
        selectedDate = pickedDateTime;
      });
    }
  }

  void _selectPriority() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: ["High", "Medium", "Low"].map((priority) {
            return ListTile(
              title: Text(priority),
              leading: Radio<String>(
                value: priority,
                groupValue: selectedPriority,
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

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
                        subtasks.add(Subtask(
                          title: subtaskController.text,
                          isCompleted: false,
                        ));
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
