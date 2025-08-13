import 'package:flutter/services.dart';

class AccountInputFormatterExt extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length > 6) {
      digitsOnly = digitsOnly.substring(0, 6);
    }

    String formatted = '';
    int cursorPosition = newValue.selection.end;

    if (digitsOnly.length <= 5) {
      formatted = digitsOnly;
    } else {
      formatted = '${digitsOnly.substring(0, 5)}-${digitsOnly.substring(5)}';
      if (cursorPosition > 5) cursorPosition++;
    }

    cursorPosition = cursorPosition > formatted.length ? formatted.length : cursorPosition;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
