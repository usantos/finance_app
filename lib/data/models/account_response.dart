import 'package:financial_app/domain/entities/user.dart';

class UserResponse {
  final String message;
  final String token;
  late final User user;

  UserResponse({required this.message, required this.token, required this.user});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'token': token, 'user': user.toJson()};
  }
}
