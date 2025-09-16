import "package:financial_app/data/datasources/user_local_data_source.dart";
import "package:financial_app/domain/entities/user.dart";
import "package:financial_app/domain/repositories/auth_repository.dart";

class GetCurrentUser {
  final AuthRepository repository;

  final UserLocalDataSource userLocalDataSource;

  GetCurrentUser(this.repository, this.userLocalDataSource);

  Future<User?> call() async {
    final user = await userLocalDataSource.getUser();
    final token = user?.token;
    return await repository.getCurrentUser(token ?? "");
  }
}
