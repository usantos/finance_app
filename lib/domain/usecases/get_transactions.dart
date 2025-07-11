import "package:financial_app/domain/entities/transaction.dart";
import "package:financial_app/domain/repositories/transaction_repository.dart";

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call(String accountId) {
    return repository.getTransactions(accountId);
  }
}
