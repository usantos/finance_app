import 'package:financial_app/domain/entities/account.dart';
import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:financial_app/domain/usecases/auth_usecase.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_viewmodel_test.mocks.dart';


@GenerateMocks([
  AuthUseCase,
  AccountUseCase,
  AuthViewModel,
])
void main() {
  late MockAuthUseCase mockAuthUseCase;
  late MockAccountUseCase mockAccountUseCase;
  late AuthViewModel authViewModel;

  final testUser = User(
    id: 'user1',
    username: 'testuser',
    email: 'test@example.com',
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

    authViewModel = AuthViewModel(
      authUseCase: mockAuthUseCase,
      accountUseCase: mockAccountUseCase,
    );
  });

  group('AuthViewModel', () {
    test('login returns true and sets currentUser on success', () async {
      when(mockAuthUseCase('username', 'password'))
          .thenAnswer((_) async => testUser);
      when(mockAccountUseCase()).thenAnswer((_) async => testAccount);

      final result = await authViewModel.login('username', 'password');

      expect(result, true);
      expect(authViewModel.currentUser, testUser);
      expect(authViewModel.account, testAccount);
      expect(authViewModel.errorMessage, isNull);
      expect(authViewModel.isLoading, false);
    });

    test('login returns false and sets errorMessage on invalid credentials', () async {
      when(mockAuthUseCase('username', 'password'))
          .thenAnswer((_) async => null);
      when(mockAccountUseCase()).thenAnswer((_) async => null);

      final result = await authViewModel.login('username', 'password');

      expect(result, false);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.account, isNull);
      expect(authViewModel.errorMessage, 'Credenciais inválidas.');
      expect(authViewModel.isLoading, false);
    });

    test('login returns false and sets errorMessage on exception', () async {
      when(mockAuthUseCase('username', 'password'))
          .thenThrow(Exception('Erro no login'));
      when(mockAccountUseCase()).thenAnswer((_) async => null);

      final result = await authViewModel.login('username', 'password');

      expect(result, false);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.errorMessage, contains('Exception'));
      expect(authViewModel.isLoading, false);
    });

    test('register returns true and sets currentUser on success', () async {
      when(mockAuthUseCase.register('username', 'email', 'password'))
          .thenAnswer((_) async => testUser);

      final result = await authViewModel.register('username', 'email', 'password');

      expect(result, true);
      expect(authViewModel.currentUser, testUser);
      expect(authViewModel.errorMessage, isNull);
      expect(authViewModel.isLoading, false);
    });

    test('register returns false and sets errorMessage on failure', () async {
      when(mockAuthUseCase.register('username', 'email', 'password'))
          .thenAnswer((_) async => null);

      final result = await authViewModel.register('username', 'email', 'password');

      expect(result, false);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.errorMessage, 'Falha no cadastro.');
      expect(authViewModel.isLoading, false);
    });

    test('register returns false and sets errorMessage on exception', () async {
      when(mockAuthUseCase.register('username', 'email', 'password'))
          .thenThrow(Exception('Erro no cadastro'));

      final result = await authViewModel.register('username', 'email', 'password');

      expect(result, false);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.errorMessage, contains('Exception'));
      expect(authViewModel.isLoading, false);
    });

    test('logout sets currentUser to null on success', () async {
      when(mockAuthUseCase.logout()).thenAnswer((_) async => true);

      authViewModel.setCurrentUser(testUser);

      final result = await authViewModel.logout();

      expect(result, isTrue);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.account, isNull);
      expect(authViewModel.errorMessage, isNull);
      expect(authViewModel.isLoading, false);
    });

    test('logout sets errorMessage on exception', () async {
      when(mockAuthUseCase.logout()).thenThrow(Exception('Erro no logout'));

      authViewModel.setCurrentUser(testUser);

      final result = await authViewModel.logout();

      expect(result, isFalse);
      expect(authViewModel.errorMessage, contains('Erro no logout'));
      expect(authViewModel.isLoading, false);
    });

    test('checkCurrentUser sets currentUser on success', () async {
      when(mockAuthUseCase.getCurrentUser()).thenAnswer((_) async => testUser);

      await authViewModel.checkCurrentUser();

      expect(authViewModel.currentUser, testUser);
      expect(authViewModel.errorMessage, isNull);
      expect(authViewModel.isLoading, false);
    });

    test('checkCurrentUser sets errorMessage on exception', () async {
      when(mockAuthUseCase.getCurrentUser()).thenThrow(Exception('Erro ao buscar usuário'));

      await authViewModel.checkCurrentUser();

      expect(authViewModel.errorMessage, contains('Exception'));
      expect(authViewModel.isLoading, false);
    });
  });
}
