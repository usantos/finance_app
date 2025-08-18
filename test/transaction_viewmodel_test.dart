import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/entities/transaction.dart';
import 'package:financial_app/domain/usecases/add_transaction.dart';
import 'package:financial_app/domain/usecases/get_transactions.dart';
import 'package:financial_app/domain/usecases/transfer_balance.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_viewmodel_test.mocks.dart';
import 'transaction_viewmodel_test.mocks.dart';

@GenerateMocks([GetTransactions, AddTransaction, TransferBalance])
void main() {
  late MockGetTransactions mockGetTransactions;
  late MockAddTransaction mockAddTransaction;
  late MockTransferBalance mockTransferBalance;
  late TransactionViewModel transactionViewModel;

  final testTransaction = Transaction(
    id: 'tx1',
    accountId: 'acc1',
    type: 'deposit',
    amount: 100.0,
    date: DateTime.parse('2024-07-11'),
    description: 'Depósito inicial',
    fromAccount: null,
    toAccount: null,
  );

  final testAccount = Account(
    id: 'acc1',
    userId: 'user1',
    accountNumber: '12345-7',
    balance: 100.0,
  );

  setUp(() {
    mockGetTransactions = MockGetTransactions();
    mockAddTransaction = MockAddTransaction();
    mockTransferBalance = MockTransferBalance();

    transactionViewModel = TransactionViewModel(
      getTransactions: mockGetTransactions,
      addTransaction: mockAddTransaction,
      updateAccountBalance: mockTransferBalance,
    );
  });

  group('TransactionViewModel', () {
    // -------------------- fetchTransactions --------------------
    test('fetchTransactions updates transactions on success', () async {
      when(mockGetTransactions('acc1')).thenAnswer((_) async => [testTransaction]);

      await transactionViewModel.fetchTransactions('acc1');

      expect(transactionViewModel.transactions, [testTransaction]);
      expect(transactionViewModel.isLoading, false);
      expect(transactionViewModel.errorMessage, isNull);
    });

    test('fetchTransactions sets errorMessage on failure', () async {
      when(mockGetTransactions('acc1')).thenThrow(Exception('Falha ao buscar'));

      await transactionViewModel.fetchTransactions('acc1');

      expect(transactionViewModel.transactions, isEmpty);
      expect(transactionViewModel.isLoading, false);
      expect(transactionViewModel.errorMessage, contains('Exception'));
    });

    // -------------------- addTransaction --------------------
    test('addTransaction adds transaction on success', () async {
      when(mockAddTransaction(testTransaction)).thenAnswer((_) async => Future.value());

      final result = await transactionViewModel.addTransaction(testTransaction);

      expect(result, true);
      expect(transactionViewModel.transactions.contains(testTransaction), true);
      expect(transactionViewModel.errorMessage, isNull);
      expect(transactionViewModel.isLoading, false);
    });

    test('addTransaction sets errorMessage and returns false on failure', () async {
      when(mockAddTransaction(testTransaction)).thenThrow(Exception('Erro ao adicionar'));

      final result = await transactionViewModel.addTransaction(testTransaction);

      expect(result, false);
      expect(transactionViewModel.errorMessage, contains('Exception'));
      expect(transactionViewModel.isLoading, false);
    });

    // -------------------- transferBetweenAccounts --------------------
    test('transferBetweenAccounts returns true on success', () async {
      when(mockTransferBalance('acc1', 50.0, 'transfer_password'))
          .thenAnswer((_) async => {'success': true, 'message': 'Transferência realizada'});

      // usa setAccount para inicializar a conta
      transactionViewModel.setAccount(testAccount);

      final result = await transactionViewModel.transferBetweenAccounts('acc1', 50.0, 'transfer_password');

      expect(result, true);
      expect(transactionViewModel.account!.balance, 50.0);
      expect(transactionViewModel.errorMessage, isNull);
    });

    test('transferBetweenAccounts returns false on falha', () async {
      when(mockTransferBalance('acc1', 150.0, 'transfer_password'))
          .thenAnswer((_) async => {'success': false, 'message': 'Saldo insuficiente'});

      transactionViewModel.setAccount(testAccount);

      final result = await transactionViewModel.transferBetweenAccounts('acc1', 150.0, 'transfer_password');

      expect(result, false);
      expect(transactionViewModel.account!.balance, 100.0); // saldo não mudou
      expect(transactionViewModel.errorMessage, 'Saldo insuficiente');
    });

    test('transferBetweenAccounts trata exceções', () async {
      when(mockTransferBalance('acc1', 50.0, 'transfer_password')).thenThrow(Exception('Erro no servidor'));

      transactionViewModel.setAccount(testAccount);

      final result = await transactionViewModel.transferBetweenAccounts('acc1', 50.0, 'transfer_password');

      expect(result, false);
      expect(transactionViewModel.account!.balance, 100.0);
      expect(transactionViewModel.errorMessage, contains('Exception'));
    });
  });
}
