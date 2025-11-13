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
      }
      return response.data;
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
      return response.data;
    } catch (e) {
      debugPrint('Erro ao verificar senha de transferência: $e');
      return {"success": false, "message": "Erro ao verificar senha de transferência"};
    }
  }

  Future<Map<String, dynamic>> setTransferPassword(String accountNumber, String transferPassword) async {
    try {
      final response = await _dio.post(
        '/transfers/set_transfer_password',
        options: Options(validateStatus: (status) => true),
        data: {'accountNumber': accountNumber, 'transferPassword': transferPassword},
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro ao criar senha de transferência: $e');
      return {"success": false, "message": "Erro ao criar senha de transferência"};
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

      return response.data;
    } catch (e) {
      debugPrint('Erro ao trocar senha de transferência: $e');
      return {"success": false, "message": "Erro ao trocar senha de transferência"};
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
          'transferPassword': password,
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

  Future<Map<String, dynamic>> deletePixKey(String keyType, String keyValue) async {
    try {
      final response = await _dio.delete('/pix/deletePixKey/$keyType/$keyValue');

      return response.data;
    } catch (e) {
      debugPrint('Erro ao deletar chave PIX: $e');
      return {"success": false, "message": "Erro ao deletar chave PIX"};
    }
  }

  Future<Map<String, dynamic>> transferPix(
    String fromAccountId,
    String toPixKeyValue,
    double amount,
    String transferPassword,
    String userId,
  ) async {
    try {
      final response = await _dio.post(
        '/pix/transferPix',
        data: {
          'fromAccountId': fromAccountId,
          'toPixKeyValue': toPixKeyValue,
          'amount': amount,
          'transferPassword': transferPassword,
        },
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro ao realizar transferência PIX: $e');
      return {"success": false, "message": "Erro ao realizar transferência PIX"};
    }
  }

  Future<Map<String, dynamic>> createQrCodePix(String accountId, double amount, String userId) async {
    try {
      final response = await _dio.post(
        '/pix/createPixQr',
        data: {'accountId': accountId, 'amount': amount, 'userId': userId, 'expiresInMinutes': 15},
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro ao criar QR Code PIX: $e');
      return {"success": false, "message": "Erro ao criar QR Code PIX"};
    }
  }

  Future<Map<String, dynamic>> deleteQrCode(String txid) async {
    try {
      final response = await _dio.delete('/pix/deleteQrCode/$txid');

      return response.data;
    } catch (e) {
      debugPrint('Erro ao deletar QR Code PIX: $e');
      return {"success": false, "message": "Erro ao deletar QR Code PIX"};
    }
  }

  Future<List<Map<String, dynamic>>> getQrCode(String payload) async {
    try {
      final response = await _dio.get('/pix/getQrCode/$payload');

      if (response.statusCode == 200 && response.data is List) {
        final data = (response.data as List).whereType<Map<String, dynamic>>().toList();

        return data;
      } else {
        debugPrint('Erro ao buscar QR Code: ${response.data}');
        return [];
      }
    } catch (e) {
      debugPrint('Erro ao buscar QR Code: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> transferQrCode(
    String fromAccountId,
    String toPayloadValue,
    double amount,
    String transferPassword,
    String userId,
  ) async {
    try {
      final response = await _dio.post(
        '/pix/transferQrCode',
        data: {
          'fromAccountId': fromAccountId,
          'toPayloadValue': toPayloadValue,
          'amount': amount,
          'transferPassword': transferPassword,
        },
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro ao realizar transferência via QR Code PIX: $e');
      return {"success": false, "message": "Erro ao realizar transferência via QR Code PIX"};
    }
  }

  Future<Map<String, dynamic>> createCreditCard(String accountId, String name, String password) async {
    try {
      final response = await _dio.post(
        '/creditCard/createCreditCard',
        data: {'accountId': accountId, 'name': name, 'password': password},
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro na criação do cartão de crédito: $e');
      return {"success": false, "message": "Erro na criação do cartão de crédito"};
    }
  }

  Future<List<Map<String, dynamic>>> getCreditCardByAccountId(String accountId) async {
    try {
      final response = await _dio.get('/creditCard/getCreditCardByAccountId/$accountId');

      if (response.statusCode == 200 && response.data is List) {
        final data = (response.data as List).whereType<Map<String, dynamic>>().toList();

        return data;
      } else {
        debugPrint('Erro ao buscar cartão de crédito: ${response.data}');
        return [];
      }
    } catch (e) {
      debugPrint('Erro ao buscar cartão de crédito: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> updateBlockType(String cardId, String blockType) async {
    try {
      final response = await _dio.post('/creditCard/updateBlockType/$cardId', data: {'blockType': blockType});

      return response.data;
    } catch (e) {
      debugPrint('Erro ao bloquear/desbloquear cartão de crédito: $e');
      return {"success": false, "message": "Erro ao bloquear/desbloquear cartão de crédito"};
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions(String accountId) async {
    try {
      final response = await _dio.get('/transfers/getTransactions/$accountId');

      if (response.statusCode == 200 && response.data is List) {
        final data = (response.data as List).whereType<Map<String, dynamic>>().toList();

        return data;
      } else {
        debugPrint('Erro ao buscar transações: ${response.data}');
        return [];
      }
    } catch (e) {
      debugPrint('Erro ao buscar transações: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> deleteCreditCard(String cardId) async {
    try {
      final response = await _dio.delete('/creditCard/deleteCreditCard/$cardId');

      return response.data;
    } catch (e) {
      debugPrint('Erro ao deletar cartão de crédito: $e');
      return {"success": false, "message": "Erro ao deletar cartão de crédito"};
    }
  }

  Future<Map<String, dynamic>> rechargePhone(String accountId, String transferPassword, double value) async {
    try {
      final response = await _dio.post(
        '/transfers/rechargePhone',
        data: {'accountId': accountId, 'transferPassword': transferPassword, 'value': value},
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro ao realizar recarga: $e');
      return {"success": false, "message": "Erro ao realizar recarga"};
    }
  }

  Future<Map<String, dynamic>> adjustLimit(
    String cardId,
    String accountId,
    double newLimitAvailable,
    String transferPassword,
  ) async {
    try {
      final response = await _dio.post(
        '/creditCard/adjustLimit/$cardId',
        data: {'accountId': accountId, 'newLimitAvailable': newLimitAvailable, 'transferPassword': transferPassword},
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro ao ajustar limite do cartão de crédito: $e');
      return {"success": false, "message": "Erro ao ajustar limite do cartão de crédito"};
    }
  }
}
