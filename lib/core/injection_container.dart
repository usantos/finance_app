import 'package:financial_app/data/datasources/account_remote_datasource.dart';
import 'package:financial_app/data/datasources/account_remote_datasource_impl.dart';
import 'package:financial_app/data/datasources/auth_remote_datasource.dart';
import 'package:financial_app/data/datasources/auth_remote_datasource_impl.dart';
import 'package:financial_app/data/datasources/transaction_remote_datasource.dart';
import 'package:financial_app/data/datasources/transaction_remote_datasource_impl.dart';
import 'package:financial_app/data/repositories/impl/account_repository_impl.dart';
import 'package:financial_app/data/repositories/impl/auth_repository_impl.dart';
import 'package:financial_app/data/repositories/impl/transaction_repository_impl.dart';
import 'package:financial_app/domain/repositories/account_repository.dart';
import 'package:financial_app/domain/repositories/auth_repository.dart';
import 'package:financial_app/domain/repositories/transaction_repository.dart';
import 'package:financial_app/domain/usecases/add_transaction.dart';
import 'package:financial_app/domain/usecases/get_account.dart';
import 'package:financial_app/domain/usecases/get_current_user.dart';
import 'package:financial_app/domain/usecases/get_transactions.dart';
import 'package:financial_app/domain/usecases/login_user.dart';
import 'package:financial_app/domain/usecases/logout_user.dart';
import 'package:financial_app/domain/usecases/register_user.dart';
import 'package:financial_app/domain/usecases/update_account_balance.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:financial_app/services/mock_api.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {
  // ViewModels
  sl.registerFactory(
    () => AuthViewModel(loginUser: sl(), registerUser: sl(), logoutUser: sl(), getCurrentUser: sl(), getAccount: sl()),
  );
  sl.registerFactory(() => AccountViewModel(getAccount: sl(), updateAccountBalance: sl()));
  sl.registerFactory(() => TransactionViewModel(getTransactions: sl(), addTransaction: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => GetAccount(sl()));
  sl.registerLazySingleton(() => UpdateAccountBalance(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => AddTransaction(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(sl()));
  sl.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AccountRemoteDataSource>(() => AccountRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<TransactionRemoteDataSource>(() => TransactionRemoteDataSourceImpl(sl()));

  // External
  sl.registerLazySingleton(() => MockApi());
}
