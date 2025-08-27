import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/data/models/logout_response.dart';
import 'package:financial_app/domain/entities/user.dart';

abstract class AuthRepository {
  Future<UserResponse?> login(String username, String password);
  Future<User?> register(String username, String email, String password);
  Future<LogoutResponse?> logout(String token);
  Future<User?> getCurrentUser(String token);
}
