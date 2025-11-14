import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String formatDateTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final date = DateTime(year, month, day);

    if (date == today) {
      return "Hoje às ${DateFormat('HH:mm').format(this)}";
    } else if (date == yesterday) {
      return "Ontem às ${DateFormat('HH:mm').format(this)}";
    } else {
      return "${DateFormat('dd/MM/yyyy').format(this)} às ${DateFormat('HH:mm').format(this)}";
    }
  }
}
