import 'package:flutter/material.dart';

import '../models/task_model.dart';

// Utility for formatting due date
String getFormattedDueDate(DateTime dueDate) {
  final now = DateTime.now();
  final difference =
      dueDate.difference(DateTime(now.year, now.month, now.day)).inDays;

  if (difference == 0) return "Due today";
  if (difference == 1) return "Due tomorrow";
  if (difference > 1) return "Due in $difference days";
  if (difference == -1) return "Overdue by 1 day";
  return "Overdue by ${-difference} days";
}

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  final Function(Task) onEdit;
  final Function(Subtask) onSubtaskToggle;
  final Function(bool) onToggleTaskComplete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onSubtaskToggle,
    required this.onToggleTaskComplete,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.task.id),
      background: _swipeActionLeft(),
      secondaryBackground: _swipeActionRight(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Confirm Delete"),
              content: const Text("Are you sure you want to delete this task?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child:
                      const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          return confirm ?? false;
        } else {
          widget.onEdit(widget.task);
          return false;
        }
      },
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Row: Checkbox, Title, Priority
              Row(
                children: [
                  Checkbox(
                    value: widget.task.isCompleted,
                    onChanged: (value) =>
                        widget.onToggleTaskComplete(value ?? false),
                  ),
                  Expanded(
                    child: Text(
                      widget.task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: widget.task.isCompleted
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                  _buildPriorityBadge(widget.task.priority),
                ],
              ),
              const SizedBox(height: 5),

              // Smart Due Date
              Text(
                widget.task.dueDate != null
                    ? getFormattedDueDate(widget.task.dueDate!)
                    : "No due date",
                style: TextStyle(
                  color:
                      widget.task.isCompleted ? Colors.grey : Colors.deepPurple,
                  fontStyle: FontStyle.italic,
                ),
              ),

              // Animated subtask section
              AnimatedCrossFade(
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text("Category: ${widget.task.category}"),
                    const SizedBox(height: 5),
                    const Text(
                      "Subtasks:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    ...widget.task.subtasks.map(
                      (sub) => Row(
                        children: [
                          Checkbox(
                            value: sub.isCompleted,
                            onChanged: (_) => widget.onSubtaskToggle(sub),
                          ),
                          Expanded(
                            child: Text(
                              sub.title,
                              style: TextStyle(
                                decoration: sub.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: sub.isCompleted
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority) {
      case "High":
        color = Colors.red;
        break;
      case "Medium":
        color = Colors.orange;
        break;
      case "Low":
      default:
        color = Colors.green;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Text(
        priority,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }

  Widget _swipeActionLeft() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget _swipeActionRight() {
    return Container(
      color: Colors.blue,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.edit, color: Colors.white),
    );
  }
}
