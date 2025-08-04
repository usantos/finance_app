import 'package:flutter/material.dart';
import '../domain/entities/account.dart';
import '../domain/entities/transaction.dart';
import '../services/mock_api.dart';

class AccountProvider with ChangeNotifier {
  Account? _account;
  bool _isLoading = false;
  String? _errorMessage;
  List<Transaction> _transactions = [];

  final MockApi _mockApi = MockApi();

  Account? get account => _account;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Transaction> get transactions => _transactions;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setAccount(Account? account) {
    _account = account;
    notifyListeners();
  }

  void _setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  Future<void> fetchAccountBalance(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _mockApi.getAccount(userId);
      if (response != null) {
        _setAccount(Account.fromJson(response));
      } else {
        _setError("Conta não encontrada");
      }
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  Future<bool> transferFunds(String fromAccountId, String toAccountId, double amount) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _mockApi.transferFunds(fromAccountId, toAccountId, amount);
      if (response["success"]) {
        await fetchAccountBalance(fromAccountId);
        _setLoading(false);
        return true;
      } else {
        _setError(response["message"]);
      }
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
    return false;
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await _mockApi.login(username, password);
      if (user != null) {
        await fetchAccountBalance(user["id"]);
      } else {
        _setError("Usuário ou senha inválidos");
      }
      return user;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> register(String username, String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await _mockApi.register(username, email, password);
      if (user != null) {
        await fetchAccountBalance(user["id"]);
      }
      return user;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setAccount(null);
    _setTransactions([]);
    await _mockApi.logout();
  }

  Future<void> getTransactions() async {
    if (_account == null) return;

    _setLoading(true);

    try {
      final data = await _mockApi.getTransactions(_account!.id);
      _setTransactions(data.map((e) => Transaction.fromJson(e)).toList());
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _mockApi.addTransaction(transaction.toJson());
      await getTransactions();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> refreshAccountBalance() async {
    if (_account != null) {
      await fetchAccountBalance(_account!.userId);
    }
  }
}
