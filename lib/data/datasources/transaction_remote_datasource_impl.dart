import "package:financial_app/data/datasources/transaction_remote_datasource.dart";
import "package:financial_app/domain/entities/transaction.dart";
import "package:financial_app/services/mock_api.dart";

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final MockApi mockApi;

  TransactionRemoteDataSourceImpl(this.mockApi);

  @override
  Future<List<Transaction>> getTransactions(String accountId) async {
    final transactionsJson = await mockApi.getTransactions(accountId);
    return transactionsJson.map((json) => Transaction.fromJson(json)).toList();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await mockApi.addTransaction(transaction.toJson());
  }
}
