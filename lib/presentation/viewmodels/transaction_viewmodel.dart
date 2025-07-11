import "package:financial_app/domain/entities/transaction.dart";
import "package:financial_app/domain/usecases/add_transaction.dart";
import "package:financial_app/domain/usecases/get_transactions.dart";
import "package:flutter/material.dart";

class TransactionViewModel extends ChangeNotifier {
  final GetTransactions _getTransactions;
  final AddTransaction _addTransaction;

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  TransactionViewModel({required GetTransactions getTransactions, required AddTransaction addTransaction})
    : _getTransactions = getTransactions,
      _addTransaction = addTransaction;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
}
