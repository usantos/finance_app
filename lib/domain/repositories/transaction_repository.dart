import 'package:financial_app/domain/entities/transaction.dart';

abstract class TransactionRepository {
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

  Future<List<Map<String, dynamic>?>> getPixKeysByAccountId(String accountId);

  Future<Map<String, dynamic>> deletePixKey(String keyType);

  Future<Map<String, dynamic>> transferPix(
    String fromAccountId,
    String toPixKeyValue,
    double amount,
    String transferPassword,
    String userId,
  );
}
