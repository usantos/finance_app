import 'package:flutter/material.dart';
import 'package:financial_app/domain/entities/transaction.dart';
import 'package:financial_app/services/mock_api.dart';

class TransactionProvider with ChangeNotifier {
  final MockApi _mockApi = MockApi();

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  Future<void> fetchTransactions(String accountId) async {
    _setLoading(true);
    _setError(null);

    try {
      final List<Map<String, dynamic>> response = await _mockApi.getTransactions(accountId);
      _setTransactions(response.map((e) => Transaction.fromJson(e)).toList());
    } catch (e) {
      _setError('Erro ao carregar transações: ${e.toString()}');
    }

    _setLoading(false);
  }
}
