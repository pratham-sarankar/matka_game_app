import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay fromString(String timeString) {
    // Split into time and period (AM/PM)
    final parts = timeString.split(' ');
    final timePart = parts[0];
    final period = parts.length > 1 ? parts[1].toUpperCase() : null;

    // Split hours and minutes
    final timeComponents = timePart.split(':');
    var hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    // Convert to 24-hour format if needed
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String format24Hour() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
