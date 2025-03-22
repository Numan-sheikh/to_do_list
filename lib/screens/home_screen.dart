import 'package:flutter/material.dart';
import '../widgets/task_tile.dart';
import '../models/task_model.dart';
import '../widgets/task_form/task_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> taskList = [];

  void _openTaskForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: TaskForm(
            onTaskSubmit: (title, category, dueDate, subtasks) {
              final newTask = Task(
                title: title,
                category: category,
                dueDate: dueDate,
                subtasks: subtasks,
                isCompleted: false,
              );
              setState(() {
                taskList.add(newTask);
              });
              Navigator.pop(context); // ✅ ONLY HERE
            },
          ),
        );
      },
    );
  }

  void _toggleCompletion(int index, bool? value) {
    setState(() {
      taskList[index].isCompleted = value ?? false;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      taskList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
      ),
      body: taskList.isEmpty
          ? const Center(child: Text("No tasks yet. Add one!"))
          : ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];
                return TaskTile(
                  task: task,
                  onChanged: (value) => _toggleCompletion(index, value),
                  onDelete: () => _deleteTask(index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openTaskForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
