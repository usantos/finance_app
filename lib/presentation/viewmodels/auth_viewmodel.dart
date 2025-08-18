import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/usecases/get_account.dart';
import 'package:financial_app/domain/usecases/get_current_user.dart';
import 'package:financial_app/domain/usecases/login_user.dart';
import 'package:financial_app/domain/usecases/logout_user.dart';
import 'package:financial_app/domain/usecases/register_user.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUser _loginUser;
  final RegisterUser _registerUser;
  final LogoutUser _logoutUser;
  final GetCurrentUser _getCurrentUser;
  final GetAccount _getAccount;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  Account? _account;

  AuthViewModel({
    required LoginUser loginUser,
    required RegisterUser registerUser,
    required LogoutUser logoutUser,
    required GetCurrentUser getCurrentUser,
    required GetAccount getAccount,
    required AccountViewModel accountViewModel,
  }) : _loginUser = loginUser,
       _registerUser = registerUser,
       _logoutUser = logoutUser,
       _getCurrentUser = getCurrentUser,
       _getAccount = getAccount;

  User? get currentUser => _currentUser;
  Account? get account => _account;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _loginUser(username, password);
      _account = await _getAccount(currentUser?.id ?? "");
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

  @visibleForTesting
  void setCurrentUser(User? user) {
    _currentUser = user;
  }

  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = (await _registerUser(username, email, password));
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
      final logout = await _logoutUser();
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

  Future<void> checkCurrentUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = (await _getCurrentUser());
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
