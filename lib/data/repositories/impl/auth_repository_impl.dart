import 'package:financial_app/data/datasources/auth_remote_datasource.dart';
import 'package:financial_app/data/models/user_request.dart';
import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/data/models/logout_response.dart';
import 'package:financial_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserResponse?> register(UserRequest userRequest) {
    return remoteDataSource.register(userRequest);
  }

  @override
  Future<LogoutResponse?> logout(String token) {
    return remoteDataSource.logout(token);
  }

  @override
  Future<UserResponse?> getCurrentUser(String token) {
    return remoteDataSource.getCurrentUser(token);
  }

  @override
  Future<UserResponse?> login(String cpf, String password) {
    return remoteDataSource.login(cpf, password);
  }
}
