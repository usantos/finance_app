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
}
