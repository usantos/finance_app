class Transaction {
  final String id;
  final String type;
  final double amount;
  final DateTime date;
  final String? description;
  final String? fromAccount;
  final String? toAccountName;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
    this.fromAccount,
    this.toAccountName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["id"],
      type: json["type"],
      amount: json["amount"].toDouble(),
      date: DateTime.parse(json["date"]),
      description: json["description"],
      fromAccount: json["fromAccount"],
      toAccountName: json["toAccountName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "amount": amount,
      "date": date.toIso8601String(),
      "description": description,
      "fromAccount": fromAccount,
      "toAccountName": toAccountName,
    };
  }
}
