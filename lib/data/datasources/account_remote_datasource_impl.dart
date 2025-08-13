import 'package:financial_app/data/datasources/account_remote_datasource.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/services/real_api.dart';

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final RealApi realApi;

  AccountRemoteDataSourceImpl(this.realApi);

  @override
  Future<Account?> getAccount(String userId, String token) async {
    final accountJson = await realApi.getAccount(userId, token);
    if (accountJson != null) {
      return Account.fromJson(accountJson);
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String token,
  ) async {
    return await realApi.transferBetweenAccounts(fromAccountNumber, toAccountNumber, amount, token);
  }
}
