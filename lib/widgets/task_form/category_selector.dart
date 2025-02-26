import 'package:flutter/material.dart';
import 'category_manager.dart';

Future<Map<String, dynamic>?> showCategorySelector(BuildContext context) async {
  return await showModalBottomSheet(
    context: context,
    builder: (context) => const CategorySelector(),
  );
}

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  CategorySelectorState createState() => CategorySelectorState();
}

class CategorySelectorState extends State<CategorySelector> {
  List<Map<String, dynamic>> categories = [
    {"name": "Work"},
    {"name": "Personal"},
    {"name": "Shopping"},
    {"name": "Fitness"}
  ];

  void _showCategoryManager(int index) {
    showDialog(
      context: context,
      builder: (context) => CategoryManager(
        category: categories[index],
        onSave: (newCategory) {
          setState(() => categories[index] = newCategory);
        },
        onDelete: () {
          setState(() => categories.removeAt(index));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 350,
      child: Column(
        children: [
          const Text("Select Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index]["name"]),
                  onTap: () => Navigator.pop(context, categories[index]),
                  onLongPress: () => _showCategoryManager(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
