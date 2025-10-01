import 'package:financial_app/data/datasources/auth_remote_datasource.dart';
import 'package:financial_app/data/models/user_request.dart';
import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/data/models/logout_response.dart';
import 'package:financial_app/services/real_api.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final RealApi realApi;

  AuthRemoteDataSourceImpl(this.realApi);

  @override
  Future<UserResponse?> login(String cpf, String password) async {
    final response = await realApi.login(cpf, password);
    if (response != null) {
      final user = UserResponse.fromJson(response);
      return user;
    }
    return null;
  }

  @override
  Future<UserResponse?> register(UserRequest userRequest) async {
    final responseJson = await realApi.register(userRequest);
    if (responseJson != null) {
      return UserResponse.fromJson(responseJson);
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
  Future<UserResponse?> getCurrentUser(String token) async {
    final userJson = await realApi.getCurrentUser();
    if (userJson != null) {
      return UserResponse.fromJson(userJson);
    }
    return null;
  }
}
