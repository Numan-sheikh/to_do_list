import 'package:flutter/material.dart';

class CategoryButtonLogic {
  static Future<String?> selectCategory(BuildContext context) async {
    TextEditingController newCategoryController = TextEditingController();

    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, // Allows better keyboard handling
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<String> categories = [
              "Work",
              "Personal",
              "Shopping",
              "Health",
              "Others"
            ];

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    16, // Adjust for keyboard
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Display categories as selectable buttons
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      return ElevatedButton(
                        onPressed: () => Navigator.pop(context, category),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(category),
                      );
                    }).toList(),
                  ),

                  const Divider(),

                  // TextField for adding a new category
                  TextField(
                    controller: newCategoryController,
                    decoration: InputDecoration(
                      labelText: "New Category",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => newCategoryController.clear(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Add Category Button
                  ElevatedButton(
                    onPressed: () {
                      String newCategory = newCategoryController.text.trim();

                      if (newCategory.isNotEmpty &&
                          !categories.contains(newCategory)) {
                        setState(() {
                          categories.add(newCategory);
                        });

                        FocusScope.of(context).unfocus(); // Close keyboard
                        Navigator.pop(context, newCategory);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                    ),
                    child: const Text("Add Category",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
