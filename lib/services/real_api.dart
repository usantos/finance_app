import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RealApi {
  final Dio _dio;

  RealApi({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://192.168.0.113:3000'));

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

  Future<Map<String, dynamic>?> getCurrentUser(String token) async {
    try {
      final response = await _dio.get('/me', options: Options(headers: {'Authorization': 'Bearer $token'}));
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

  Future<Map<String, dynamic>?> getBalance(String accountId, String token) async {
    try {
      final response = await _dio.get(
        '/accounts/$accountId/balance',
        options: Options(headers: {'Authorization': 'Bearer $token'}, validateStatus: (status) => true),
      );

      if (response.statusCode == 200) {
        return {"success": true, "balance": response.data['balance']};
      } else {
        return {"success": false, "message": response.data['error'] ?? 'Erro ao buscar saldo'};
      }
    } catch (e) {
      debugPrint('Erro ao buscar saldo: $e');
      return {"success": false, "message": 'Erro inesperado: $e'};
    }
  }

  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber, String token) async {
    try {
      final response = await _dio.post(
        '/accounts/verify_transfer_password',
        options: Options(headers: {'Authorization': 'Bearer $token'}, validateStatus: (status) => true),
        data: {'accountNumber': accountNumber},
      );

      if (response.statusCode == 200) {
        return {"success": true, "message": response.data['message'] ?? 'Senha de transferência válida'};
      } else {
        return {"success": false, "message": response.data['error'] ?? 'Erro desconhecido na validação da senha'};
      }
    } catch (e) {
      return {"success": false, "message": 'Erro inesperado ao realizar validação: $e'};
    }
  }

  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword, String token) async {
    try {
      final response = await _dio.post(
        '/accounts/set_transfer_password',
        options: Options(headers: {'Authorization': 'Bearer $token'}, validateStatus: (status) => true),
        data: {'accountNumber': accountNumber, 'transfer_password': transferPassword},
      );

      if (response.statusCode == 200) {
        return {"success": true, "message": response.data['message'] ?? 'Senha de transferência definida/atualizada'};
      } else {
        return {
          "success": false,
          "message": response.data['error'] ?? 'Erro desconhecido na definição/atualização da senha',
        };
      }
    } catch (e) {
      return {"success": false, "message": 'Erro inesperado ao criar senha: $e'};
    }
  }

  Future<Map<String, dynamic>> changeTransferPassword(
    String accountNumber,
    String oldTransferPassword,
    String newTransferPassword,
    String token,
  ) async {
    try {
      final response = await _dio.post(
        '/accounts/change_transfer_password',
        options: Options(headers: {'Authorization': 'Bearer $token'}, validateStatus: (status) => true),
        data: {
          'accountNumber': accountNumber,
          'old_transfer_password': oldTransferPassword,
          'new_transfer_password': newTransferPassword,
        },
      );

      if (response.statusCode == 200) {
        return {"success": true, "message": response.data['message'] ?? 'Senha de transferência alterada com sucesso'};
      } else {
        return {"success": false, "message": response.data['error'] ?? 'Erro desconhecido ao alterar senha'};
      }
    } catch (e) {
      return {"success": false, "message": 'Erro inesperado ao alterar senha: $e'};
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
        data: {
          'fromAccountNumber': fromAccountNumber,
          'toAccountNumber': toAccountNumber,
          'transfer_password': password,
          'amount': amount,
        },
      );

      if (response.statusCode == 200) {
        return {"success": true, "message": response.data['message'] ?? 'Transferência realizada com sucesso'};
      } else {
        return {
          "success": false,
          "code": response.data['code'],
          "message": response.data['error'] ?? 'Erro desconhecido na transferência',
        };
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
