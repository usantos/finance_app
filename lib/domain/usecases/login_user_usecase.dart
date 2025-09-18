import 'package:financial_app/data/datasources/user_local_data_source.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/repositories/auth_repository.dart';

class LoginUserUseCase {
  final AuthRepository repository;
  final UserLocalDataSource localDataSource;

  LoginUserUseCase(this.repository, this.localDataSource);

  Future<User?> call(String username, String password) async {
    final userResponse = await repository.login(username, password);

    if (userResponse != null) {
      await localDataSource.saveUser(userResponse);
      return userResponse.user;
    }

    return null;
  }
}
