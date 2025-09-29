import 'package:financial_app/data/datasources/auth_remote_datasource.dart';
import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/data/models/logout_response.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/services/real_api.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final RealApi realApi;

  AuthRemoteDataSourceImpl(this.realApi);

  @override
  Future<UserResponse?> login(String username, String password) async {
    final response = await realApi.login(username, password);
    if (response != null) {
      final user = UserResponse.fromJson(response);
      return user;
    }
    return null;
  }

  @override
  Future<User?> register(String username, String email, String password) async {
    final responseJson = await realApi.register(username, email, password);
    if (responseJson != null && responseJson['user'] != null) {
      return User.fromJson(responseJson['user']);
    }
    return null;
  }

  @override
  Future<LogoutResponse?> logout(String token) async {
    final response = await realApi.logout();
    if (response != null) {
      return LogoutResponse.fromJson(response);
    }
    return null;
  }

  @override
  Future<User?> getCurrentUser(String token) async {
    final userJson = await realApi.getCurrentUser();
    if (userJson != null && userJson['user'] != null) {
      return User.fromJson(userJson['user']);
    }
    return null;
  }
}
