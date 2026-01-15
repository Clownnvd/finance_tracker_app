import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:finance_tracker_app/core/network/dio_client.dart';
import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';

// =============================================================
// AUTH
// =============================================================
import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';

// =============================================================
// DASHBOARD
// =============================================================
import 'package:finance_tracker_app/feature/dashboard/data/models/dashboard_remote_data_source.dart';
import 'package:finance_tracker_app/feature/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/usecases/get_dashboard_data.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_cubit.dart';

// =============================================================
// TRANSACTIONS
// =============================================================
import 'package:finance_tracker_app/feature/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:finance_tracker_app/feature/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:finance_tracker_app/feature/transactions/domain/repositories/transactions_repository.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/add_transaction.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/get_categories.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/get_transaction_history.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_cubit.dart';

final getIt = GetIt.instance;

/// Initializes dependency injection for the entire app.
///
/// This function is safe to call multiple times (e.g., hot restart),
/// because singletons are registered only once.
void setupDI({required String supabaseUrl, required String supabaseAnonKey}) {
  // =============================================================
  // CORE / INFRASTRUCTURE
  // =============================================================

  if (!getIt.isRegistered<FlutterSecureStorage>()) {
    getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      ),
    );
  }

  if (!getIt.isRegistered<SessionLocalDataSource>()) {
    getIt.registerLazySingleton<SessionLocalDataSource>(
      () => SessionLocalDataSourceSecure(storage: getIt<FlutterSecureStorage>()),
    );
  }

  if (!getIt.isRegistered<UserIdLocalDataSource>()) {
    getIt.registerLazySingleton<UserIdLocalDataSource>(
      () => UserIdLocalDataSourceSecure(storage: getIt<FlutterSecureStorage>()),
    );
  }

  if (!getIt.isRegistered<DioClient>()) {
    getIt.registerLazySingleton<DioClient>(
      () => DioClient(
        baseUrl: supabaseUrl,
        anonKey: supabaseAnonKey,
        tokenProvider: () => getIt<SessionLocalDataSource>().getAccessToken(),
      ),
    );
  }

  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(() => getIt<DioClient>().dio);
  }

  // =============================================================
  // AUTH FEATURE
  // =============================================================

  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: getIt<AuthRemoteDataSource>(),
        sessionLocal: getIt<SessionLocalDataSource>(),
        userIdLocal: getIt<UserIdLocalDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<Login>()) {
    getIt.registerLazySingleton<Login>(() => Login(getIt<AuthRepository>()));
  }

  if (!getIt.isRegistered<Signup>()) {
    getIt.registerLazySingleton<Signup>(() => Signup(getIt<AuthRepository>()));
  }

  if (!getIt.isRegistered<AuthCubit>()) {
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(login: getIt<Login>(), signup: getIt<Signup>()),
    );
  }

  // =============================================================
  // DASHBOARD FEATURE
  // =============================================================

  if (!getIt.isRegistered<DashboardRemoteDataSource>()) {
    getIt.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSource(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<DashboardRepository>()) {
    getIt.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remote: getIt<DashboardRemoteDataSource>(),
        userIdLocal: getIt<UserIdLocalDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<GetDashboardData>()) {
    getIt.registerLazySingleton<GetDashboardData>(
      () => GetDashboardData(getIt<DashboardRepository>()),
    );
  }

  if (!getIt.isRegistered<DashboardCubit>()) {
    getIt.registerFactory<DashboardCubit>(
      () => DashboardCubit(getDashboardData: getIt<GetDashboardData>()),
    );
  }

  // =============================================================
  // TRANSACTIONS FEATURE
  // =============================================================

  if (!getIt.isRegistered<TransactionsRemoteDataSource>()) {
    getIt.registerLazySingleton<TransactionsRemoteDataSource>(
      () => TransactionsRemoteDataSourceImpl(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<TransactionsRepository>()) {
    getIt.registerLazySingleton<TransactionsRepository>(
      () => TransactionsRepositoryImpl(
        remote: getIt<TransactionsRemoteDataSource>(),
        userIdLocal: getIt<UserIdLocalDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<GetCategories>()) {
    getIt.registerLazySingleton<GetCategories>(
      () => GetCategories(getIt<TransactionsRepository>()),
    );
  }

  if (!getIt.isRegistered<AddTransaction>()) {
    getIt.registerLazySingleton<AddTransaction>(
      () => AddTransaction(getIt<TransactionsRepository>()),
    );
  }

  if (!getIt.isRegistered<AddTransactionCubit>()) {
    getIt.registerFactory<AddTransactionCubit>(
      () => AddTransactionCubit(
        addTransaction: getIt<AddTransaction>(),
        userIdLocal: getIt<UserIdLocalDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<SelectCategoryCubit>()) {
    getIt.registerFactory<SelectCategoryCubit>(
      () => SelectCategoryCubit(getCategories: getIt<GetCategories>()),
    );
  }

  // =============================================================
  // TRANSACTION HISTORY (NEW)
  // =============================================================

  if (!getIt.isRegistered<GetTransactionHistory>()) {
    getIt.registerLazySingleton<GetTransactionHistory>(
      () => GetTransactionHistory(getIt<TransactionsRepository>()),
    );
  }

  if (!getIt.isRegistered<TransactionHistoryCubit>()) {
    getIt.registerFactory<TransactionHistoryCubit>(
      () => TransactionHistoryCubit(
        repo: getIt<TransactionsRepository>(),
        // Nếu bạn muốn cubit dùng usecase thay vì repo:
        // getHistory: getIt<GetTransactionHistory>(),
      ),
    );
  }
}
