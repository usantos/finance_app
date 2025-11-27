import 'package:financial_app/data/models/user_request.dart';
import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/data/models/logout_response.dart';

abstract class AuthRepository {
  Future<UserResponse?> login(String username, String password);
  Future<UserResponse?> register(UserRequest userRequest);
  Future<LogoutResponse?> logout(String token);
  Future<UserResponse?> getCurrentUser(String token);
  Future<Map<String, dynamic>> setNewPhoneNumber(String newPhone, String userId, String oldPhone);
}
