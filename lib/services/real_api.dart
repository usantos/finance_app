import 'package:dio/dio.dart';
import 'package:financial_app/data/models/user_request.dart';
import 'package:flutter/material.dart';

class RealApi {
  final Dio _dio;
  String? _token;

  RealApi({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://192.168.0.113:3000')) {
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

  Future<Map<String, dynamic>> validateTransferPassword(String accountId, String transferPassword) async {
    try {
      final response = await _dio.post(
        '/transfers/validate_transfer_password',
        options: Options(validateStatus: (status) => true),
        data: {'accountId': accountId, 'transferPassword': transferPassword},
      );
      return response.data;
    } catch (e) {
      debugPrint('Erro ao validar senha de transferência: $e');
      return {"success": false, "message": "Erro ao validar senha de transferência"};
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
          'oldTransferPassword': oldTransferPassword,
          'newTransferPassword': newTransferPassword,
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
  ) async {
    try {
      final response = await _dio.post(
        '/transfers/transfer',
        options: Options(validateStatus: (status) => true),
        data: {'fromAccountNumber': fromAccountNumber, 'toAccountNumber': toAccountNumber, 'amount': amount},
      );
      return response.data;
    } catch (e) {
      debugPrint('Erro na transferência: $e');
      return {"success": false, "message": "Erro na transferência"};
    }
  }

  Future<Map<String, dynamic>> createPixKey(String accountId, String keyType, String keyValue) async {
    try {
      final response = await _dio.post(
        '/pix/create_pix_key',
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
      final response = await _dio.get('/pix/get_pix_keys_by_accountId/$accountId');

      if (response.statusCode == 200 && response.data['pixKeys'] is List) {
        final data = (response.data['pixKeys'] as List).whereType<Map<String, dynamic>>().toList();

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
      final response = await _dio.delete('/pix/delete_pix_key/$keyType/$keyValue');

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
    String userId,
  ) async {
    try {
      final response = await _dio.post(
        '/pix/transfer_pix',
        data: {'fromAccountId': fromAccountId, 'toPixKeyValue': toPixKeyValue, 'amount': amount},
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
        '/pix/create_pix_qr',
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
      final response = await _dio.delete('/pix/delete_qr_code/$txid');

      return response.data;
    } catch (e) {
      debugPrint('Erro ao deletar QR Code PIX: $e');
      return {"success": false, "message": "Erro ao deletar QR Code PIX"};
    }
  }

  Future<List<Map<String, dynamic>>> getQrCode(String payload) async {
    try {
      final response = await _dio.get('/pix/get_qr_code/$payload');

      if (response.statusCode == 200 && response.data['pixQr'] is List) {
        final data = (response.data['pixQr'] as List).whereType<Map<String, dynamic>>().toList();

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
    String userId,
  ) async {
    try {
      final response = await _dio.post(
        '/pix/transfer_qr_code',
        data: {'fromAccountId': fromAccountId, 'toPayloadValue': toPayloadValue, 'amount': amount},
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
        '/credit_card/create_credit_card',
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
      final response = await _dio.get('/credit_card/get_credit_card_by_accountId/$accountId');

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
      final response = await _dio.post('/credit_card/update_block_type/$cardId', data: {'blockType': blockType});

      return response.data;
    } catch (e) {
      debugPrint('Erro ao bloquear/desbloquear cartão de crédito: $e');
      return {"success": false, "message": "Erro ao bloquear/desbloquear cartão de crédito"};
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions(String accountId) async {
    try {
      final response = await _dio.get('/transfers/get_transactions/$accountId');

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
      final response = await _dio.delete('/credit_card/delete_credit_card/$cardId');

      return response.data;
    } catch (e) {
      debugPrint('Erro ao deletar cartão de crédito: $e');
      return {"success": false, "message": "Erro ao deletar cartão de crédito"};
    }
  }

  Future<Map<String, dynamic>> rechargePhone(String accountId, double value) async {
    try {
      final response = await _dio.post('/transfers/recharge_phone', data: {'accountId': accountId, 'value': value});

      return response.data;
    } catch (e) {
      debugPrint('Erro ao realizar recarga: $e');
      return {"success": false, "message": "Erro ao realizar recarga"};
    }
  }

  Future<Map<String, dynamic>> adjustLimit(String cardId, String accountId, double newLimitAvailable) async {
    try {
      final response = await _dio.post(
        '/credit_card/adjust_limit/$cardId',
        data: {'accountId': accountId, 'newLimitAvailable': newLimitAvailable},
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro ao ajustar limite do cartão de crédito: $e');
      return {"success": false, "message": "Erro ao ajustar limite do cartão de crédito"};
    }
  }

  Future<Map<String, dynamic>> setNewPhoneNumber(String newPhone, String userId, String oldPhone) async {
    try {
      final response = await _dio.post(
        '/users/set_new_phone_number',
        data: {'newPhone': newPhone, 'userId': userId, 'oldPhone': oldPhone},
      );

      return response.data;
    } catch (e) {
      debugPrint('Erro ao trocar número de telefone: $e');
      return {"success": false, "message": "Erro ao trocar número de telefone"};
    }
  }
}
