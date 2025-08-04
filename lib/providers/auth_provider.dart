import 'package:flutter/material.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/services/mock_api.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  final MockApi _mockApi = MockApi();

  User? get user => _user;
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

  void _setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _mockApi.login(username, password);
      if (response != null) {
        _setUser(User.fromJson(response));
        _setLoading(false);
        return true;
      } else {
        _setError("Usuário ou senha inválidos");
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _mockApi.register(username, email, password);
      if (response != null) {
        _setUser(User.fromJson(response));
        _setLoading(false);
        return true;
      } else {
        _setError("Erro ao registrar usuário");
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _setUser(null);
  }
}
