import 'package:financial_app/domain/entities/account.dart';

abstract class AccountRemoteDataSource {
  Future<Account?> getAccount(String userId);

  Future<Map<String, dynamic>?> getBalance(String accountId);
}
