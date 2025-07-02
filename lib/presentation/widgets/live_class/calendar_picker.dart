import 'package:flutter/material.dart';

class CalendarPicker extends StatelessWidget {
  final void Function(DateTime) onDateSelected;
  final void Function(TimeOfDay) onTimeSelected;

  const CalendarPicker({
    super.key,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text("Pick a date"),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) onDateSelected(date);
          },
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text("Pick a time"),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) onTimeSelected(time);
          },
        ),
      ],
    );
  }
}
