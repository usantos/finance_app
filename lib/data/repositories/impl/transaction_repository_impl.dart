import "package:financial_app/data/datasources/transaction_remote_datasource.dart";
import "package:financial_app/domain/entities/transaction.dart";
import "package:financial_app/domain/repositories/transaction_repository.dart";

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Transaction>> getTransactions(String accountId) {
    return remoteDataSource.getTransactions(accountId);
  }

  @override
  Future<void> addTransaction(Transaction transaction) {
    return remoteDataSource.addTransaction(transaction);
  }

  @override
  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldtransferPassword,
    newTransferPassword,
  ) {
    return remoteDataSource.changeTransferPassword(accountNumber, oldtransferPassword, newTransferPassword);
  }

  @override
  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String password,
  ) {
    return remoteDataSource.transferBetweenAccounts(fromAccountNumber, toAccountNumber, amount, password);
  }

  @override
  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber) {
    return remoteDataSource.verifyTransferPassword(accountNumber);
  }

  @override
  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword) {
    return remoteDataSource.setTransferPassword(accountNumber, transferPassword);
  }

  @override
  Future<Map<String, dynamic>> createPixKey(String accountId, String keyType, String keyValue) {
    return remoteDataSource.createPixKey(accountId, keyType, keyValue);
  }

  @override
  Future<List<Map<String, dynamic>?>> getPixKeysByAccountId(String accountId) {
    return remoteDataSource.getPixKeysByAccountId(accountId);
  }

  @override
  Future<Map<String, dynamic>> deletePixKey(String keyType) {
    return remoteDataSource.deletePixKey(keyType);
  }
}
