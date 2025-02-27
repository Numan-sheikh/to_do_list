import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final Function(String) onCategorySelected; // Callback function

  const CategoryButton({super.key, required this.onCategorySelected});

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Category"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Work"),
                onTap: () {
                  onCategorySelected("Work");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Personal"),
                onTap: () {
                  onCategorySelected("Personal");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Shopping"),
                onTap: () {
                  onCategorySelected("Shopping");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showCategoryDialog(context),
      icon: const Icon(Icons.category),
      label: const Text("Category"),
    );
  }
}
