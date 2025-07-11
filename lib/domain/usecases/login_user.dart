import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User?> call(String username, String password) {
    return repository.login(username, password);
  }
}
