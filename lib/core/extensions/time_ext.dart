import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateExt on TimeOfDay {
  String formatHour() {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, minute);
    return DateFormat('HH:mm').format(dt);
  }
}
