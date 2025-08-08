import "package:financial_app/domain/repositories/auth_repository.dart";

class LogoutUser {
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<bool> call() {
    return repository.logout();
  }
}
