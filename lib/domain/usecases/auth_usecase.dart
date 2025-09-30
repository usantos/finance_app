import 'package:financial_app/data/datasources/account_local_data_source.dart';
import 'package:financial_app/data/datasources/user_local_data_source.dart';
import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository authRepository;
  final UserLocalDataSource userLocalDataSource;
  final AccountLocalDataSource accountLocalDataSource;

  AuthUseCase(this.authRepository, this.userLocalDataSource, this.accountLocalDataSource);

  Future<UserResponse?> call(String username, String password) async {
    final userResponse = await authRepository.login(username, password);

    if (userResponse != null) {
      await userLocalDataSource.saveUser(userResponse);
      return userResponse;
    }

    return null;
  }

  Future<bool?> logout() async {
    final user = await userLocalDataSource.getUser();
    if (user != null) {
      final token = user.token;
      final logoutResponse = await authRepository.logout(token);
      if (logoutResponse?.status == true) {
        //TODO Deixar a limpeza em um local generico
        await userLocalDataSource.clearUser();
        await accountLocalDataSource.clearAccount();
      }
      return logoutResponse?.status;
    }
    return false;
  }

  Future<UserResponse?> register(String username, String email, String password) async {
    final userResponse = await authRepository.register(username, email, password);
    if (userResponse != null) {
      await userLocalDataSource.saveUser(userResponse);
      return userResponse;
    }
    return null;
  }

  Future<UserResponse?> getCurrentUser() async {
    final user = await userLocalDataSource.getUser();
    final token = user?.token;
    final currentUser = await authRepository.getCurrentUser(token ?? "");
    return currentUser;
  }
}
