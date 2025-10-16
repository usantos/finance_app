import 'package:dio/dio.dart';
import 'package:financial_app/data/models/user_request.dart';
import 'package:flutter/material.dart';

class RealApi {
  final Dio _dio;
  String? _token;

  RealApi({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://192.168.1.16:3000')) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> login(String cpf, String password) async {
    try {
      final response = await _dio.post('/users/login', data: {'cpf': cpf, 'password': password});

      if (response.data != null && response.data is Map<String, dynamic>) {
        if (response.data['token'] != null) {
          _token = response.data['token'];
        }
        return response.data;
      }
      debugPrint('Resposta inesperada do servidor: ${response.data}');
      return null;
    } catch (e) {
      debugPrint('Erro no login: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> register(UserRequest userRequest) async {
    try {
      final response = await _dio.post('/users/register', data: userRequest.toMap());

      return response.data;
    } catch (e) {
      debugPrint('Erro no registro: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> logout() async {
    try {
      final response = await _dio.post('/users/logout');
      if (response.statusCode == 200) {
        _token = null;
      }
      return response.data;
    } catch (e) {
      debugPrint('Erro no logout: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      return response.data;
    } catch (e) {
      debugPrint('Erro ao buscar usuário atual: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAccount(String userId) async {
    try {
      final response = await _dio.get('/accounts/$userId');
      return response.data;
    } catch (e) {
      debugPrint('Erro ao buscar conta: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getBalance(String accountId) async {
    try {
      final response = await _dio.get(
        '/accounts/$accountId/balance',
        options: Options(validateStatus: (status) => true),
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

  Future<Map<String, dynamic>> verifyTransferPassword(String accountNumber) async {
    try {
      final response = await _dio.post(
        '/transfers/verify_transfer_password',
        options: Options(validateStatus: (status) => true),
        data: {'accountNumber': accountNumber},
      );
      return {
        "success": response.data['success'] ?? false,
        "message": response.data['message'] ?? 'Senha de transferência válida',
      };
    } catch (e) {
      return {"success": false, "message": 'Erro inesperado ao realizar validação: $e'};
    }
  }

  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword) async {
    try {
      final response = await _dio.post(
        '/transfers/set_transfer_password',
        options: Options(validateStatus: (status) => true),
        data: {'accountNumber': accountNumber, 'transferPassword': transferPassword},
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
  ) async {
    try {
      final response = await _dio.post(
        '/transfers/change_transfer_password',
        options: Options(validateStatus: (status) => true),
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
  ) async {
    try {
      final response = await _dio.post(
        '/transfers/transfer',
        options: Options(validateStatus: (status) => true),
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

  Future<Map<String, dynamic>> createPixKey(String accountId, String keyType, String keyValue) async {
    try {
      final response = await _dio.post(
        '/pix/PixKey',
        data: {'accountId': accountId, 'keyType': keyType, 'keyValue': keyValue},
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro na criação de chave PIX: $e');
      return {"success": false, "message": "Erro na criação de chave PIX"};
    }
  }

  Future<List<Map<String, dynamic>>> getPixKeysByAccountId(String accountId) async {
    try {
      final response = await _dio.get('/pix/getPixKeysByAccountId/$accountId');

      if (response.statusCode == 200 && response.data is List) {
        final data = (response.data as List).whereType<Map<String, dynamic>>().toList();

        return data;
      } else {
        debugPrint('Erro ao buscar chaves PIX: ${response.data}');
        return [];
      }
    } catch (e) {
      debugPrint('Erro ao buscar chaves PIX: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> deletePixKey(String keyType) async {
    try {
      final response = await _dio.delete('/pix/deletePixKey/$keyType');

      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      debugPrint('Erro ao deletar chave PIX: $e');
      return {"success": false, "message": "Erro ao deletar chave PIX"};
    }
  }
}
