import 'package:flutter/material.dart';

class CalendarButtonLogic {
  static Future<void> pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null || !context.mounted) return; // ✅ Check if context is still valid

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null || !context.mounted) return; // ✅ Check again before using context

    DateTime finalDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Selected Date & Time: $finalDateTime")),
    );
  }
}
