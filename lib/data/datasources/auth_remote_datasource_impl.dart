import 'package:financial_app/data/datasources/auth_remote_datasource.dart';
import 'package:financial_app/domain/entities/logout.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/services/mock_api.dart';
import 'package:financial_app/services/real_api.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final MockApi mockApi;
  final RealApi realApi;

  AuthRemoteDataSourceImpl(this.mockApi, this.realApi);

  @override
  Future<User?> login(String username, String password) async {
    final response = await realApi.login(username, password);
    if (response != null) {
      final user = User.fromJson(response["user"]);
      return user;
    }
    return null;
  }

  @override
  Future<User?> register(String username, String email, String password) async {
    final userJson = await realApi.register(username, email, password);
    if (userJson != null) {
      return User.fromJson(userJson);
    }
    return null;
  }

  //TODO avaliar porque nao esta funcionando
  @override
  Future<bool> logout() async {
    final response = await realApi.logout("");
    if(response != null){
      return Logout.fromJson(response["status"]) as bool;
    }
    return false;
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
