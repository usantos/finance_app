enum TransactionType { credit, debit }

class Transaction {
  final String? toAccountName;
  final DateTime date;
  final double amount;
  final String category;
  final TransactionType type;

  Transaction({
    required this.date,
    required this.amount,
    required this.category,
    required this.type,
    required this.toAccountName,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      toAccountName: map['toAccountName'],
      date: _parseDate(map['date']),
      amount: (map['amount'] is int) ? (map['amount'] as int).toDouble() : (map['amount'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      type: _parseType(map['type']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'toAccountName': toAccountName,
      'date': date.toIso8601String(),
      'amount': amount,
      'category': category,
      'type': type.name,
    };
  }

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  static TransactionType _parseType(dynamic value) {
    if (value is TransactionType) return value;
    if (value is String) {
      final normalized = value.toUpperCase();
      return normalized == 'CREDIT' ? TransactionType.credit : TransactionType.debit;
    }
    return TransactionType.debit;
  }
}
