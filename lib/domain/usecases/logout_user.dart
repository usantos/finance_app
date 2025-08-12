import "package:financial_app/data/datasources/user_local_data_source.dart";
import "package:financial_app/domain/repositories/auth_repository.dart";

class LogoutUser {
  final AuthRepository repository;
  final UserLocalDataSource userLocalDataSource;

  LogoutUser(this.repository, this.userLocalDataSource);

  Future<bool?> call() async {
    final user = await userLocalDataSource.getUser();
    if (user != null) {
      final token = user.token;
      final logoutResponse = await repository.logout(token);
      return logoutResponse?.status;
    }
    return false;
  }
}
