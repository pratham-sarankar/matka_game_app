import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay fromString(String timeString) {
    // Split the time string into time and period (AM/PM)
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return TimeOfDay(hour: hour, minute: minute);
  }
}
