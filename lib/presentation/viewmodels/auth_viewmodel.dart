import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:financial_app/domain/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthUseCase _authUseCase;
  final AccountUseCase _accountUseCase;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  Account? _account;

  AuthViewModel({required AuthUseCase authUseCase, required AccountUseCase accountUseCase})
    : _authUseCase = authUseCase,
      _accountUseCase = accountUseCase;

  User? get currentUser => _currentUser;
  Account? get account => _account;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _authUseCase(username, password);
      _account = await _accountUseCase();
      if (_currentUser == null || _account == null) {
        _errorMessage = 'Credenciais inválidas.';
      }
      return _currentUser != null && _account != null;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? validateUser(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }

    if (value.length < 4) {
      return "A senha deve ter pelo menos 4 caracteres";
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obrigatório";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return "E-mail inválido";
    }

    return null;
  }

  @visibleForTesting
  void setCurrentUser(User? user) {
    _currentUser = user;
  }

  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = (await _authUseCase.register(username, email, password));
      if (_currentUser == null) {
        _errorMessage = 'Falha no cadastro.';
      }
      return _currentUser != null;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final logout = await _authUseCase.logout();
      if (logout == true) {
        _currentUser = null;
        _account = null;
        return true;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<User?> checkCurrentUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _authUseCase.getCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }
}
