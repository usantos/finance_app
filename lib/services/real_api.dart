import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RealApi {
  final Dio _dio;

  RealApi({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://192.168.1.16:3000'));

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await _dio.post('/login', data: {'username': username, 'password': password});

      if (response.data != null && response.data is Map<String, dynamic>) {
        return response.data;
      }
      debugPrint('Resposta inesperada do servidor: ${response.data}');
      return null;
    } catch (e) {
      debugPrint('Erro no login: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> register(String username, String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {'username': username, 'email': email, 'password': password});

      return response.data;
    } catch (e) {
      debugPrint('Erro no registro: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> logout(String token) async {
    try {
      final response = await _dio.post('/logout', options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data;
    } catch (e) {
      debugPrint('Erro no logout: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await _dio.get('/me');
      return response.data;
    } catch (e) {
      debugPrint('Erro ao buscar usuário atual: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAccount(String userId, String token) async {
    try {
      final response = await _dio.get(
        '/accounts/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } catch (e) {
      debugPrint('Erro ao buscar conta: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> transferBetweenAccounts(
    String fromAccountNumber,
    String toAccountNumber,
    double amount,
    String password,
    String token,
  ) async {
    try {
      final response = await _dio.post(
        '/accounts/transfer',
        options: Options(headers: {'Authorization': 'Bearer $token'}, validateStatus: (status) => true),
        data: {'fromAccountNumber': fromAccountNumber, 'toAccountNumber': toAccountNumber,'transfer_password': password, 'amount': amount},
      );

      if (response.statusCode == 200) {
        return {"success": true, "message": response.data['message'] ?? 'Transferência realizada com sucesso'};
      } else {
        return {"success": false, "message": response.data['error'] ?? 'Erro desconhecido na transferência'};
      }
    } catch (e) {
      return {"success": false, "message": 'Erro inesperado ao realizar transferência: $e'};
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions(String accountId) async {
    try {
      final response = await _dio.get('/accounts/$accountId/transactions');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      debugPrint('Erro ao buscar transações: $e');
      return [];
    }
  }

  Future<void> addTransaction(Map<String, dynamic> transaction) async {
    try {
      await _dio.post('/transactions', data: transaction);
    } catch (e) {
      debugPrint('Erro ao adicionar transação: $e');
    }
  }

  Future<Map<String, dynamic>> transferFunds(String fromAccountId, String toAccountId, double amount) async {
    try {
      final response = await _dio.post(
        '/transfer',
        data: {'fromAccountId': fromAccountId, 'toAccountId': toAccountId, 'amount': amount},
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro na transferência: $e');
      return {"success": false, "message": "Erro ao realizar transferência"};
    }
  }
}
