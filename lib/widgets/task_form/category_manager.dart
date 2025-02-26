import 'package:flutter/material.dart';

class CategoryManager extends StatefulWidget {
  final Map<String, dynamic> category;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onDelete;

  const CategoryManager({super.key, required this.category, required this.onSave, required this.onDelete});

  @override
  CategoryManagerState createState() => CategoryManagerState();
}

class CategoryManagerState extends State<CategoryManager> {
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.category["name"]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Category"),
      content: TextField(controller: _editController),
      actions: [
        TextButton(onPressed: widget.onDelete, child: const Text("Delete", style: TextStyle(color: Colors.red))),
        TextButton(
          onPressed: () {
            widget.onSave({"name": _editController.text});
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
