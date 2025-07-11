import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/usecases/get_current_user.dart';
import 'package:financial_app/domain/usecases/login_user.dart';
import 'package:financial_app/domain/usecases/logout_user.dart';
import 'package:financial_app/domain/usecases/register_user.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUser _loginUser;
  final RegisterUser _registerUser;
  final LogoutUser _logoutUser;
  final GetCurrentUser _getCurrentUser;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel({
    required LoginUser loginUser,
    required RegisterUser registerUser,
    required LogoutUser logoutUser,
    required GetCurrentUser getCurrentUser,
  }) : _loginUser = loginUser,
       _registerUser = registerUser,
       _logoutUser = logoutUser,
       _getCurrentUser = getCurrentUser;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _loginUser(username, password);
      if (_currentUser == null) {
        _errorMessage = 'Credenciais inválidas.';
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

  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _registerUser(username, email, password);
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

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _logoutUser();
      _currentUser = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkCurrentUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _getCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
