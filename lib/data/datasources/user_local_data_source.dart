import 'package:financial_app/data/models/user_response.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(UserResponse? user);
  Future<UserResponse?> getUser();
  Future<void> clearUser();
}
