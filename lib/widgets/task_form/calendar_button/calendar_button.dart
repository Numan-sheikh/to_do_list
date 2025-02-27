import 'package:flutter/material.dart';
import 'calendar_button_logic.dart';

class CalendarButton extends StatelessWidget {
  const CalendarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calendar_today, color: Colors.green),
      onPressed: () {
        CalendarButtonLogic.pickDateTime(context);
      },
    );
  }
}
