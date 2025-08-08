import 'package:financial_app/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String username, String password);
  Future<User?> register(String username, String email, String password);
  Future<bool> logout();
  Future<User?> getCurrentUser();
}
