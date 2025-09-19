import "package:financial_app/data/datasources/account_local_data_source.dart";
import "package:financial_app/data/datasources/user_local_data_source.dart";
import "package:financial_app/domain/entities/transaction.dart";
import "package:financial_app/domain/repositories/account_repository.dart";
import "package:financial_app/domain/repositories/transaction_repository.dart";

class TransferUseCase {
  final AccountRepository accountRepository;
  final AccountLocalDataSource accountLocalDataSource;
  final UserLocalDataSource userLocalDataSource;
  final TransactionRepository transactionRepository;

  TransferUseCase(
    this.accountRepository,
    this.accountLocalDataSource,
    this.userLocalDataSource,
    this.transactionRepository,
  );

  Future<Map<String, dynamic>> call(String toAccountNumber, double amount, String password) async {
    final fromAccount = await accountLocalDataSource.getAccount();
    final user = await userLocalDataSource.getUser();
    final token = user!.token;
    return accountRepository.transferBetweenAccounts(
      fromAccount!.accountNumber,
      toAccountNumber,
      amount,
      password,
      token,
    );
  }

  Future<Map<String, dynamic>> verifyTransferPassword() async {
    final fromAccount = await accountLocalDataSource.getAccount();
    final user = await userLocalDataSource.getUser();
    final token = user!.token;
    return accountRepository.verifyTransferPassword(fromAccount!.accountNumber, token);
  }

  Future<Map<String, dynamic>> setTransferPassword(String transferPassword) async {
    final fromAccount = await accountLocalDataSource.getAccount();
    final user = await userLocalDataSource.getUser();
    final token = user!.token;
    return accountRepository.setTransferPassword(fromAccount!.accountNumber, transferPassword, token);
  }

  Future<Map<String, dynamic>> changeTransferPassword(String oldTransferPassword, String newTransferPassword) async {
    final fromAccount = await accountLocalDataSource.getAccount();
    final user = await userLocalDataSource.getUser();
    final token = user!.token;
    return accountRepository.changeTransferPassword(
      fromAccount!.accountNumber,
      oldTransferPassword,
      newTransferPassword,
      token,
    );
  }

  Future<void> addTransaction(Transaction transaction) {
    return transactionRepository.addTransaction(transaction);
  }

  Future<List<Transaction>> getTransactions(String accountId) {
    return transactionRepository.getTransactions(accountId);
  }
}
