import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:financial_app/domain/usecases/transfer_usecase.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_viewmodel_test.mocks.dart';
import 'transaction_viewmodel_test.mocks.dart' hide MockAccountUseCase;


@GenerateMocks([
  TransferUseCase,
  AccountUseCase,
  AccountViewModel,
  TransactionViewModel,
])
void main() {
  late MockTransferUseCase mockTransferUseCase;
  late MockAccountUseCase mockAccountUseCase;
  late MockAccountViewModel mockAccountViewModel;
  late TransactionViewModel transactionViewModel;


  final testAccount = Account(
    id: 'acc1',
    userId: 'user1',
    accountNumber: '12345-7',
    balance: 100.0,
  );


  setUp(() {
    mockTransferUseCase = MockTransferUseCase();
    mockAccountUseCase = MockAccountUseCase();
    mockAccountViewModel = MockAccountViewModel();

    transactionViewModel = TransactionViewModel(
      transferUseCase: mockTransferUseCase,
      accountUseCase: mockAccountUseCase,
      accountViewModel: mockAccountViewModel,
    );
  });

  group('transferBetweenAccounts', () {
    setUp(() {
      // Inicializa a conta no viewmodel
      transactionViewModel.setAccount(testAccount.copyWith());
      when(mockAccountViewModel.updateAccount(any)).thenReturn(null);
    });

    test('successfully transfers and updates account balance', () async {
      // Stub do TransferUseCase
      when(mockTransferUseCase.call('accDest1', 50.0))
          .thenAnswer((_) async => {'success': true, 'message': 'Transferência realizada'});

      // Stub do AccountUseCase para saldo atualizado
      when(mockAccountUseCase.call())
          .thenAnswer((_) async => testAccount.copyWith(balance: 50.0));

      final result = await transactionViewModel.transferBetweenAccounts(
        'accDest1',
        50.0,
      );

      expect(result, true);
      expect(transactionViewModel.account!.balance, 50.0);
      expect(transactionViewModel.errorMessage, isNull);
    });

    test('fails transfer and sets errorMessage', () async {
      // Stub do TransferUseCase com falha
      when(mockTransferUseCase.call('86271-0', 150.0))
          .thenAnswer((_) async => {'success': false, 'message': 'Saldo insuficiente'});

      // Stub do AccountUseCase mantém saldo inalterado
      when(mockAccountUseCase.call())
          .thenAnswer((_) async => testAccount.copyWith(balance: 100.0));

      final result = await transactionViewModel.transferBetweenAccounts(
        '86271-0',
        150.0,
      );

      expect(result, false);
      expect(transactionViewModel.account!.balance, 100.0);
      expect(transactionViewModel.errorMessage, 'Saldo insuficiente');
    });

    test('throws exception during transfer', () async {
      when(mockTransferUseCase.call('accDest3', 50.0))
          .thenThrow(Exception('Erro no servidor'));

      final result = await transactionViewModel.transferBetweenAccounts(
        'accDest3',
        50.0,
      );

      expect(result, false);
      expect(transactionViewModel.account!.balance, 100.0);
      expect(transactionViewModel.errorMessage, contains('Exception'));
    });

    test('fails transfer if account is null', () async {
      transactionViewModel.setAccount(null);

      final result = await transactionViewModel.transferBetweenAccounts(
        'accDest4',
        50.0,
      );

      expect(result, false);
      expect(transactionViewModel.errorMessage, isNotNull);
    });
  });

}


