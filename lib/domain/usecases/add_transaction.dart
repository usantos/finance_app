import "package:financial_app/domain/entities/transaction.dart";
import "package:financial_app/domain/repositories/transaction_repository.dart";

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<void> call(Transaction transaction) {
    return repository.addTransaction(transaction);
  }
}
