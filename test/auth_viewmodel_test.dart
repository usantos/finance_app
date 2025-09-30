import 'package:financial_app/data/models/user_response.dart';
import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:financial_app/domain/usecases/auth_usecase.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_viewmodel_test.mocks.dart';

@GenerateMocks([
  AuthUseCase,
  AccountUseCase,
  AccountViewModel,
])
void main() {
  late MockAuthUseCase mockAuthUseCase;
  late MockAccountUseCase mockAccountUseCase;
  late MockAccountViewModel mockAccountViewModel;
  late AuthViewModel authViewModel;

  final testUser = User(
    id: 'user1',
    username: 'testuser',
    email: 'test@example.com',
  );

  final testUserResponse = UserResponse(
    message: 'Login successful',
    token: 'dummy_token',
    user: testUser,
  );

  final testAccount = Account(
    id: "acc1",
    userId: "user1",
    accountNumber: "12345-6",
    balance: 1500.75,
  );

  setUp(() {
    mockAuthUseCase = MockAuthUseCase();
    mockAccountUseCase = MockAccountUseCase();
    mockAccountViewModel = MockAccountViewModel();

    authViewModel = AuthViewModel(
      authUseCase: mockAuthUseCase,
      accountUseCase: mockAccountUseCase,
      accountViewModel: mockAccountViewModel,
    );
  });

  group('AuthViewModel', () {
    test('login success sets currentUser and calls updateAccount', () async {
      when(mockAuthUseCase.call('username', 'password'))
          .thenAnswer((_) async => testUserResponse);
      when(mockAccountUseCase.call()).thenAnswer((_) async => testAccount);

      final result = await authViewModel.login('username', 'password');

      expect(result, true);
      expect(authViewModel.currentUser, testUserResponse);
      expect(authViewModel.errorMessage, isNull);
      verify(mockAccountViewModel.updateAccount(testAccount)).called(1);
      expect(authViewModel.isLoading, false);
    });

    test('login failure sets errorMessage', () async {
      when(mockAuthUseCase.call('username', 'password'))
          .thenAnswer((_) async => null);
      when(mockAccountUseCase.call())
          .thenAnswer((_) async => null);

      final result = await authViewModel.login('username', 'password');

      expect(result, false);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.errorMessage, 'Credenciais inválidas.');
      expect(authViewModel.isLoading, false);
    });

    test('register success calls login and sets currentUser', () async {
      when(mockAuthUseCase.register('username', 'email', 'password'))
          .thenAnswer((_) async => testUserResponse);
      when(mockAccountUseCase.call()).thenAnswer((_) async => testAccount);
      when(mockAuthUseCase.call('username', 'password'))
          .thenAnswer((_) async => testUserResponse);

      final result = await authViewModel.register('username', 'email', 'password');

      expect(result, true);
      expect(authViewModel.currentUser, testUserResponse);
      expect(authViewModel.errorMessage, isNull);
    });

    test('logout success sets currentUser to null', () async {
      when(mockAuthUseCase.logout()).thenAnswer((_) async => true);

      authViewModel.setCurrentUser(testUserResponse);

      final result = await authViewModel.logout();

      expect(result, true);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.errorMessage, isNull);
      expect(authViewModel.isLoading, false);
    });

    test('checkCurrentUser returns currentUser', () async {
      when(mockAuthUseCase.getCurrentUser())
          .thenAnswer((_) async => testUserResponse);

      final user = await authViewModel.checkCurrentUser();

      expect(user, testUserResponse);
      expect(authViewModel.currentUser, testUserResponse);
    });
  });
}
