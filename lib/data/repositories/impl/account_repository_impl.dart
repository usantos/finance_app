import "package:financial_app/data/datasources/account_remote_datasource.dart";
import "package:financial_app/domain/entities/account.dart";
import "package:financial_app/domain/repositories/account_repository.dart";

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Account?> getAccount(String userId) {
    return remoteDataSource.getAccount(userId);
  }

  @override
  Future<void> updateAccountBalance(String accountId, double newBalance) {
    return remoteDataSource.updateAccountBalance(accountId, newBalance);
  }
}
