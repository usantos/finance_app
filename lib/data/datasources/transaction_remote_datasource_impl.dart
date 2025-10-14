import "package:financial_app/data/datasources/transaction_remote_datasource.dart";
import "package:financial_app/domain/entities/transaction.dart";
import "package:financial_app/services/mock_api.dart";
import "package:financial_app/services/real_api.dart";

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final MockApi mockApi;
  final RealApi realApi;

  TransactionRemoteDataSourceImpl(this.mockApi, this.realApi);

  @override
  Future<List<Transaction>> getTransactions(String accountId) async {
    final transactionsJson = await mockApi.getTransactions(accountId);
    return transactionsJson.map((json) => Transaction.fromJson(json)).toList();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await mockApi.addTransaction(transaction.toJson());
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

  @override
  Future<Map<String, dynamic>> createPixKey(String accountId, String keyType, String keyValue) async {
    return await realApi.createPixKey(accountId, keyType, keyValue);
  }

  @override
  Future<Map<String, dynamic>> getPixKey(String accountId) async {
    return await realApi.getPixKey(accountId);
  }
}
