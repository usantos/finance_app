import 'package:dio/dio.dart';

class RealApi {
  final Dio _dio;

  RealApi({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://192.168.0.113:3000'));

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await _dio.post('/login', data: {'username': username, 'password': password});

      if (response.data != null && response.data is Map<String, dynamic>) {
        return response.data;
      }

      print('Resposta inesperada do servidor: ${response.data}');
      return null;
    } catch (e) {
      print('Erro no login: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> register(String username, String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {'username': username, 'email': email, 'password': password});

      return response.data;
    } catch (e) {
      print('Erro no registro: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> logout(String token) async {
    try {
      final response = await _dio.post('/logout', options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data;
    } catch (e) {
      print('Erro no logout: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final response = await _dio.get('/me');
      return response.data;
    } catch (e) {
      print('Erro ao buscar usuário atual: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAccount(String userId, String token) async {
    try {
      final response = await _dio.get('/accounts/$userId', options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response.data;
    } catch (e) {
      print('Erro ao buscar conta: $e');
      return null;
    }
  }

  Future<void> transferBetweenAccounts(
      String fromAccountNumber,
      String toAccountId,
      double amount,
      String token
      ) async {
    try {
      await _dio.post(
        '/accounts/transfer',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'fromAccountNumber': fromAccountNumber,
          'toAccountId': toAccountId,
          'amount': amount
        },
      );
    } catch (e) {
      print('Erro ao realizar transferência: $e');
    }
  }



  Future<List<Map<String, dynamic>>> getTransactions(String accountId) async {
    try {
      final response = await _dio.get('/accounts/$accountId/transactions');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Erro ao buscar transações: $e');
      return [];
    }
  }

  Future<void> addTransaction(Map<String, dynamic> transaction) async {
    try {
      await _dio.post('/transactions', data: transaction);
    } catch (e) {
      print('Erro ao adicionar transação: $e');
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
      print('Erro na transferência: $e');
      return {"success": false, "message": "Erro ao realizar transferência"};
    }
  }
}
