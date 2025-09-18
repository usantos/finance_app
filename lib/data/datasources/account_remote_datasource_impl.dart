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
  Future<Map<String, dynamic>?> getBalance(String accountId, String token) async {
    return await realApi.getBalance(accountId, token);
  }

  @override
  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String password,
    String token,
  ) async {
    return await realApi.transferBetweenAccounts(fromAccountNumber, toAccountNumber, amount, password, token);
  }

  @override
  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber, String token) async {
    return await realApi.verifyTransferPassword(accountNumber, token);
  }

  @override
  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword, String token) async {
    return await realApi.setTransferPassword(accountNumber, transferPassword, token);
  }

  @override
  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldTransferPassword,
    String newTransferPassword,
    String token,
  ) async {
    return await realApi.changeTransferPassword(accountNumber, oldTransferPassword, newTransferPassword, token);
  }
}
