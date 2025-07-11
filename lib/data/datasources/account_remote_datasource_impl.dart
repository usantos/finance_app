import 'package:financial_app/data/datasources/account_remote_datasource.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/services/mock_api.dart';

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final MockApi mockApi;

  AccountRemoteDataSourceImpl(this.mockApi);

  @override
  Future<Account?> getAccount(String userId) async {
    final accountJson = await mockApi.getAccount(userId);
    if (accountJson != null) {
      return Account.fromJson(accountJson);
    }
    return null;
  }

  @override
  Future<void> updateAccountBalance(String accountId, double newBalance) async {
    await mockApi.updateAccountBalance(accountId, newBalance);
  }
}
