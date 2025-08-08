import 'package:financial_app/data/datasources/auth_remote_datasource.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User?> register(String username, String email, String password) {
    return remoteDataSource.register(username, email, password);
  }

  @override
  Future<bool> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<User?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<User?> login(String username, String password) {
    return remoteDataSource.login(username, password);
  }
}
