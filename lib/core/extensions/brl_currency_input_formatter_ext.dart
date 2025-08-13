import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BRLCurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    }

    final valueInCents = int.parse(digitsOnly);
    final value = valueInCents / 100.0;

    final newText = _formatter.format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  static double parse(String formatted) {
    final cleaned = formatted.replaceAll(RegExp(r'[^0-9,]'), '').replaceAll('.', '').replaceFirst(',', '.');
    if (cleaned.isEmpty) return 0.0;
    return double.tryParse(cleaned) ?? 0.0;
  }
}
