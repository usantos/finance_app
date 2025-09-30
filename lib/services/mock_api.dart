import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MockApi {
  Future<Map<String, dynamic>> _loadJsonData(String path) async {
    final String response = await rootBundle.loadString(path);
    return json.decode(response);
  }

  Future<Map<String, dynamic>> transferFunds(String fromAccountId, String toAccountId, double amount) async {
    await Future.delayed(const Duration(seconds: 1));

    final data = await _loadJsonData('assets/mock_data/accounts.json');
    final accounts = data['accounts'] as List;

    final fromAccount = accounts.firstWhere((a) => a['id'] == fromAccountId, orElse: () => null);
    final toAccount = accounts.firstWhere((a) => a['id'] == toAccountId, orElse: () => null);

    if (fromAccount == null || toAccount == null) {
      return {"success": false, "message": "Conta de origem ou destino não encontrada"};
    }

    final double currentBalance = (fromAccount['balance'] as num).toDouble();
    if (amount > currentBalance) {
      return {"success": false, "message": "Saldo insuficiente"};
    }

    final newFromBalance = currentBalance - amount;
    final newToBalance = (toAccount['balance'] as num).toDouble() + amount;

    await updateAccountBalance(fromAccountId, newFromBalance);
    await updateAccountBalance(toAccountId, newToBalance);

    final now = DateTime.now().toIso8601String();
    await addTransaction({
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "accountId": fromAccountId,
      "amount": -amount,
      "type": "transfer_out",
      "date": now,
    });

    await addTransaction({
      "id": (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      "accountId": toAccountId,
      "amount": amount,
      "type": "transfer_in",
      "date": now,
    });

    return {"success": true, "message": "Transferência realizada com sucesso"};
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final data = await _loadJsonData('assets/mock_data/users.json');
    final users = data['users'] as List;
    final user = users.firstWhere((u) => u['username'] == username && u['password'] == password, orElse: () => null);

    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> register(String username, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'username': username,
      'email': email,
      'password': password,
    };
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    await Future.delayed(const Duration(seconds: 1));
    final data = await _loadJsonData('assets/mock_data/users.json');
    final users = data['users'] as List;
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAccount(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    final data = await _loadJsonData('assets/mock_data/accounts.json');
    final accounts = data['accounts'] as List;
    final account = accounts.firstWhere((a) => a['userId'] == userId, orElse: () => null);

    if (account != null) {
      return account;
    } else {
      return null;
    }
  }

  Future<void> updateAccountBalance(String accountId, double newBalance) async {
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('Updating account $accountId balance to $newBalance');
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions(String accountId) async {
    await Future.delayed(const Duration(seconds: 1));
    final data = await _loadJsonData('assets/mock_data/transactions.json');
    final transactions = data['transactions'] as List;
    final userTransactions = transactions.where((t) => t['accountId'] == accountId).toList();

    return List<Map<String, dynamic>>.from(userTransactions);
  }

  Future<void> addTransaction(Map<String, dynamic> transaction) async {
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('Adding transaction: $transaction');
    }
  }
}
