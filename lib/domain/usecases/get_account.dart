import "package:financial_app/data/datasources/account_local_data_source.dart";
import "package:financial_app/data/datasources/user_local_data_source.dart";
import "package:financial_app/domain/entities/account.dart";
import "package:financial_app/domain/repositories/account_repository.dart";

class GetAccount {
  final AccountRepository repository;
  final UserLocalDataSource userLocalDataSource;
  final AccountLocalDataSource accountLocalDataSource;

  GetAccount(this.repository, this.userLocalDataSource, this.accountLocalDataSource);

  Future<Account?> call(String userId) async{
    final user = await userLocalDataSource.getUser();
    final token = user?.token;
    final account = await repository.getAccount(userId, token ?? "");
    accountLocalDataSource.saveAccount(account);
    return account;
  }
}
