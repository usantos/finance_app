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
    return transactionRepository.transferBetweenAccounts(fromAccount!.accountNumber, toAccountNumber, amount, password);
  }

  Future<Map<String, dynamic>> verifyTransferPassword() async {
    final fromAccount = await accountLocalDataSource.getAccount();
    return transactionRepository.verifyTransferPassword(fromAccount!.accountNumber);
  }

  Future<Map<String, dynamic>> setTransferPassword(String transferPassword) async {
    final fromAccount = await accountLocalDataSource.getAccount();
    return transactionRepository.setTransferPassword(fromAccount!.accountNumber, transferPassword);
  }

  Future<Map<String, dynamic>> changeTransferPassword(String oldTransferPassword, String newTransferPassword) async {
    final fromAccount = await accountLocalDataSource.getAccount();
    return transactionRepository.changeTransferPassword(
      fromAccount!.accountNumber,
      oldTransferPassword,
      newTransferPassword,
    );
  }

  Future<Map<String, dynamic>> createPixKey(String keyType, String keyValue) async {
    final fromAccount = await accountLocalDataSource.getAccount();
    return transactionRepository.createPixKey(fromAccount!.id, keyType, keyValue);
  }

  Future<List<Map<String, dynamic>?>> getPixKeysByAccountId() async {
    final fromAccount = await accountLocalDataSource.getAccount();
    final response = await transactionRepository.getPixKeysByAccountId(fromAccount!.id);
    return response;
  }

  Future<void> addTransaction(Transaction transaction) {
    return transactionRepository.addTransaction(transaction);
  }

  Future<List<Transaction>> getTransactions(String accountId) {
    return transactionRepository.getTransactions(accountId);
  }

  Future<Map<String, dynamic>> deletePixKey(String keyType) async {
    return transactionRepository.deletePixKey(keyType);
  }
}
