import 'package:financial_app/domain/entities/transaction.dart';
import 'package:financial_app/domain/usecases/add_transaction.dart';
import 'package:financial_app/domain/usecases/get_transactions.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transaction_viewmodel_test.mocks.dart';

@GenerateMocks([GetTransactions, AddTransaction])
void main() {
  late MockGetTransactions mockGetTransactions;
  late MockAddTransaction mockAddTransaction;
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

  setUp(() {
    mockGetTransactions = MockGetTransactions();
    mockAddTransaction = MockAddTransaction();

    transactionViewModel = TransactionViewModel(
      getTransactions: mockGetTransactions,
      addTransaction: mockAddTransaction,
    );
  });

  group('TransactionViewModel', () {
    test('fetchTransactions updates transactions on success', () async {
      when(mockGetTransactions('acc1'))
          .thenAnswer((_) async => [testTransaction]);

      await transactionViewModel.fetchTransactions('acc1');

      expect(transactionViewModel.transactions, [testTransaction]);
      expect(transactionViewModel.isLoading, false);
      expect(transactionViewModel.errorMessage, isNull);
    });

    test('fetchTransactions sets errorMessage on failure', () async {
      when(mockGetTransactions('acc1'))
          .thenThrow(Exception('Falha ao buscar'));

      await transactionViewModel.fetchTransactions('acc1');

      expect(transactionViewModel.transactions, isEmpty);
      expect(transactionViewModel.isLoading, false);
      expect(transactionViewModel.errorMessage, contains('Exception'));
    });

    test('addTransaction adds transaction on success', () async {
      when(mockAddTransaction(testTransaction))
          .thenAnswer((_) async => Future.value());

      final result = await transactionViewModel.addTransaction(testTransaction);

      expect(result, true);
      expect(transactionViewModel.transactions.contains(testTransaction), true);
      expect(transactionViewModel.errorMessage, isNull);
      expect(transactionViewModel.isLoading, false);
    });

    test('addTransaction sets errorMessage and returns false on failure', () async {
      when(mockAddTransaction(testTransaction))
          .thenThrow(Exception('Erro ao adicionar'));

      final result = await transactionViewModel.addTransaction(testTransaction);

      expect(result, false);
      expect(transactionViewModel.errorMessage, contains('Exception'));
      expect(transactionViewModel.isLoading, false);
    });
  });
}
