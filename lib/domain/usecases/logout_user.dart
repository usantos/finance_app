import "package:financial_app/data/datasources/user_local_data_source.dart";
import "package:financial_app/domain/repositories/auth_repository.dart";

class LogoutUser {
  final AuthRepository repository;
  final UserLocalDataSource userLocalDataSource;

  LogoutUser(this.repository, this.userLocalDataSource);

  Future<bool> call() async {
    final user = await userLocalDataSource.getUser();
    if (user != null) {
      final token = user.token;
      return repository.logout(token);
    }
    return false;
  }
}
