import 'package:intl/intl.dart';

final _currency = NumberFormat('#,##0.00', 'pt_BR');

extension DoubleHelper on double? {
  String toMoneyFormatter({bool isAbs = true}) {
    if (this == null) {
      return r'R$ 0,00';
    }
    return 'R\$ ${_currency.format(isAbs ? (this!).abs() : this!)}';
  }

  String toMoneyFormatterNoSymbol({bool isAbs = true}) {
    if (this == null) return '0,00';
    return _currency.format(isAbs ? (this!).abs() : this!);
  }
}
