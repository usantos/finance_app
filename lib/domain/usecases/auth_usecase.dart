import 'package:financial_app/data/datasources/account_local_data_source.dart';
import 'package:financial_app/data/datasources/user_local_data_source.dart';
import 'package:financial_app/data/models/user_request.dart';
import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository authRepository;
  final UserLocalDataSource userLocalDataSource;
  final AccountLocalDataSource accountLocalDataSource;

  AuthUseCase(this.authRepository, this.userLocalDataSource, this.accountLocalDataSource);

  Future<UserResponse?> call(String cpf, String password) async {
    final userResponse = await authRepository.login(cpf, password);

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
        await userLocalDataSource.clearUser();
        await accountLocalDataSource.clearAccount();
      }
      return logoutResponse?.status;
    }
    return false;
  }

  Future<UserResponse?> register(UserRequest userRequest) async {
    final userResponse = await authRepository.register(userRequest);
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

  Future<Map<String, dynamic>> setNewPhoneNumber(String newPhone) async {
    final user = await userLocalDataSource.getUser();
    return await authRepository.setNewPhoneNumber(newPhone, user!.user.id, user.user.phone);
  }
}
