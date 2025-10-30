class CreditCardModel {
  final String accountId;
  final String creditCardName;
  final String creditCardNumber;
  final String validate;
  final String creditCardPassword;
  final double creditCardLimit;
  final double creditCardAvailable;
  final double creditCardUsed;

  CreditCardModel({
    required this.accountId,
    required this.creditCardName,
    required this.creditCardNumber,
    required this.validate,
    required this.creditCardPassword,
    required this.creditCardLimit,
    required this.creditCardAvailable,
    required this.creditCardUsed,
  });

  factory CreditCardModel.fromMap(Map<String, dynamic> map) {
    return CreditCardModel(
      accountId: map['accountId'] ?? '',
      creditCardName: map['creditCardName'] ?? '',
      creditCardNumber: map['creditCardNumber'] ?? '',
      validate: map['validate'] ?? '',
      creditCardPassword: map['creditCardPassword'] ?? '',
      creditCardLimit: (map['creditCardLimit'] ?? 0).toDouble(),
      creditCardAvailable: (map['creditCardAvailable'] ?? 0).toDouble(),
      creditCardUsed: (map['creditCardUsed'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'creditCardName': creditCardName,
      'creditCardNumber': creditCardNumber,
      'validate': validate,
      'creditCardPassword': creditCardPassword,
      'creditCardLimit': creditCardLimit,
      'creditCardAvailable': creditCardAvailable,
      'creditCardUsed': creditCardUsed,
    };
  }
}
