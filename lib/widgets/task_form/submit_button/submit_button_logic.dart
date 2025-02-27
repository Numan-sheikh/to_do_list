import 'package:flutter/material.dart';

class SubmitButtonLogic {
  static void handleSubmit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task Submitted! ✅")),
    );
  }
}
