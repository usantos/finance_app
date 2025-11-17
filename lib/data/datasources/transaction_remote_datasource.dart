abstract class TransactionRemoteDataSource {
  Future<Map<String, dynamic>> transferBetweenAccounts(String fromAccountNumber, String toAccountNumber, double amount);

  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber);

  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword);

  Future<Map<String, dynamic>> validateTransferPassword(String accountId, String transferPassword);

  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldTransferPassword,
    String newTransferPassword,
  );

  Future<Map<String, dynamic>> createPixKey(String accountId, String keyType, String keyValue);

  Future<List<Map<String, dynamic>?>> getPixKeysByAccountId(String accountId);

  Future<Map<String, dynamic>> deletePixKey(String keyType, String keyValue);

  Future<Map<String, dynamic>> transferPix(String fromAccountId, String toPixKeyValue, double amount, String userId);

  Future<Map<String, dynamic>> createQrCodePix(String accountId, double amount, String userId);

  Future<Map<String, dynamic>> deleteQrCode(String txid);

  Future<List<Map<String, dynamic>>> getQrCode(String payload);
  Future<Map<String, dynamic>> transferQrCode(
    String fromAccountId,
    String toPayloadValue,
    double amount,
    String userId,
  );

  Future<Map<String, dynamic>> createCreditCard(String accountId, String name, String password);

  Future<List<Map<String, dynamic>>> getCreditCardByAccountId(String accountId);

  Future<Map<String, dynamic>> updateBlockType(String cardId, String blockType);

  Future<List<Map<String, dynamic>>> getTransactions(String accountId);

  Future<Map<String, dynamic>> deleteCreditCard(String cardId);

  Future<Map<String, dynamic>> rechargePhone(String fromAccountNumber, double value);

  Future<Map<String, dynamic>> adjustLimit(String cardId, String accountId, double newLimitAvailable);
}
