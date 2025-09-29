import 'package:financial_app/core/extensions/money_ext.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'account_viewmodel_test.mocks.dart';

@GenerateMocks([AccountUseCase])
void main() {
  late MockAccountUseCase mockAccountUseCase; // corrigido
  late AccountViewModel viewModel;

  final testAccount = Account(
    id: 'acc1',
    userId: 'user1',
    accountNumber: '12345-7',
    balance: 100.0,
  );

  setUp(() {
    mockAccountUseCase = MockAccountUseCase(); // corrigido
    viewModel = AccountViewModel(
      accountUseCase: mockAccountUseCase,
    );
  });

  group('AccountViewModel', () {

    test('toggleVisibility should change isHidden state', () {
      final initialState = viewModel.isHidden;

      viewModel.toggleVisibility();
      expect(viewModel.isHidden, !initialState);

      viewModel.toggleVisibility();
      expect(viewModel.isHidden, initialState);
    });

    test('displayBalance should show "••••••" when hidden', () {
      viewModel.setAccount(testAccount);
      if (!viewModel.isHidden) viewModel.toggleVisibility();

      expect(viewModel.displayBalance, '••••••');
    });

    test('displayBalance should show balance when visible', () {
      viewModel.setAccount(testAccount);
      if (viewModel.isHidden) viewModel.toggleVisibility();

      expect(viewModel.displayBalance, testAccount.balance.toReal());
    });
  });
}
