import "package:financial_app/domain/entities/account.dart";
import "package:financial_app/domain/repositories/account_repository.dart";

class GetAccount {
  final AccountRepository repository;

  GetAccount(this.repository);

  Future<Account?> call(String userId) {
    return repository.getAccount(userId);
  }
}
