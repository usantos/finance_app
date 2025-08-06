import 'package:financial_app/core/extensions/money_ext.dart';
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

  bool _isHidden = true;
  bool get isHidden => _isHidden;

  @visibleForTesting
  void setAccount(Account? account) {
    _account = account;
  }

  AccountViewModel({required GetAccount getAccount, required UpdateAccountBalance updateAccountBalance})
    : _getAccount = getAccount,
      _updateAccountBalance = updateAccountBalance;

  Account? get account => _account;

  String get _balance => '${_account?.balance.toReal()}';

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

  List<String> get nomes => [
    'Área Pix e \nTransferir',
    'Pagar',
    'Pegar \nemprestado',
    'Caixinha \nTurbo',
    'Recarga de \ncelular',
    'Caixinhas e \nInvestir',
  ];

  List<String> get iconAssets => [
    'assets/icons/pix.svg',
    'assets/icons/barcode.svg',
    'assets/icons/pay_money.svg',
    'assets/icons/wallet.svg',
    'assets/icons/cellphone.svg',
    'assets/icons/wallet.svg',
  ];

  void toggleVisibility() {
    _isHidden = !_isHidden;
    notifyListeners();
  }

  String get displayBalance {
    if (_isHidden) return '••••••';
    return _balance;
  }
}
