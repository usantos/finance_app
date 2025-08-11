import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/models/account_response.dart';

abstract class AuthRemoteDataSource {
  Future<UserResponse?> login(String username, String password);
  Future<User?> register(String username, String email, String password);
  Future<bool> logout(String token);
  Future<User?> getCurrentUser();
}
