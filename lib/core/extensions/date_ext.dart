import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String formatDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(year, month, day);

    if (date == today) {
      return 'Hoje';
    } else if (date == yesterday) {
      return 'Ontem';
    } else {
      return DateFormat('dd/MM/yyyy').format(this);
    }
  }
}
