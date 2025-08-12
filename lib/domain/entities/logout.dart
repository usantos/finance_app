class Logout {
  final bool status;
  final String message;

  Logout({required this.status, required this.message});

  factory Logout.fromJson(Map<String, dynamic> json) {
    return Logout(status: json['status'] ?? false, message: json['message'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message};
  }
}
