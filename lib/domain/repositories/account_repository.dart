import 'package:financial_app/domain/entities/account.dart';

abstract class AccountRepository {
  Future<Account?> getAccount(String userId);
  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String password,
  );

  Future<Map<String, dynamic>?> getBalance(String accountId);

  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber);

  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword);

  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldTransferPassword,
    String newTransferPassword,
  );
}
