import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/usecases/get_account.dart';
import 'package:financial_app/domain/usecases/update_account_balance.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_viewmodel_test.mocks.dart';

@GenerateMocks([GetAccount, UpdateAccountBalance])
void main() {
  late MockGetAccount mockGetAccount;
  late MockUpdateAccountBalance mockUpdateAccountBalance;
  late AccountViewModel viewModel;

  final testAccount = Account(
    id: 'acc1',
    userId: 'user1',
    accountNumber: '12345-7',
    balance: 100.0,
  );

  setUp(() {
    mockGetAccount = MockGetAccount();
    mockUpdateAccountBalance = MockUpdateAccountBalance();
    viewModel = AccountViewModel(
      getAccount: mockGetAccount,
      updateAccountBalance: mockUpdateAccountBalance,
    );
  });

  group('AccountViewModel', () {
    test('fetchAccount should update account on success', () async {
      when(mockGetAccount('user1')).thenAnswer((_) async => testAccount);

      await viewModel.fetchAccount('user1');

      expect(viewModel.account, testAccount);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNull);
    });

    test('fetchAccount should set errorMessage on failure', () async {
      when(mockGetAccount('user1')).thenThrow(Exception('Failed to load'));

      await viewModel.fetchAccount('user1');

      expect(viewModel.account, isNull);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, contains('Exception'));
    });

    test('updateBalance should update account balance on success', () async {
      when(mockUpdateAccountBalance('acc1', 150.0))
          .thenAnswer((_) async => Future.value());

      viewModel.setAccount(testAccount);

      final result = await viewModel.updateBalance('acc1', 150.0);

      expect(result, true);
      expect(viewModel.account!.balance, 150.0);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.isLoading, false);
    });

    test('updateBalance should return false on failure', () async {
      when(mockUpdateAccountBalance('acc1', 150.0))
          .thenThrow(Exception('Failed'));

      viewModel.setAccount(testAccount);

      final result = await viewModel.updateBalance('acc1', 150.0);

      expect(result, false);
      expect(viewModel.errorMessage, contains('Exception'));
      expect(viewModel.isLoading, false);
    });
  });
}
