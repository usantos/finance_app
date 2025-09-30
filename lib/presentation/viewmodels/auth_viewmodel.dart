import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:financial_app/domain/usecases/auth_usecase.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthUseCase _authUseCase;
  final AccountUseCase _accountUseCase;
  final AccountViewModel _accountViewModel;

  UserResponse? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  Account? _account;

  AuthViewModel({
    required AuthUseCase authUseCase,
    required AccountUseCase accountUseCase,
    required AccountViewModel accountViewModel,
  }) : _authUseCase = authUseCase,
       _accountUseCase = accountUseCase,
       _accountViewModel = accountViewModel;

  UserResponse? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _authUseCase(username, password);
      final account = await _accountUseCase();
      if (account != null) {
        _accountViewModel.updateAccount(account);
      }
      if (_currentUser == null || account == null) {
        _errorMessage = 'Credenciais inválidas.';
      }
      return _currentUser != null && account != null;
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
  void setCurrentUser(UserResponse? user) {
    _currentUser = user;
  }

  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _authUseCase.register(username, email, password);
      var successLogin = false;
      if (_currentUser != null) {
        successLogin = await login(username, password);
        if(!successLogin) {
          _errorMessage = 'Não foi possível realizar o login.';
        }
      } else {
        _errorMessage = 'Falha no cadastro.';
      }
      return successLogin;
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

  Future<UserResponse?> checkCurrentUser() async {
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
    return _currentUser;
  }
}
