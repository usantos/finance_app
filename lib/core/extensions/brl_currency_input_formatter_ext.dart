import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BRLCurrencyInputFormatterExt extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$ ', decimalDigits: 2);

  static const double maxValue = 1000000000000000.00;
  bool _firstEdit = true;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String oldDigits = oldValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String newDigits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    bool isDeleting = newDigits.length < oldDigits.length;

    if (isDeleting && oldDigits.length > 1) {
      newDigits = oldDigits.substring(0, oldDigits.length - 1);
    }

    if (newDigits.length < 3) {
      newDigits = newDigits.padLeft(3, '0');
    }

    double value = double.parse(newDigits) / 100;

    if (value > maxValue) return oldValue;

    String formatted = _formatter.format(value);

    if (newDigits == '000') {
      _firstEdit = true;
    }

    int newCursorPos = formatted.length;
    if (!_firstEdit) {
      int digitsBeforeCursor = 0;
      int cursorPosition = newValue.selection.end;
      for (int i = 0; i < cursorPosition && i < newValue.text.length; i++) {
        if (RegExp(r'\d').hasMatch(newValue.text[i])) digitsBeforeCursor++;
      }

      int countedDigits = 0;
      newCursorPos = 0;
      while (newCursorPos < formatted.length && countedDigits < digitsBeforeCursor) {
        if (RegExp(r'\d').hasMatch(formatted[newCursorPos])) countedDigits++;
        newCursorPos++;
      }

      if (newCursorPos < 3) newCursorPos = 3;
    }

    if (_firstEdit) {
      newCursorPos = formatted.length;
      _firstEdit = false;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }

  static double parse(String formatted) {
    final cleaned = formatted.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return 0.0;
    return double.parse(cleaned) / 100;
  }
}
