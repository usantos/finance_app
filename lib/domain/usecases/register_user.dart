import "package:financial_app/domain/entities/user.dart";
import "package:financial_app/domain/repositories/auth_repository.dart";

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<User?> call(String username, String email, String password) {
    return repository.register(username, email, password);
  }
}
