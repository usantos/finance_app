import 'package:financial_app/domain/entities/transaction.dart';
import 'package:financial_app/services/mock_api.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final MockApi _mockApi = MockApi();

  Future<void> fetchTransactions(String accountId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<Map<String, dynamic>> response = await _mockApi.getTransactions(accountId);

      _transactions = response.map((e) => Transaction.fromJson(e)).toList();
    } catch (e) {
      _errorMessage = 'Erro ao carregar transações: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }
}
