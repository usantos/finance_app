import "package:financial_app/domain/repositories/account_repository.dart";

class UpdateAccountBalance {
  final AccountRepository repository;

  UpdateAccountBalance(this.repository);

  Future<void> call(String accountId, double newBalance) {
    return repository.updateAccountBalance(accountId, newBalance);
  }
}
