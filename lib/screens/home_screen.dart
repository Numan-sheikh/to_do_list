import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';
import '../widgets/task_tile.dart';
import '../widgets/task_form/task_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Task> tasks = [];
  String searchQuery = "";
  String filter = "All";
  String selectedCategory = "All";

  bool sortByDateAsc = true;
  bool sortByPriorityAsc = true;

  late Box<Task> taskBox;

  @override
  void initState() {
    super.initState();
    _loadTasksFromHive();
  }

  Future<void> _loadTasksFromHive() async {
    taskBox = await Hive.openBox<Task>('tasks');
    setState(() {
      tasks = taskBox.values.toList();
    });
  }

  Future<void> _saveTasksToHive() async {
    await taskBox.clear();
    for (var task in tasks) {
      await taskBox.add(task);
    }
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
      _saveTasksToHive();
    });
    _listKey.currentState?.insertItem(tasks.length - 1);
  }

  void _editTask(Task updatedTask) {
    setState(() {
      final index = tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
        _saveTasksToHive();
      }
    });
  }

  void _deleteTask(Task task) {
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      setState(() {
        tasks.removeAt(index);
        _saveTasksToHive();
      });
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: TaskTile(
            task: task,
            onDelete: () {},
            onEdit: (_) {},
            onSubtaskToggle: (_) {},
            onToggleTaskComplete: (isCompleted) => _toggleTaskComplete(task),
          ),
        ),
      );
    }
  }

  void _toggleSubtask(Task task, Subtask subtask) {
    setState(() {
      final taskIndex = tasks.indexWhere((t) => t.id == task.id);
      if (taskIndex != -1) {
        final subIndex = tasks[taskIndex]
            .subtasks
            .indexWhere((s) => s.title == subtask.title);
        if (subIndex != -1) {
          tasks[taskIndex].subtasks[subIndex] =
              subtask.copyWith(isCompleted: !subtask.isCompleted);
          _saveTasksToHive();
        }
      }
    });
  }

  void _toggleTaskComplete(Task task) {
    setState(() {
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
        _saveTasksToHive();
      }
    });
  }

  void _openTaskForm({Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return TaskForm(
          initialTask: task,
          onTaskSubmit: (title, category, dueDate, subtasks, priority) {
            final newTask = Task(
              id: task?.id ?? DateTime.now().toString(),
              title: title,
              category: category,
              dueDate: dueDate ?? DateTime.now(),
              subtasks: subtasks,
              priority: priority,
              isCompleted: task?.isCompleted ?? false,
            );
            if (task == null) {
              _addTask(newTask);
            } else {
              _editTask(newTask);
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  List<String> _getAllCategories() {
    final categories = tasks.map((task) => task.category).toSet().toList();
    categories.sort();
    return ["All", ...categories];
  }

  List<Task> _getFilteredTasks() {
    return tasks.where((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = filter == "All" ||
          (filter == "Completed" && task.isCompleted) ||
          (filter == "Pending" && !task.isCompleted);
      final matchesCategory =
          selectedCategory == "All" || task.category == selectedCategory;

      return matchesSearch && matchesFilter && matchesCategory;
    }).toList();
  }

  void _sortByDueDate() {
    setState(() {
      tasks.sort((a, b) => sortByDateAsc
          ? (a.dueDate ?? DateTime(2100)).compareTo(b.dueDate ?? DateTime(2100))
          : (b.dueDate ?? DateTime(2100))
              .compareTo(a.dueDate ?? DateTime(2100)));
      sortByDateAsc = !sortByDateAsc;
      _saveTasksToHive();
    });
  }

  void _sortByPriority() {
    const priorityMap = {'High': 0, 'Medium': 1, 'Low': 2};
    setState(() {
      tasks.sort((a, b) => sortByPriorityAsc
          ? (priorityMap[a.priority] ?? 3)
              .compareTo(priorityMap[b.priority] ?? 3)
          : (priorityMap[b.priority] ?? 3)
              .compareTo(priorityMap[a.priority] ?? 3));
      sortByPriorityAsc = !sortByPriorityAsc;
      _saveTasksToHive();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My To-Do List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // 🧮 Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                FilterChip(
                  label: const Text("All"),
                  selected: filter == "All",
                  onSelected: (_) => setState(() => filter = "All"),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text("Pending"),
                  selected: filter == "Pending",
                  onSelected: (_) => setState(() => filter = "Pending"),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text("Completed"),
                  selected: filter == "Completed",
                  onSelected: (_) => setState(() => filter = "Completed"),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: _getAllCategories()
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedCategory = val!),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📋 Task List or Empty State
          Expanded(
            child: filteredTasks.isNotEmpty
                ? AnimatedList(
                    key: _listKey,
                    initialItemCount: filteredTasks.length,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index, animation) {
                      final task = filteredTasks[index];
                      return SizeTransition(
                        sizeFactor: animation,
                        child: TaskTile(
                          key: ValueKey(task.id),
                          task: task,
                          onDelete: () => _deleteTask(task),
                          onEdit: (taskToEdit) =>
                              _openTaskForm(task: taskToEdit),
                          onSubtaskToggle: (subtask) =>
                              _toggleSubtask(task, subtask),
                          onToggleTaskComplete: (isCompleted) =>
                              _toggleTaskComplete(task),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_rounded, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("No tasks match your criteria!",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  ),
          ),
        ],
      ),

      // 🚀 Expandable FAB
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        overlayOpacity: 0.3,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add_task),
            label: 'Add Task',
            onTap: () => _openTaskForm(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.sort),
            label: sortByDateAsc ? 'Sort by Date ↑' : 'Sort by Date ↓',
            onTap: _sortByDueDate,
          ),
          SpeedDialChild(
            child: const Icon(Icons.priority_high),
            label:
                sortByPriorityAsc ? 'Sort by Priority ↑' : 'Sort by Priority ↓',
            onTap: _sortByPriority,
          ),
        ],
      ),
    );
  }
}
