import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class TaskForm extends StatefulWidget {
  final TextEditingController titleController;
  final VoidCallback onSave;

  const TaskForm({
    super.key,
    required this.titleController,
    required this.onSave, required TextEditingController descriptionController,
  });

  @override
  TaskFormState createState() => TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  String? _selectedCategory;
  DateTime? dueDate;
  final List<String> _subTasks = [];
  final TextEditingController _subTaskController = TextEditingController();

  void _selectCategory() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ["Work", "Personal", "Shopping", "Fitness", "No Category"].map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = selected ? category : null);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        dueDate = pickedDate;
      });
    }
  }

  void _addSubTask() {
    if (_subTaskController.text.isNotEmpty) {
      setState(() {
        _subTasks.add(_subTaskController.text);
        _subTaskController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Task Input Field
          TextField(
            controller: widget.titleController,
            decoration: const InputDecoration(
              labelText: "New Task",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),

          // Subtasks Display
          if (_subTasks.isNotEmpty) ...[
            Column(
              children: _subTasks.map((subtask) => ListTile(
                title: Text(subtask),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() => _subTasks.remove(subtask));
                  },
                ),
              )).toList(),
            ),
            const SizedBox(height: 10),
          ],

          // Bottom Navigation Bar
          Row(
            children: [
              // Submit Button
              FloatingActionButton(
                onPressed: widget.onSave,
                backgroundColor: Colors.green,
                elevation: 3,
                child: const Icon(Icons.check, size: 28),
              ),
              const SizedBox(width: 10),

              // Bottom Buttons
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.category, size: 30),
                      onPressed: _selectCategory,
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today, size: 30),
                      onPressed: _pickDueDate,
                    ),
                    IconButton(
                      icon: const Icon(Icons.subdirectory_arrow_right, size: 30),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Add Subtask"),
                              content: TextField(
                                controller: _subTaskController,
                                decoration: const InputDecoration(labelText: "Subtask Name"),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _addSubTask();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Add"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
