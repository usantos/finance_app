import 'package:financial_app/data/datasources/auth_remote_datasource.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/services/mock_api.dart';
import 'package:financial_app/services/real_api.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final MockApi mockApi;
  final RealApi realApi;

  AuthRemoteDataSourceImpl(this.mockApi, this.realApi);

  @override
  Future<User?> login(String username, String password) async {
    final userJson = await realApi.login(username, password);
    if (userJson != null) {
      return User.fromJson(userJson);
    }
    return null;
  }

  @override
  Future<User?> register(String username, String email, String password) async {
    final userJson = await mockApi.register(username, email, password);
    if (userJson != null) {
      return User.fromJson(userJson);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await mockApi.logout();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userJson = await mockApi.getCurrentUser();
    if (userJson != null) {
      return User.fromJson(userJson);
    }
    return null;
  }

}
