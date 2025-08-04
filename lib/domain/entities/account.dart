class Account {
  final String id;
  final String userId;
  final String accountNumber;
  final double balance;

  Account({required this.id, required this.userId, required this.accountNumber, required this.balance});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json["id"],
      userId: json["userId"],
      accountNumber: json["accountNumber"],
      balance: json["balance"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "userId": userId, "accountNumber": accountNumber, "balance": balance};
  }

  Account copyWith({String? id, String? userId, String? accountNumber, double? balance}) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
    );
  }
}
