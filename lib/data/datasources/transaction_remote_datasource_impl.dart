import "package:financial_app/data/datasources/transaction_remote_datasource.dart";
import "package:financial_app/domain/entities/transaction.dart";
import "package:financial_app/services/real_api.dart";

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final RealApi realApi;

  TransactionRemoteDataSourceImpl(this.realApi);

  @override
  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String password,
  ) async {
    return await realApi.transferBetweenAccounts(fromAccountNumber, toAccountNumber, amount, password);
  }

  @override
  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber) async {
    return await realApi.verifyTransferPassword(accountNumber);
  }

  @override
  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword) async {
    return await realApi.setTransferPassword(accountNumber, transferPassword);
  }

  @override
  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldTransferPassword,
    String newTransferPassword,
  ) async {
    return await realApi.changeTransferPassword(accountNumber, oldTransferPassword, newTransferPassword);
  }

  @override
  Future<Map<String, dynamic>> createPixKey(String accountId, String keyType, String keyValue) async {
    return await realApi.createPixKey(accountId, keyType, keyValue);
  }

  @override
  Future<List<Map<String, dynamic>>> getPixKeysByAccountId(String accountId) async {
    return await realApi.getPixKeysByAccountId(accountId);
  }

  @override
  Future<Map<String, dynamic>> deletePixKey(String keyType, String keyValue) async {
    return await realApi.deletePixKey(keyType, keyValue);
  }

  @override
  Future<Map<String, dynamic>> transferPix(
    String fromAccountId,
    String toPixKeyValue,
    double amount,
    String transferPassword,
    String userId,
  ) async {
    return await realApi.transferPix(fromAccountId, toPixKeyValue, amount, transferPassword, userId);
  }

  @override
  Future<Map<String, dynamic>> createQrCodePix(String accountId, double amount, String userId) async {
    return await realApi.createQrCodePix(accountId, amount, userId);
  }

  @override
  Future<Map<String, dynamic>> deleteQrCode(String txid) async {
    return await realApi.deleteQrCode(txid);
  }

  @override
  Future<List<Map<String, dynamic>>> getQrCode(String payload) async {
    return await realApi.getQrCode(payload);
  }

  @override
  Future<Map<String, dynamic>> transferQrCode(
    String fromAccountId,
    String toPayloadValue,
    double amount,
    String transferPassword,
    String userId,
  ) async {
    return await realApi.transferQrCode(fromAccountId, toPayloadValue, amount, transferPassword, userId);
  }

  @override
  Future<Map<String, dynamic>> createCreditCard(String accountId, String name, String password) async {
    return await realApi.createCreditCard(accountId, name, password);
  }

  @override
  Future<List<Map<String, dynamic>>> getCreditCardByAccountId(String accountId) async {
    return await realApi.getCreditCardByAccountId(accountId);
  }

  @override
  Future<Map<String, dynamic>> updateBlockType(String cardId, String blockType) async {
    return await realApi.updateBlockType(cardId, blockType);
  }

  @override
  Future<Transaction?> getTransactions(String accountId) async {
    final result = await realApi.getTransactions(accountId);
    final transactionJson = result?['transactions'];
    if (transactionJson != null) {
      return Transaction.fromJson(transactionJson);
    }
    return null;
  }

}
