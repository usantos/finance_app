import 'package:financial_app/data/models/user_request.dart';
import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/domain/entities/account.dart';
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

  Future<bool> login(String cpf, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _authUseCase(cpf, password);
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

  @visibleForTesting
  void setCurrentUser(UserResponse? user) {
    _currentUser = user;
  }

  UserRequest toUserRequest(String name, String cpf, String phone, String email, String password) {
    UserRequest userRequest = UserRequest(name: name, cpf: cpf, phone: phone, email: email, password: password);
    return userRequest;
  }

  Future<bool> register(UserRequest userRequest) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _authUseCase.register(userRequest);
      var successLogin = false;
      if (_currentUser != null) {
        successLogin = await login(userRequest.cpf, userRequest.password);
        if (!successLogin) {
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
