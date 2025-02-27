import 'package:flutter/material.dart';
import 'submit_button_logic.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check_circle, color: Colors.green),
      onPressed: () {
        SubmitButtonLogic.handleSubmit(context);
      },
    );
  }
}
