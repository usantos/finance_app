import 'package:financial_app/domain/entities/account.dart';

abstract class AccountRepository {
  Future<Account?> getAccount(String userId);
  Future<Map<String, dynamic>?> getBalance(String accountId);
}
