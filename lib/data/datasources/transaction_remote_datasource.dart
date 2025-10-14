import 'package:financial_app/domain/entities/transaction.dart';

abstract class TransactionRemoteDataSource {
  Future<List<Transaction>> getTransactions(String accountId);

  Future<void> addTransaction(Transaction transaction);

  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String password,
  );

  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber);

  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword);

  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldTransferPassword,
    String newTransferPassword,
  );

  Future<Map<String, dynamic>> createPixKey(String accountId, String keyType, String keyValue);

  Future<Map<String, dynamic>> getPixKey(String accountId);
}
