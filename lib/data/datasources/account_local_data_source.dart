import 'package:financial_app/domain/entities/account.dart';

abstract class AccountLocalDataSource {
  Future<void> saveAccount(Account? account);
  Future<Account?> getAccount();
  Future<void> clearAccount();
}
