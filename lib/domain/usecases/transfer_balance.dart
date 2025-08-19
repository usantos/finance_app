import "package:financial_app/data/datasources/account_local_data_source.dart";
import "package:financial_app/data/datasources/user_local_data_source.dart";
import "package:financial_app/domain/repositories/account_repository.dart";

class TransferBalance {
  final AccountRepository repository;
  final AccountLocalDataSource accountLocalDataSource;
  final UserLocalDataSource userLocalDataSource;

  TransferBalance(this.repository, this.accountLocalDataSource, this.userLocalDataSource);

  Future<Map<String, dynamic>> call(String toAccountNumber, double amount, String password) async {
    final fromAccount = await accountLocalDataSource.getAccount();
    final user = await userLocalDataSource.getUser();
    final token = user!.token;
    return repository.transferBetweenAccounts(fromAccount!.accountNumber, toAccountNumber, amount, password, token);
  }

  Future<Map<String, dynamic>> verifyTransferPassword() async {
    final fromAccount = await accountLocalDataSource.getAccount();
    final user = await userLocalDataSource.getUser();
    final token = user!.token;
    return repository.verifyTransferPassword(fromAccount!.accountNumber, token);
  }
}
