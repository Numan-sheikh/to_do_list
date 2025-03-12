import 'package:flutter/material.dart';
import '../widgets/task_form/task_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "None";
  String selectedDate = "No Date"; // Default value if no date is picked
  List<String> subtasks = [];

  void _showTaskForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: TaskForm(
            selectedCategory: selectedCategory,
            selectedDate: selectedDate,
            subtasks: subtasks,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
            onSubtasksUpdated: (updatedSubtasks) {
              setState(() {
                subtasks = updatedSubtasks;
              });
            },
          ),
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
