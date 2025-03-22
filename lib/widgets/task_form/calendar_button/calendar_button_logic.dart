import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarButtonLogic {
  static Future<Map<String, String>> selectDueDateTime(BuildContext context) async {
    // Select Date
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!context.mounted || selectedDate == null) return {}; // Check if widget is still in the tree

    // Select Time
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (!context.mounted || selectedTime == null) return {};

    // Format Date & Time
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String formattedTime = selectedTime.format(context);

    return {"date": formattedDate, "time": formattedTime};
  }
}
