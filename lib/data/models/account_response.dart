class AccountResponse {
  final String message;
  final String fromAccount;
  final String toAccount;

  AccountResponse({required this.message, required this.fromAccount, required this.toAccount});

  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      message: json['message'] ?? '',
      fromAccount: json['fromAccount'] ?? '',
      toAccount: json['toAccount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'fromAccount': fromAccount, 'toAccount': toAccount};
  }
}
