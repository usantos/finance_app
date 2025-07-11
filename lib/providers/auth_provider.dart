import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/services/mock_api.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final MockApi _mockApi = MockApi();

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _mockApi.login(username, password);

      if (response != null) {
        _user = User.fromJson(response);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Usuário ou senha inválidos";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _mockApi.register(username, email, password);

      if (response != null) {
        _user = User.fromJson(response);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Erro ao registrar usuário";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
