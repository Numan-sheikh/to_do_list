import 'package:flutter/material.dart';

class TaskButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCategorySelect;
  final VoidCallback onToggleSubTask;

  const TaskButtons({super.key, required this.onSave, required this.onCategorySelect, required this.onToggleSubTask});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FloatingActionButton(onPressed: onSave, backgroundColor: Colors.green, child: const Icon(Icons.check)),
        IconButton(icon: const Icon(Icons.category), onPressed: onCategorySelect),
        IconButton(icon: const Icon(Icons.subdirectory_arrow_right), onPressed: onToggleSubTask),
      ],
    );
  }
}
