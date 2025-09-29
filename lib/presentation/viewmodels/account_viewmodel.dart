import 'package:financial_app/core/extensions/money_ext.dart';
import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:flutter/material.dart';

class AccountViewModel extends ChangeNotifier {
  final AccountUseCase _accountUseCase;

  Account? _account;
  final bool _isLoading = false;
  String? _errorMessage;

  bool _isHidden = true;
  bool get isHidden => _isHidden;

  @visibleForTesting
  void setAccount(Account? account) {
    _account = account;
  }

  void updateAccount(Account account) {
    _account = account;
    notifyListeners();
  }

  AccountViewModel({required AccountUseCase accountUseCase}) : _accountUseCase = accountUseCase;

  Account? get account => _account;

  String get _balance => _account?.balance.toReal() ?? '';

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

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

  Future<UserResponse?> getUser() async {
    final user = await _accountUseCase.userLocalDataSource.getUser();
    return user;
  }
}
