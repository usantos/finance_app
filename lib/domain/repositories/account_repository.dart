import 'package:financial_app/domain/entities/account.dart';

abstract class AccountRepository {
  Future<Account?> getAccount(String userId, String token);
  Future<void> transferBetweenAccounts(String fromAccountId, String toAccountId, double amount, String token);
}
