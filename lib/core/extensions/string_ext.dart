import 'package:financial_app/core/utils.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String get firstLetter {
    String trimmed = trim();
    if (trimmed.isEmpty) return '';
    return trimmed[0].toUpperCase();
  }

  String toCPFProgressive() {
    final digits = replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';

    final d = digits.length > 11 ? digits.substring(0, 11) : digits;

    if (d.length <= 3) {
      return d;
    } else if (d.length <= 6) {
      return '${d.substring(0, 3)}.${d.substring(3)}';
    } else if (d.length <= 9) {
      return '${d.substring(0, 3)}.${d.substring(3, 6)}.${d.substring(6)}';
    } else {
      final part1 = d.substring(0, 3);
      final part2 = d.substring(3, 6);
      final part3 = d.substring(6, 9);
      final part4 = d.substring(9);
      return '$part1.$part2.$part3-$part4';
    }
  }

  String toShort() {
    if (isEmpty) return this;

    if (contains('@')) {
      final parts = split('@');
      final username = parts.first;
      final domain = parts.last;

      final shortUsername = username.length > 5 ? '${username.substring(0, 5)}...' : username;

      return '$shortUsername@$domain';
    }

    if (length == 36) {
      return '${substring(0, 16)}...';
    }
    return this;
  }

  String maskCPFMid() {
    final digits = replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    final d = digits.length > 11 ? digits.substring(0, 11) : digits;

    final chars = d.split('');
    for (int i = 3; i <= 8 && i < chars.length; i++) {
      chars[i] = '•';
    }

    final rebuilt = chars.join();

    if (rebuilt.length <= 3) {
      return rebuilt;
    } else if (rebuilt.length <= 6) {
      return '${rebuilt.substring(0, 3)}.${rebuilt.substring(3)}';
    } else if (rebuilt.length <= 9) {
      return '${rebuilt.substring(0, 3)}.${rebuilt.substring(3, 6)}.${rebuilt.substring(6)}';
    } else {
      final part1 = rebuilt.substring(0, 3);
      final part2 = rebuilt.substring(3, 6);
      final part3 = rebuilt.substring(6, 9);
      final part4 = rebuilt.substring(9);
      return '$part1.$part2.$part3-$part4';
    }
  }

  String toPhone() {
    final digits = replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';

    final d = digits.length > 11 ? digits.substring(0, 11) : digits;

    if (d.length <= 2) {
      return '($d';
    } else if (d.length <= 6) {
      final ddd = d.substring(0, 2);
      final number = d.substring(2);
      return '($ddd) $number';
    } else {
      final ddd = d.substring(0, 2);
      final number1 = d.substring(2, 7);
      final number2 = d.length > 7 ? d.substring(7) : '';
      return '($ddd) $number1${number2.isNotEmpty ? '-$number2' : ''}';
    }
  }

  String maskPhoneMid({String maskChar = '•'}) {
    final digits = replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';

    final d = digits.length > 11 ? digits.substring(0, 11) : digits;
    final chars = d.split('');

    for (int i = 2; i < chars.length - 4; i++) {
      chars[i] = maskChar;
    }

    final rebuilt = chars.join();

    if (rebuilt.length <= 2) {
      return '($rebuilt';
    } else if (rebuilt.length <= 6) {
      final ddd = rebuilt.substring(0, 2);
      final number = rebuilt.substring(2);
      return '($ddd) $number';
    } else {
      final ddd = rebuilt.substring(0, 2);
      final number1 = rebuilt.substring(2, 7);
      final number2 = rebuilt.length > 7 ? rebuilt.substring(7) : '';
      return '($ddd) $number1${number2.isNotEmpty ? '-$number2' : ''}';
    }
  }

  String detectPixKeyType() {
    final value = trim();
    if (value.contains('@')) {
      return 'E-mail';
    }
    if (RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$').hasMatch(value)) {
      return 'Chave Aleatória';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && Utils.validateCpf(value) != null) {
      return 'CPF';
    }
    if (digits.length == 10 || digits.length == 11) {
      return 'Telefone';
    }

    return 'Desconhecido';
  }

  String toRealString() {
    final value = replaceAll(RegExp(r'\D'), '');
    final doubleValue = double.tryParse(value) ?? 0;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(doubleValue / 100);
  }
}
