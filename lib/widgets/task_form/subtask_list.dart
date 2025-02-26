import 'package:flutter/material.dart';

class SubtaskList extends StatelessWidget {
  final List<String> subTasks;
  final Function(String) onRemove;

  const SubtaskList({super.key, required this.subTasks, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: subTasks.map((subtask) {
        return ListTile(
          title: Text(subtask),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onRemove(subtask),
          ),
        );
      }).toList(),
    );
  }
}
