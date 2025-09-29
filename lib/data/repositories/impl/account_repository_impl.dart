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
  Future<Map<String, dynamic>?> getBalance(String accountId) {
    return remoteDataSource.getBalance(accountId);
  }

  @override
  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String password,
  ) {
    return remoteDataSource.transferBetweenAccounts(fromAccountNumber, toAccountNumber, amount, password);
  }

  @override
  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber) {
    return remoteDataSource.verifyTransferPassword(accountNumber);
  }

  @override
  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword) {
    return remoteDataSource.setTransferPassword(accountNumber, transferPassword);
  }

  @override
  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldtransferPassword,
    newTransferPassword,
  ) {
    return remoteDataSource.changeTransferPassword(accountNumber, oldtransferPassword, newTransferPassword);
  }
}
