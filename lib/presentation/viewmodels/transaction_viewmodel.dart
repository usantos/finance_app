import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:financial_app/core/extensions/brl_currency_input_formatter_ext.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/entities/transaction.dart';
import 'package:financial_app/domain/usecases/add_transaction.dart';
import 'package:financial_app/domain/usecases/get_transactions.dart';
import 'package:financial_app/domain/usecases/transfer_balance.dart';

class TransactionViewModel extends ChangeNotifier {
  final GetTransactions _getTransactions;
  final AddTransaction _addTransaction;
  final TransferBalance _transferBalance;

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _errorCode;
  bool _hasPassword = false;
  Account? _account;
  bool showErrors = false;

  TransactionViewModel({
    required GetTransactions getTransactions,
    required AddTransaction addTransaction,
    required TransferBalance updateAccountBalance,
  }) : _getTransactions = getTransactions,
       _addTransaction = addTransaction,
       _transferBalance = updateAccountBalance;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get errorCode => _errorCode;
  bool get hasPassword => _hasPassword;
  Account? get account => _account;

  @visibleForTesting
  void setAccount(Account account) {
    _account = account;
  }

  String? validateToAccount(String? value) {
    if (!showErrors) return null;

    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 6) {
      return "A conta deve ter 6 dígitos";
    }

    return null;
  }

  String? validateAmount(String? value) {
    if (!showErrors) return null;

    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }

    final double parsed = BRLCurrencyInputFormatterExt.parse(value);
    if (parsed <= 0) {
      return "O valor deve ser maior que R\$ 0,00";
    }

    return null;
  }

  Future<void> fetchTransactions(String accountId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _transactions = await _getTransactions(accountId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTransaction(Transaction transaction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _addTransaction(transaction);
      _transactions.add(transaction);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> transferBetweenAccounts(String accountId, double amount, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferBalance(accountId, amount, password);

      _isLoading = false;

      if (!result['success']) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        notifyListeners();
        return false;
      }

      _account = _account?.copyWith(balance: amount);
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyTransferPassword() async {
    _errorCode = null;
    _hasPassword = false;
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _transferBalance.verifyTransferPassword();
      _isLoading = false;

      if (result['success'] == true) {
        _hasPassword = true;
        notifyListeners();
        return true;
      }

      _hasPassword = false;
      _errorMessage = result['message'];
      _errorCode = result['code'];
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _hasPassword = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> setTransferPassword(String transferPassword) async {
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferBalance.setTransferPassword(transferPassword);

      _isLoading = false;

      if (!result['success']) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        _hasPassword = false;
        notifyListeners();
        return false;
      }
      _hasPassword = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _hasPassword = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
