import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/usecases/get_account.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_viewmodel_test.mocks.dart';

@GenerateMocks([GetAccount])
void main() {
  late MockGetAccount mockGetAccount;
  late AccountViewModel viewModel;

  final testAccount = Account(
    id: 'acc1',
    userId: 'user1',
    accountNumber: '12345-7',
    balance: 100.0,
  );

  setUp(() {
    mockGetAccount = MockGetAccount();
    viewModel = AccountViewModel(
      getAccount: mockGetAccount,
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

    test('toggleVisibility should change isHidden state', () {
      final initialState = viewModel.isHidden;

      viewModel.toggleVisibility();
      expect(viewModel.isHidden, !initialState);

      viewModel.toggleVisibility();
      expect(viewModel.isHidden, initialState);
    });
  });
}
