import 'package:financial_app/data/datasources/account_local_data_source.dart';
import 'package:financial_app/data/datasources/account_local_data_source_impl.dart';
import 'package:financial_app/data/datasources/account_remote_datasource.dart';
import 'package:financial_app/data/datasources/account_remote_datasource_impl.dart';
import 'package:financial_app/data/datasources/auth_remote_datasource.dart';
import 'package:financial_app/data/datasources/auth_remote_datasource_impl.dart';
import 'package:financial_app/data/datasources/transaction_remote_datasource.dart';
import 'package:financial_app/data/datasources/transaction_remote_datasource_impl.dart';
import 'package:financial_app/data/datasources/user_local_data_source.dart';
import 'package:financial_app/data/datasources/user_local_data_source_impl.dart';
import 'package:financial_app/data/repositories/impl/account_repository_impl.dart';
import 'package:financial_app/data/repositories/impl/auth_repository_impl.dart';
import 'package:financial_app/data/repositories/impl/transaction_repository_impl.dart';
import 'package:financial_app/domain/repositories/account_repository.dart';
import 'package:financial_app/domain/repositories/auth_repository.dart';
import 'package:financial_app/domain/repositories/transaction_repository.dart';
import 'package:financial_app/domain/usecases/account_usecase.dart';
import 'package:financial_app/domain/usecases/auth_usecase.dart';
import 'package:financial_app/domain/usecases/transfer_usecase.dart';
import 'package:financial_app/presentation/viewmodels/account_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:financial_app/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:financial_app/services/mock_api.dart';
import 'package:financial_app/services/real_api.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {
  // ViewModels
  sl.registerLazySingleton<AccountViewModel>(() => AccountViewModel(accountUseCase: sl()));

  sl.registerFactory(() => AuthViewModel(authUseCase: sl(), accountUseCase: sl(), accountViewModel: sl()));

  sl.registerFactory(() => TransactionViewModel(transferUseCase: sl(), accountUseCase: sl(), accountViewModel: sl()));

  // Use cases
  sl.registerLazySingleton(() => AuthUseCase(sl(), sl(), sl()));
  sl.registerLazySingleton(() => AccountUseCase(sl(), sl(), sl()));
  sl.registerLazySingleton(() => TransferUseCase(sl(), sl(), sl(), sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(sl()));
  sl.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AccountRemoteDataSource>(() => AccountRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<TransactionRemoteDataSource>(() => TransactionRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl());
  sl.registerLazySingleton<AccountLocalDataSource>(() => AccountLocalDataSourceImpl());

  // Internal
  sl.registerLazySingleton(() => MockApi());

  // External
  sl.registerLazySingleton(() => RealApi());
}
