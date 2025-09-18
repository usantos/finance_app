import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/entities/transaction.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:financial_app/domain/usecases/add_transaction.dart';
import 'package:financial_app/domain/usecases/get_transactions.dart';
import 'package:financial_app/domain/usecases/transfer_balance.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'transaction_viewmodel_test.mocks.dart';

@GenerateMocks([
  GetTransactions,
  AddTransaction,
  TransferBalance,
  AccountUseCase,
  AccountViewModel,
])
void main() {
  late MockGetTransactions mockGetTransactions;
  late MockAddTransaction mockAddTransaction;
  late MockTransferBalance mockTransferBalance;
  late MockAccountUseCase mockAccountUseCase;
  late MockAccountViewModel mockAccountViewModel;
  late TransactionViewModel transactionViewModel;

  final testAccount = Account(
    id: 'acc1',
    userId: 'user1',
    accountNumber: '12345-7',
    balance: 100.0,
  );

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
    mockTransferBalance = MockTransferBalance();
    mockAccountUseCase = MockAccountUseCase();
    mockAccountViewModel = MockAccountViewModel();

    transactionViewModel = TransactionViewModel(
      getTransactions: mockGetTransactions,
      addTransaction: mockAddTransaction,
      transferBalance: mockTransferBalance,
      accountUseCase: mockAccountUseCase,
      accountViewModel: mockAccountViewModel,
    );
  });

  group('TransactionViewModel', () {
    test('initial state is correct', () {
      expect(transactionViewModel.transactions, isEmpty);
      expect(transactionViewModel.isLoading, false);
      expect(transactionViewModel.errorMessage, isNull);
      expect(transactionViewModel.account, isNull);
    });

    test('fetchTransactions updates list on success', () async {
      when(mockGetTransactions('acc1'))
          .thenAnswer((_) async => [testTransaction]);

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

    test('addTransaction adds transaction on success', () async {
      when(mockAddTransaction(testTransaction)).thenAnswer((_) async {});
      when(mockAccountViewModel.updateBalance(any)).thenReturn(null);

      final result = await transactionViewModel.addTransaction(testTransaction);

      expect(result, true);
      expect(transactionViewModel.transactions.contains(testTransaction), isTrue);
      expect(transactionViewModel.errorMessage, isNull);
      expect(transactionViewModel.isLoading, false);
    });

    test('addTransaction sets errorMessage on failure', () async {
      when(mockAddTransaction(testTransaction))
          .thenThrow(Exception('Erro ao adicionar'));

      final result = await transactionViewModel.addTransaction(testTransaction);

      expect(result, false);
      expect(transactionViewModel.transactions.contains(testTransaction), isFalse);
      expect(transactionViewModel.errorMessage, contains('Exception'));
      expect(transactionViewModel.isLoading, false);
    });

    group('transferBetweenAccounts', () {
      setUp(() {
        transactionViewModel.setAccount(testAccount.copyWith());
        when(mockAccountViewModel.updateBalance(any)).thenReturn(null);
      });

      test('successfully transfers and updates account balance', () async {
        // simula sucesso na transferência
        when(mockTransferBalance('accDest1', 50.0, 'password'))
            .thenAnswer((_) async =>
        {'success': true, 'message': 'Transferência realizada'});

        // simula que o caso de uso retorna a conta atualizada (saldo reduzido)
        when(mockAccountUseCase.call())
            .thenAnswer((_) async => testAccount.copyWith(balance: 50.0));

        // seta a conta inicial
        transactionViewModel.setAccount(testAccount.copyWith());

        final result = await transactionViewModel.transferBetweenAccounts(
          'accDest1',
          50.0,
          'password',
        );

        expect(result, true);
        expect(transactionViewModel.account!.balance, 50.0);
        expect(transactionViewModel.errorMessage, isNull);
      });


      test('fails transfer and sets errorMessage', () async {
        when(mockTransferBalance('accDest2', 150.0, 'password'))
            .thenAnswer((_) async =>
        {'success': false, 'message': 'Saldo insuficiente'});

        final result = await transactionViewModel.transferBetweenAccounts(
            'accDest2', 150.0, 'password');

        expect(result, false);
        expect(transactionViewModel.account!.balance, 100.0);
        expect(transactionViewModel.errorMessage, 'Saldo insuficiente');
      });

      test('throws exception during transfer', () async {
        when(mockTransferBalance('accDest3', 50.0, 'password'))
            .thenThrow(Exception('Erro no servidor'));

        final result = await transactionViewModel.transferBetweenAccounts(
            'accDest3', 50.0, 'password');

        expect(result, false);
        expect(transactionViewModel.account!.balance, 100.0);
        expect(transactionViewModel.errorMessage, contains('Exception'));
      });

      test('fails transfer if account is null', () async {
        transactionViewModel.setAccount(null);

        final result = await transactionViewModel.transferBetweenAccounts(
            'accDest4', 50.0, 'password');

        expect(result, false);
        expect(transactionViewModel.errorMessage, isNotNull);
      });
    });
  });
}

// Extensão para copyWith em Account
extension on Account {
  Account copyWith({
    String? id,
    String? userId,
    String? accountNumber,
    double? balance,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
    );
  }
}
