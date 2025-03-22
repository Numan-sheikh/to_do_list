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
  List<Task> filteredTasks = [];

  String selectedFilter = 'All';
  String selectedSort = 'None';

  @override
  void initState() {
    super.initState();
    filteredTasks = List.from(taskList);
  }

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
                _applyFiltersAndSorting(); // Refresh list
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _toggleCompletion(int index, bool? value) {
    setState(() {
      filteredTasks[index].isCompleted = value ?? false;
      int originalIndex = taskList.indexOf(filteredTasks[index]);
      taskList[originalIndex].isCompleted = value ?? false;
      _applyFiltersAndSorting();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      taskList.remove(filteredTasks[index]);
      _applyFiltersAndSorting();
    });
  }

  void _applyFiltersAndSorting() {
    // Start with full list
    List<Task> updatedList = List.from(taskList);

    // Filtering
    if (selectedFilter == 'Completed') {
      updatedList = updatedList.where((task) => task.isCompleted).toList();
    } else if (selectedFilter == 'Pending') {
      updatedList = updatedList.where((task) => !task.isCompleted).toList();
    } else if (selectedFilter != 'All') {
      updatedList = updatedList.where((task) => task.category == selectedFilter).toList();
    }

    // Sorting
    if (selectedSort == 'Due Date') {
      updatedList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (selectedSort == 'Category') {
      updatedList.sort((a, b) => a.category.compareTo(b.category));
    } else if (selectedSort == 'Completion') {
      updatedList.sort((a, b) => a.isCompleted ? 1 : -1);
    }

    setState(() {
      filteredTasks = updatedList;
    });
  }

  List<String> getAvailableCategories() {
    final categories = taskList.map((task) => task.category).toSet().toList();
    categories.sort();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
        actions: [
          // Filter Dropdown
          DropdownButton<String>(
            value: selectedFilter,
            underline: const SizedBox(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedFilter = value;
                  _applyFiltersAndSorting();
                });
              }
            },
            items: [
              const DropdownMenuItem(value: 'All', child: Text('All')),
              const DropdownMenuItem(value: 'Completed', child: Text('Completed')),
              const DropdownMenuItem(value: 'Pending', child: Text('Pending')),
              ...getAvailableCategories().map(
                (category) => DropdownMenuItem(value: category, child: Text(category)),
              ),
            ],
          ),
          const SizedBox(width: 10),

          // Sort Dropdown
          DropdownButton<String>(
            value: selectedSort,
            underline: const SizedBox(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedSort = value;
                  _applyFiltersAndSorting();
                });
              }
            },
            items: const [
              DropdownMenuItem(value: 'None', child: Text('Sort')),
              DropdownMenuItem(value: 'Due Date', child: Text('Due Date')),
              DropdownMenuItem(value: 'Category', child: Text('Category')),
              DropdownMenuItem(value: 'Completion', child: Text('Completion')),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: filteredTasks.isEmpty
          ? const Center(child: Text("No tasks match the filter."))
          : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
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
