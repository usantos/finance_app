import 'package:financial_app/domain/entities/user.dart';
import 'package:financial_app/domain/usecases/get_account.dart';
import 'package:financial_app/domain/usecases/get_current_user.dart';
import 'package:financial_app/domain/usecases/login_user.dart';
import 'package:financial_app/domain/usecases/logout_user.dart';
import 'package:financial_app/domain/usecases/register_user.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_viewmodel_test.mocks.dart';
import 'auth_viewmodel_test.mocks.dart' hide MockGetAccount;

@GenerateMocks([LoginUser, RegisterUser, LogoutUser, GetCurrentUser, GetAccount])
void main() {
  late MockLoginUser mockLoginUser;
  late MockRegisterUser mockRegisterUser;
  late MockLogoutUser mockLogoutUser;
  late MockGetCurrentUser mockGetCurrentUser;

  late MockGetAccount mockGetAccount;
  late AuthViewModel authViewModel;

  final testUser = User(
    id: 'user1',
    username: 'testuser',
    email: 'test@example.com',
  );

  setUp(() {
    mockLoginUser = MockLoginUser();
    mockRegisterUser = MockRegisterUser();
    mockLogoutUser = MockLogoutUser();
    mockGetCurrentUser = MockGetCurrentUser();
    mockGetAccount = MockGetAccount();

    authViewModel = AuthViewModel(
      loginUser: mockLoginUser,
      registerUser: mockRegisterUser,
      logoutUser: mockLogoutUser,
      getCurrentUser: mockGetCurrentUser,
      getAccount: mockGetAccount,
    );
  });

  group('AuthViewModel', () {
    test('login returns true and sets currentUser on success', () async {
      when(mockLoginUser('username', 'password'))
          .thenAnswer((_) async => testUser);

      final result = await authViewModel.login('username', 'password');

      expect(result, true);
      expect(authViewModel.currentUser, testUser);
      expect(authViewModel.errorMessage, isNull);
      expect(authViewModel.isLoading, false);
    });

    test('login returns false and sets errorMessage on invalid credentials', () async {
      when(mockLoginUser('username', 'password'))
          .thenAnswer((_) async => null);

      final result = await authViewModel.login('username', 'password');

      expect(result, false);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.errorMessage, 'Credenciais inválidas.');
      expect(authViewModel.isLoading, false);
    });

    test('login returns false and sets errorMessage on exception', () async {
      when(mockLoginUser('username', 'password'))
          .thenThrow(Exception('Erro no login'));

      final result = await authViewModel.login('username', 'password');

      expect(result, false);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.errorMessage, contains('Exception'));
      expect(authViewModel.isLoading, false);
    });

    test('register returns true and sets currentUser on success', () async {
      when(mockRegisterUser('username', 'email', 'password'))
          .thenAnswer((_) async => testUser);

      final result = await authViewModel.register('username', 'email', 'password');

      expect(result, true);
      expect(authViewModel.currentUser, testUser);
      expect(authViewModel.errorMessage, isNull);
      expect(authViewModel.isLoading, false);
    });

    test('register returns false and sets errorMessage on failure', () async {
      when(mockRegisterUser('username', 'email', 'password'))
          .thenAnswer((_) async => null);

      final result = await authViewModel.register('username', 'email', 'password');

      expect(result, false);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.errorMessage, 'Falha no cadastro.');
      expect(authViewModel.isLoading, false);
    });

    test('register returns false and sets errorMessage on exception', () async {
      when(mockRegisterUser('username', 'email', 'password'))
          .thenThrow(Exception('Erro no cadastro'));

      final result = await authViewModel.register('username', 'email', 'password');

      expect(result, false);
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.errorMessage, contains('Exception'));
      expect(authViewModel.isLoading, false);
    });

    test('logout sets currentUser to null on success', () async {
      when(mockLogoutUser()).thenAnswer((_) async => Future.value());

      authViewModel = AuthViewModel(
        loginUser: mockLoginUser,
        registerUser: mockRegisterUser,
        logoutUser: mockLogoutUser,
        getCurrentUser: mockGetCurrentUser,
        getAccount: mockGetAccount,
      );

      authViewModel.setCurrentUser(testUser);

      await authViewModel.logout();

      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.errorMessage, isNull);
      expect(authViewModel.isLoading, false);
    });

    test('logout sets errorMessage on exception', () async {
      when(mockLogoutUser()).thenThrow(Exception('Erro no logout'));

      authViewModel.setCurrentUser(testUser);

      await authViewModel.logout();

      expect(authViewModel.errorMessage, contains('Exception'));
      expect(authViewModel.isLoading, false);
    });

    test('checkCurrentUser sets currentUser on success', () async {
      when(mockGetCurrentUser()).thenAnswer((_) async => testUser);

      await authViewModel.checkCurrentUser();

      expect(authViewModel.currentUser, testUser);
      expect(authViewModel.errorMessage, isNull);
      expect(authViewModel.isLoading, false);
    });

    test('checkCurrentUser sets errorMessage on exception', () async {
      when(mockGetCurrentUser()).thenThrow(Exception('Erro ao buscar usuário'));

      await authViewModel.checkCurrentUser();

      expect(authViewModel.errorMessage, contains('Exception'));
      expect(authViewModel.isLoading, false);
    });
  });
}
