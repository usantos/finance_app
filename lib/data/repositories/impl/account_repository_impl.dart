import "package:financial_app/data/datasources/account_remote_datasource.dart";
import "package:financial_app/domain/entities/account.dart";
import "package:financial_app/domain/repositories/account_repository.dart";

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Account?> getAccount(String userId, String token) {
    return remoteDataSource.getAccount(userId, token);
  }

  @override
  Future<void> transferBetweenAccounts(String fromAccountId, String toAccountId, double amount, String token) {
    return remoteDataSource.transferBetweenAccounts(fromAccountId, toAccountId, amount, token);
  }
}
