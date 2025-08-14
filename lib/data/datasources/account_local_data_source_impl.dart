import 'package:financial_app/data/datasources/account_local_data_source.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  static const String _accountKey = 'account_data';

  AccountLocalDataSourceImpl();

  @override
  Future<void> saveAccount(Account? account) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_accountKey, jsonEncode(account?.toJson()));
  }

  @override
  Future<Account?> getAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final accountJson = prefs.getString(_accountKey);
    if (accountJson != null) {
      return Account.fromJson(jsonDecode(accountJson));
    }
    return null;
  }

  @override
  Future<void> clearAccount() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_accountKey);
  }
}
