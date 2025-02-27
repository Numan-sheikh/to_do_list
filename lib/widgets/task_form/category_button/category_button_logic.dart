import 'package:flutter/material.dart';

class CategoryButtonLogic {
  static void showCategoryDialog(BuildContext context) {
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
                  Navigator.pop(context, "Work");
                },
              ),
              ListTile(
                title: const Text("Personal"),
                onTap: () {
                  Navigator.pop(context, "Personal");
                },
              ),
              ListTile(
                title: const Text("Shopping"),
                onTap: () {
                  Navigator.pop(context, "Shopping");
                },
              ),
            ],
          ),
        );
      },
    ).then((selectedCategory) {
      if (selectedCategory != null && context.mounted) { // ✅ Check if context is valid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected Category: $selectedCategory")),
        );
      }
    });
  }
}
