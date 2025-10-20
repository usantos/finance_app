import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'extensions/brl_currency_input_formatter_ext.dart';

class Utils {
  Utils._();

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }
    return null;
  }

  static String? validateToAccount(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 6) {
      return "A conta deve ter 6 dígitos";
    }

    return null;
  }

  static String? validateToPixKeyValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Campo obrigatório";
    }

    value = value.trim();
    final type = value.detectPixKeyType();

    switch (type) {
      case 'CPF':
        final digits = value.replaceAll(RegExp(r'\D'), '');
        if (digits.length != 11) return 'CPF deve conter 11 dígitos';
        if (validateCpf(value) == null) return 'CPF inválido';
        break;

      case 'Telefone':
        final digits = value.replaceAll(RegExp(r'\D'), '');
        if (digits.length != 11) return 'Telefone deve conter 11 dígitos (DDD + número)';
        break;

      case 'Email':
        final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$');
        if (!emailRegex.hasMatch(value)) return 'E-mail inválido';
        break;

      case 'Aleatoria':
        final uuidRegex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');
        if (!uuidRegex.hasMatch(value)) return 'Chave aleatória inválida';
        break;

      default:
        return 'Tipo de chave não reconhecido';
    }

    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }

    final double parsed = BRLCurrencyInputFormatterExt.parse(value);
    if (parsed <= 0) {
      return "O valor deve ser maior que R\$ 0,00";
    }

    return null;
  }

  static String? validateCpf(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }
    final cpf = value.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11) return "CPF deve conter 11 dígitos";
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return "CPF inválido";
    final digits = cpf.split('').map(int.parse).toList();
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += digits[i] * (10 - i);
    }
    int remainder = sum % 11;
    int firstVerifier = (remainder < 2) ? 0 : 11 - remainder;
    if (digits[9] != firstVerifier) return "CPF inválido";
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += digits[i] * (11 - i);
    }
    remainder = sum % 11;
    int secondVerifier = (remainder < 2) ? 0 : 11 - remainder;
    if (digits[10] != secondVerifier) return "CPF inválido";

    return null;
  }

  static String? validatePhone(String? value, {bool strictMobileRule = true}) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }

    final phone = value.replaceAll(RegExp(r'\D'), '');

    if (phone.length != 10 && phone.length != 11) return "Telefone inválido";

    if (RegExp(r'^(\d)\1+$').hasMatch(phone)) return "Telefone inválido";

    final ddd = phone.substring(0, 2);
    if (ddd.startsWith('0')) return "DDD inválido";

    if (strictMobileRule && phone.length == 11) {
      if (phone[2] != '9') return "Número de celular inválido";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }

    if (value.length < 4) {
      return "A senha deve ter pelo menos 4 caracteres";
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return "E-mail inválido";
    }

    return null;
  }

  static void copiarTexto(BuildContext context, String text, String snackbarText) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(snackbarText), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating),
    );
  }
}
