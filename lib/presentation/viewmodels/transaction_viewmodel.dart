import 'dart:async';
import 'package:financial_app/core/extensions/string_ext.dart';
import 'package:financial_app/domain/model/credit_card_model.dart';
import 'package:financial_app/domain/model/transaction_model.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/usecases/transfer_usecase.dart';

class TransactionViewModel extends ChangeNotifier {
  final TransferUseCase _transferUseCase;
  final AccountUseCase _accountUseCase;
  final AccountViewModel _accountViewModel;

  List<Map<String, dynamic>?> _pixKeys = [];
  List<Map<String, dynamic>?> _toQrCode = [];
  List<Map<String, dynamic>?> _creditCard = [];
  List<Map<String, dynamic>> _transaction = [];

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
  bool _showCardDetails = true;
  bool get showCardDetails => _showCardDetails;


  CreditCardModel? get creditCardModels {
    if (_creditCard.isEmpty) return null;

    final list = _creditCard.whereType<Map<String, dynamic>>().map((map) => CreditCardModel.fromMap(map)).toList();

    return list.isNotEmpty ? list[0] : null;
  }

  List<Transaction> get transactionModels {
    try {
      return _transaction.map((map) => Transaction.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Erro ao converter transações: $e');
      return [];
    }
  }

  void toggleCardDetails() {
    _showCardDetails = !_showCardDetails;
    notifyListeners();
  }

  void setCardDetailsVisibility(bool value) {
    _showCardDetails = value;
    notifyListeners();
  }

  List<Transaction> get transactionLastWeekModels {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      return _transaction.map((map) => Transaction.fromMap(map)).where((t) {
        final date = t.date;
        return date.isAfter(sevenDaysAgo) && date.isBefore(now);
      }).toList();
    } catch (e) {
      debugPrint('Erro ao converter transações: $e');
      return [];
    }
  }

  Future<void> init() async {
    _account;
  }

  @visibleForTesting
  void setAccount(Account? account) {
    _account = account;
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

  Future<bool> createCreditCard(String password) async {
    _errorCode = null;
    notifyListeners();

    try {
      final result = await _transferUseCase.createCreditCard(password);

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

  Future<void> getCreditCardByAccountId() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _creditCard = await _transferUseCase.getCreditCardByAccountId();
    } catch (e) {
      _errorMessage = e.toString();
      _creditCard = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBlockType(String blockType) async {
    _errorCode = null;
    _isLoading = true;
    notifyListeners();

    try {
      final cardId = creditCardModels?.id ?? '';
      final result = await _transferUseCase.updateBlockType(cardId, blockType);

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

  Future<void> getTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transaction = await _transferUseCase.getTransactions();
    } catch (e) {
      _errorMessage = e.toString();
      _transaction = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCreditCard() async {
    _errorCode = null;
    notifyListeners();

    try {
      final cardId = creditCardModels?.id ?? '';
      final result = await _transferUseCase.deleteCreditCard(cardId);

      _isLoading = false;

      if (!result['success']) {
        _errorMessage = result['message'];
        _errorCode = result['code'];
        notifyListeners();
        return false;
      }
      _creditCard = [];
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
