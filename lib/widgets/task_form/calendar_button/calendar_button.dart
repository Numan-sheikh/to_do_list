import 'package:flutter/material.dart';

class CalendarButton extends StatefulWidget {
  final Function(String) onDateSelected;

  const CalendarButton({super.key, required this.onDateSelected});

  @override
  CalendarButtonState createState() => CalendarButtonState();
}

class CalendarButtonState extends State<CalendarButton> {
  Future<void> _pickDateTime() async {
    if (!mounted) return; // Ensure the widget is still in the tree

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (!mounted) return; // Check again before using context

      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        if (!mounted) return; // Final check before updating state

        // Format date and time
        String formattedDateTime =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.format(context)}";

        widget.onDateSelected(formattedDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _pickDateTime,
      icon: const Icon(Icons.calendar_today),
      label: const Text("Date"),
    );
  }
}
