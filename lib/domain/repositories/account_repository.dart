import 'package:financial_app/domain/entities/account.dart';

abstract class AccountRepository {
  Future<Account?> getAccount(String userId, String token);
  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String password,
    String token,
  );
}
