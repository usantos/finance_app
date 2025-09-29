import 'package:financial_app/data/datasources/account_remote_datasource.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/services/real_api.dart';

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final RealApi realApi;

  AccountRemoteDataSourceImpl(this.realApi);

  @override
  Future<Account?> getAccount(String userId) async {
    final accountJson = await realApi.getAccount(userId);
    if (accountJson != null) {
      return Account.fromJson(accountJson);
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> getBalance(String accountId) async {
    return await realApi.getBalance(accountId);
  }

  @override
  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String password,
  ) async {
    return await realApi.transferBetweenAccounts(fromAccountNumber, toAccountNumber, amount, password);
  }

  @override
  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber) async {
    return await realApi.verifyTransferPassword(accountNumber);
  }

  @override
  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword) async {
    return await realApi.setTransferPassword(accountNumber, transferPassword);
  }

  @override
  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldTransferPassword,
    String newTransferPassword,
  ) async {
    return await realApi.changeTransferPassword(accountNumber, oldTransferPassword, newTransferPassword);
  }
}
