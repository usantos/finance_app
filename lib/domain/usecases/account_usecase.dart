import "package:financial_app/data/datasources/account_local_data_source.dart";
import "package:financial_app/data/datasources/user_local_data_source.dart";
import "package:financial_app/domain/entities/account.dart";
import "package:financial_app/domain/repositories/account_repository.dart";

class AccountUseCase {
  final AccountRepository repository;
  final UserLocalDataSource userLocalDataSource;
  final AccountLocalDataSource accountLocalDataSource;

  AccountUseCase(this.repository, this.userLocalDataSource, this.accountLocalDataSource);

  Future<Account?> call() async {
    final user = await userLocalDataSource.getUser();
    final token = user?.token;
    final account = await repository.getAccount(user?.user.id ?? "", token ?? "");
    accountLocalDataSource.saveAccount(account);
    return account;
  }
}
