import 'package:financial_app/domain/entities/transaction.dart';

abstract class TransactionRemoteDataSource {
  Future<List<Transaction>> getTransactions(String accountId);
  Future<void> addTransaction(Transaction transaction);
}
