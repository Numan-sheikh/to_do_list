import 'package:flutter/material.dart';

class CalendarButtonLogic {
  static Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    return pickedDate;
  }
}
