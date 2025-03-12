import 'package:flutter/material.dart';

class CategoryButtonLogic {
  static Future<String?> selectCategory(BuildContext context) async {
    List<String> categories = ["Work", "Personal", "Shopping", "Health"];

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Category"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: categories.map((category) {
              return ListTile(
                title: Text(category),
                onTap: () {
                  Navigator.pop(context, category); // Return selected category
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
