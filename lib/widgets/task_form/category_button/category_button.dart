import 'package:flutter/material.dart';
import 'category_button_logic.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.category, color: Colors.blue),
      onPressed: () {
        CategoryButtonLogic.showCategoryDialog(context);
      },
    );
  }
}
