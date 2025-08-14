import 'package:financial_app/data/datasources/user_local_data_source.dart';
import 'package:financial_app/data/models/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _userKey = 'user_data';

  UserLocalDataSourceImpl();

  @override
  Future<void> saveUser(UserResponse? user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userKey, jsonEncode(user?.toJson()));
  }

  @override
  Future<UserResponse?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserResponse.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_userKey);
  }
}
