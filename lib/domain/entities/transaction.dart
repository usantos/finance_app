import 'package:intl/intl.dart';

class Transaction {
  final String id;
  final String accountId;
  final String type;
  final double amount;
  final DateTime date;
  final String description;
  final String? fromAccount;
  final String? toAccount;

  Transaction({
    required this.id,
    required this.accountId,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    this.fromAccount,
    this.toAccount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["id"],
      accountId: json["accountId"],
      type: json["type"],
      amount: json["amount"].toDouble(),
      date: DateTime.parse(json["date"]),
      description: json["description"],
      fromAccount: json["fromAccount"],
      toAccount: json["toAccount"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "accountId": accountId,
      "type": type,
      "amount": amount,
      "date": date.toIso8601String(),
      "description": description,
      "fromAccount": fromAccount,
      "toAccount": toAccount,
    };
  }

  String get formattedDate => DateFormat('dd/MM/yyyy').format(date);

  String get typeLabel {
    switch (type) {
      case 'deposit':
        return 'Depósito';
      case 'withdrawal':
        return 'Compra';
      case 'transfer':
        return 'Transferência';
      default:
        return 'Desconhecido';
    }
  }
}
