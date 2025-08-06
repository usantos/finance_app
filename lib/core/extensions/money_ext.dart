import 'package:intl/intl.dart';

extension MoneyExtension on double? {
  String toReal({String defaultValue = 'R\$ 0,00'}) {
    if (this == null) return defaultValue;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(this);
  }
}
