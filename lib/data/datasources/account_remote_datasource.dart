import 'package:financial_app/domain/entities/account.dart';

abstract class AccountRemoteDataSource {
  Future<Account?> getAccount(String userId);
  Future<void> updateAccountBalance(String accountId, double newBalance);
}
