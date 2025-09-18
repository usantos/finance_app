import 'package:financial_app/domain/entities/account.dart';

abstract class AccountRepository {
  Future<Account?> getAccount(String userId, String token);
  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String password,
    String token,
  );

  Future<Map<String, dynamic>?> getBalance(String accountId, String token);

  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber, String token);

  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword, String token);

  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldTransferPassword,
    String newTransferPassword,
    String token,
  );
}
