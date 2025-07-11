import 'package:flutter/material.dart';

import '../domain/entities/account.dart';
import '../domain/entities/transaction.dart';
import '../services/mock_api.dart';

class AccountProvider with ChangeNotifier {
  Account? _account;
  bool _isLoading = false;
  String? _errorMessage;
  List<Transaction> _transactions = [];

  Account? get account => _account;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Transaction> get transactions => _transactions;

  final MockApi _mockApi = MockApi();

  Future<void> fetchAccountBalance(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _mockApi.getAccount(userId);
      if (response != null) {
        _account = Account.fromJson(response);
      } else {
        _errorMessage = "Conta não encontrada";
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> transferFunds(String fromAccountId, String toAccountId, double amount) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _mockApi.transferFunds(fromAccountId, toAccountId, amount);
      if (response["success"]) {
        await fetchAccountBalance(fromAccountId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response["message"];
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _mockApi.login(username, password);
      if (user != null) {
        await fetchAccountBalance(user["id"]);
      } else {
        _errorMessage = "Usuário ou senha inválidos";
      }
      return user;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> register(String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _mockApi.register(username, email, password);
      if (user != null) {
        await fetchAccountBalance(user["id"]);
      }
      return user;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _account = null;
    _transactions = [];
    await _mockApi.logout();
    notifyListeners();
  }

  Future<void> getTransactions() async {
    if (_account == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _mockApi.getTransactions(_account!.id);
      _transactions = data.map((e) => Transaction.fromJson(e)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _mockApi.addTransaction(transaction.toJson());
      await getTransactions();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  Future<void> refreshAccountBalance() async {
    if (_account != null) {
      await fetchAccountBalance(_account!.userId);
    }
  }
}
