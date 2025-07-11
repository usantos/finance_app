import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/usecases/get_account.dart';
import 'package:financial_app/domain/usecases/update_account_balance.dart';
import 'package:flutter/material.dart';

class AccountViewModel extends ChangeNotifier {
  final GetAccount _getAccount;
  final UpdateAccountBalance _updateAccountBalance;

  Account? _account;
  bool _isLoading = false;
  String? _errorMessage;

  AccountViewModel({required GetAccount getAccount, required UpdateAccountBalance updateAccountBalance})
    : _getAccount = getAccount,
      _updateAccountBalance = updateAccountBalance;

  Account? get account => _account;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAccount(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _account = await _getAccount(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBalance(String accountId, double newBalance) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _updateAccountBalance(accountId, newBalance);
      _account = _account?.copyWith(balance: newBalance);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
