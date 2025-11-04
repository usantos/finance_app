import "package:financial_app/data/datasources/transaction_remote_datasource.dart";
import "package:financial_app/domain/repositories/transaction_repository.dart";

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldtransferPassword,
    newTransferPassword,
  ) {
    return remoteDataSource.changeTransferPassword(accountNumber, oldtransferPassword, newTransferPassword);
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
  Future<Map<String, dynamic>> createPixKey(String accountId, String keyType, String keyValue) {
    return remoteDataSource.createPixKey(accountId, keyType, keyValue);
  }

  @override
  Future<List<Map<String, dynamic>?>> getPixKeysByAccountId(String accountId) {
    return remoteDataSource.getPixKeysByAccountId(accountId);
  }

  @override
  Future<Map<String, dynamic>> deletePixKey(String keyType, String keyValue) {
    return remoteDataSource.deletePixKey(keyType, keyValue);
  }

  @override
  Future<Map<String, dynamic>> transferPix(
    String fromAccountId,
    String toPixKeyValue,
    double amount,
    String transferPassword,
    String userId,
  ) {
    return remoteDataSource.transferPix(fromAccountId, toPixKeyValue, amount, transferPassword, userId);
  }

  @override
  Future<Map<String, dynamic>> createQrCodePix(String accountId, double amount, String userId) {
    return remoteDataSource.createQrCodePix(accountId, amount, userId);
  }

  @override
  Future<Map<String, dynamic>> deleteQrCode(String txid) {
    return remoteDataSource.deleteQrCode(txid);
  }

  @override
  Future<List<Map<String, dynamic>>> getQrCode(String payload) {
    return remoteDataSource.getQrCode(payload);
  }

  @override
  Future<Map<String, dynamic>> transferQrCode(
    String fromAccountId,
    String toPayloadValue,
    double amount,
    String transferPassword,
    String userId,
  ) {
    return remoteDataSource.transferQrCode(fromAccountId, toPayloadValue, amount, transferPassword, userId);
  }

  @override
  Future<Map<String, dynamic>> createCreditCard(String accountId, String name, String password) {
    return remoteDataSource.createCreditCard(accountId, name, password);
  }

  @override
  Future<List<Map<String, dynamic>>> getCreditCardByAccountId(String accountId) {
    return remoteDataSource.getCreditCardByAccountId(accountId);
  }

  @override
  Future<Map<String, dynamic>> updateBlockType(String cardId, String blockType) {
    return remoteDataSource.updateBlockType(cardId, blockType);
  }

  @override
  Future<List<Map<String, dynamic>>> getTransactions(String accountId) {
    return remoteDataSource.getTransactions(accountId);
  }
}
