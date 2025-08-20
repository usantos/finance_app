import 'package:financial_app/domain/entities/account.dart';

abstract class AccountRemoteDataSource {
  Future<Account?> getAccount(String userId, String token);
  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountId,
    String toAccountId,
    double amount,
    String password,
    String token,
  );

  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber, String token);

  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword, String token);
}
