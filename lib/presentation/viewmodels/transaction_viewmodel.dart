import 'dart:async';

import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/entities/transaction.dart';
import 'package:financial_app/domain/usecases/transfer_usecase.dart';

class TransactionViewModel extends ChangeNotifier {
  final TransferUseCase _transferUseCase;
  final AccountUseCase _accountUseCase;
  final AccountViewModel _accountViewModel;

  List<Transaction> _transactions = [];
  List<Map<String, dynamic>?> _pixKeys = [];
  List<Map<String, dynamic>?> _toQrCode = [];

  bool _isLoading = false;
  String? _errorMessage;
  String? _errorCode;
  bool _hasPassword = false;
  Account? _account;
  bool showErrors = false;

  TransactionViewModel({
    required TransferUseCase transferUseCase,
    required AccountUseCase accountUseCase,
    required AccountViewModel accountViewModel,
  }) : _transferUseCase = transferUseCase,
       _accountUseCase = accountUseCase,
       _accountViewModel = accountViewModel;

  List<Transaction> get transactions => _transactions;
  List<Map<String, dynamic>?> get pixKeys => _pixKeys;
  List<Map<String, dynamic>?> get toQrCode => _toQrCode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get errorCode => _errorCode;
  bool get hasPassword => _hasPassword;
  Account? get account => _account;
  Map<String, dynamic>? qrCode;
  DateTime? expiresAt;
  Timer? _qrCodeTimer;

  @visibleForTesting
  void setAccount(Account? account) {
    _account = account;
  }

  Future<void> fetchTransactions(String accountId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _transactions = await _transferUseCase.getTransactions(accountId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTransaction(Transaction transaction) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _transferUseCase.addTransaction(transaction);
      _transactions.add(transaction);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> transferBetweenAccounts(String accountId, double amount, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferUseCase(accountId, amount, password);

      _isLoading = false;

      if (!result['success']) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        await refreshAccountBalance();
        notifyListeners();
        return false;
      }
      await refreshAccountBalance();
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshAccountBalance() async {
    try {
      final account = await _accountUseCase.call();
      if (account != null) {
        _account = account;
        _accountViewModel.updateAccount(account);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> verifyTransferPassword() async {
    _errorCode = null;
    _hasPassword = false;
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _transferUseCase.verifyTransferPassword();
      _isLoading = false;

      if (result['success'] == true) {
        _hasPassword = true;
        notifyListeners();
        return true;
      }

      _hasPassword = false;
      _errorMessage = result['message'];
      _errorCode = result['code'];
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _hasPassword = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> setTransferPassword(String transferPassword) async {
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferUseCase.setTransferPassword(transferPassword);

      _isLoading = false;

      if (!result['success']) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        _hasPassword = false;
        notifyListeners();
        return false;
      }
      _hasPassword = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _hasPassword = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> changeTransferPassword(String oldTransferPassword, String newTransferPassword) async {
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferUseCase.changeTransferPassword(oldTransferPassword, newTransferPassword);

      _isLoading = false;

      if (!result['success']) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        notifyListeners();
        return false;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> createPixKey(String keyType, String keyValue) async {
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferUseCase.createPixKey(keyType, keyValue);

      _isLoading = false;

      if (!result['success']) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        notifyListeners();
        return false;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> getPixKeysByAccountId() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pixKeys = await _transferUseCase.getPixKeysByAccountId();

      _pixKeys = _pixKeys.map((pixKey) {
        final type = pixKey?["keyType"];
        String value = pixKey?["keyValue"] ?? '';

        if (type == 'CPF') {
          value = value.toCPFProgressive();
        } else if (type == 'Telefone') {
          value = value.toPhone();
        }

        return {...?pixKey, 'keyValue': value};
      }).toList();
    } catch (e) {
      _errorMessage = e.toString();
      _pixKeys = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePixKey(String keyType, String keyValue) async {
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferUseCase.deletePixKey(keyType, keyValue);

      _isLoading = false;

      if (!result['success']) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        notifyListeners();
        return false;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> transferPix(String toPixKeyValue, double amount, String transferPassword) async {
    _isLoading = true;
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferUseCase.transferPix(toPixKeyValue, amount, transferPassword);

      _isLoading = false;

      if (!(result['success'] ?? false)) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        await refreshAccountBalance();
        notifyListeners();
        return false;
      }

      await refreshAccountBalance();
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void startQrCodeExpirationTimer(String txid, DateTime expiresAt) {
    _qrCodeTimer?.cancel();
    final duration = expiresAt.difference(DateTime.now());

    if (duration.isNegative) {
      deleteQrCode(txid);
      return;
    }

    _qrCodeTimer = Timer(duration, () async {
      await deleteQrCode(txid);
      notifyListeners();
    });
  }

  void cancelQrCodeTimer() {
    _qrCodeTimer?.cancel();
    _qrCodeTimer = null;
  }

  Future<bool> createQrCodePix(double amount) async {
    _isLoading = true;
    _errorCode = null;
    notifyListeners();

    try {
      final response = await _transferUseCase.createQrCodePix(amount);
      final data = response['message'];

      _isLoading = false;
      if (!(response['success'] ?? false)) {
        _errorMessage = response['message'];
        _errorCode = response['code'];
        notifyListeners();
        return false;
      }

      expiresAt = DateTime.parse(data['expiresAt']).toLocal();
      qrCode = data;
      final txid = qrCode?['txid'];
      startQrCodeExpirationTimer(txid, expiresAt!);
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteQrCode(String txid) async {
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferUseCase.deleteQrCode(txid);

      _isLoading = false;

      if (!result['success']) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        notifyListeners();
        return false;
      }
      cancelQrCodeTimer();
      qrCode = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearQrCodeData() {
    _toQrCode = [];
    notifyListeners();
  }

  Future<void> getQrCode(String payload) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _toQrCode = await _transferUseCase.getQrCode(payload);
    } catch (e) {
      _errorMessage = e.toString();
      _toQrCode = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> transferQrCode(String toPayloadValue, double amount, String transferPassword) async {
    _isLoading = true;
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferUseCase.transferQrCode(toPayloadValue, amount, transferPassword);

      _isLoading = false;

      if (!(result['success'] ?? false)) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        await refreshAccountBalance();
        notifyListeners();
        return false;
      }

      await refreshAccountBalance();
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
