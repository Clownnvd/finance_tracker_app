import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:finance_tracker_app/core/network/dio_client.dart';
import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:finance_tracker_app/core/network/token_refresher.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';

// =============================================================
// AUTH
// =============================================================
import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/logout.dart';
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

// =============================================================
// REPORTS / MONTHLY REPORT
// =============================================================

// Data
import 'package:finance_tracker_app/feature/monthly_report/data/models/report_remote_data_source.dart';
import 'package:finance_tracker_app/feature/monthly_report/data/repositories/monthly_report_repository_impl.dart';

// Domain
import 'package:finance_tracker_app/feature/monthly_report/domain/repositories/report_repository.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/usecases/get_category_breakdown.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/usecases/get_monthly_summary.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/usecases/get_monthly_trend.dart';

// Presentation
import 'package:finance_tracker_app/feature/monthly_report/presentation/cubit/monthly_report_cubit.dart';

// =============================================================
// BUDGETS
// =============================================================

// Data
import 'package:finance_tracker_app/feature/budgets/data/datasources/budgets_remote_data_source.dart';
import 'package:finance_tracker_app/feature/budgets/data/repositories/budgets_repository_impl.dart';

// Domain
import 'package:finance_tracker_app/feature/budgets/domain/repositories/budgets_repository.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/get_budgets.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/create_budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/update_budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/delete_budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/has_any_budget.dart';

// Presentation
import 'package:finance_tracker_app/feature/budgets/presentation/cubit/budgets_cubit.dart';

// =============================================================
// SETTINGS
// =============================================================

// Data
import 'package:finance_tracker_app/feature/settings/data/datasources/settings_remote_data_source.dart';
import 'package:finance_tracker_app/feature/settings/data/repositories/settings_repository_impl.dart';

// Domain
import 'package:finance_tracker_app/feature/settings/domain/repositories/settings_repository.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/get_my_settings.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/upsert_settings.dart';

// (settings đang dùng GetAllBudgets để check hasAnyBudget)
import 'package:finance_tracker_app/feature/settings/domain/usecases/get_all_budgets.dart';

// Presentation
import 'package:finance_tracker_app/feature/settings/presentation/cubit/settings_cubit.dart';

final getIt = GetIt.instance;

/// Initializes dependency injection for the entire app.
///
/// Safe to call multiple times (e.g., hot restart),
/// because each dependency is registered only once.
void setupDI({
  required String supabaseUrl,
  required String supabaseAnonKey,
}) {
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

  // TokenRefresher uses lazy injection internally to avoid circular deps:
  // TokenRefresher -> AuthRepository -> DioClient -> TokenRefresher
  if (!getIt.isRegistered<TokenRefresher>()) {
    getIt.registerLazySingleton<TokenRefresher>(() => TokenRefresher());
  }

  if (!getIt.isRegistered<DioClient>()) {
    getIt.registerLazySingleton<DioClient>(
      () => DioClient(
        baseUrl: supabaseUrl,
        anonKey: supabaseAnonKey,
        tokenProvider: () => getIt<SessionLocalDataSource>().getAccessToken(),
        tokenRefresher: getIt<TokenRefresher>(),
      ),
    );
  }

  // Expose raw Dio only if some legacy code needs it.
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

  if (!getIt.isRegistered<Logout>()) {
    getIt.registerLazySingleton<Logout>(() => Logout(getIt<AuthRepository>()));
  }

  if (!getIt.isRegistered<AuthCubit>()) {
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(
        login: getIt<Login>(),
        signup: getIt<Signup>(),
        logout: getIt<Logout>(),
      ),
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
  // TRANSACTION HISTORY
  // =============================================================

  if (!getIt.isRegistered<GetTransactionHistory>()) {
    getIt.registerLazySingleton<GetTransactionHistory>(
      () => GetTransactionHistory(getIt<TransactionsRepository>()),
    );
  }

  if (!getIt.isRegistered<TransactionHistoryCubit>()) {
    getIt.registerFactory<TransactionHistoryCubit>(
      () => TransactionHistoryCubit(repo: getIt<TransactionsRepository>()),
    );
  }

  // =============================================================
  // REPORTS / MONTHLY REPORT
  // =============================================================

  if (!getIt.isRegistered<MonthlyReportRemoteDataSource>()) {
    getIt.registerLazySingleton<MonthlyReportRemoteDataSource>(
      () => MonthlyReportRemoteDataSourceImpl(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<MonthlyReportRepository>()) {
    getIt.registerLazySingleton<MonthlyReportRepository>(
      () => MonthlyReportRepositoryImpl(
        remote: getIt<MonthlyReportRemoteDataSource>(),
        userIdLocal: getIt<UserIdLocalDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<GetMonthlyTrend>()) {
    getIt.registerLazySingleton<GetMonthlyTrend>(
      () => GetMonthlyTrend(getIt<MonthlyReportRepository>()),
    );
  }

  if (!getIt.isRegistered<GetMonthlySummary>()) {
    getIt.registerLazySingleton<GetMonthlySummary>(
      () => GetMonthlySummary(getIt<MonthlyReportRepository>()),
    );
  }

  if (!getIt.isRegistered<GetCategoryBreakdown>()) {
    getIt.registerLazySingleton<GetCategoryBreakdown>(
      () => GetCategoryBreakdown(getIt<MonthlyReportRepository>()),
    );
  }

  if (!getIt.isRegistered<MonthlyReportCubit>()) {
    getIt.registerFactory<MonthlyReportCubit>(
      () => MonthlyReportCubit(
        getMonthlyTrend: getIt<GetMonthlyTrend>(),
        getMonthlySummary: getIt<GetMonthlySummary>(),
        getCategoryBreakdown: getIt<GetCategoryBreakdown>(),
      ),
    );
  }

  // =============================================================
  // BUDGETS FEATURE
  // =============================================================

  if (!getIt.isRegistered<BudgetsRemoteDataSource>()) {
    getIt.registerLazySingleton<BudgetsRemoteDataSource>(
      () => BudgetsRemoteDataSourceImpl(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<BudgetsRepository>()) {
    getIt.registerLazySingleton<BudgetsRepository>(
      () => BudgetsRepositoryImpl(
        remote: getIt<BudgetsRemoteDataSource>(),
        userIdLocal: getIt<UserIdLocalDataSource>(),
      ),
    );
  }

  // Usecases
  if (!getIt.isRegistered<GetBudgets>()) {
    getIt.registerLazySingleton<GetBudgets>(
      () => GetBudgets(getIt<BudgetsRepository>()),
    );
  }

  if (!getIt.isRegistered<CreateBudget>()) {
    getIt.registerLazySingleton<CreateBudget>(
      () => CreateBudget(getIt<BudgetsRepository>()),
    );
  }

  if (!getIt.isRegistered<UpdateBudget>()) {
    getIt.registerLazySingleton<UpdateBudget>(
      () => UpdateBudget(getIt<BudgetsRepository>()),
    );
  }

  if (!getIt.isRegistered<DeleteBudget>()) {
    getIt.registerLazySingleton<DeleteBudget>(
      () => DeleteBudget(getIt<BudgetsRepository>()),
    );
  }

  if (!getIt.isRegistered<HasAnyBudget>()) {
    getIt.registerLazySingleton<HasAnyBudget>(
      () => HasAnyBudget(getIt<BudgetsRepository>()),
    );
  }

  // Cubit
  if (!getIt.isRegistered<BudgetsCubit>()) {
    getIt.registerFactory<BudgetsCubit>(
      () => BudgetsCubit(
        getBudgets: getIt<GetBudgets>(),
        createBudget: getIt<CreateBudget>(),
        updateBudget: getIt<UpdateBudget>(),
        deleteBudget: getIt<DeleteBudget>(),
      ),
    );
  }

  // =============================================================
  // SETTINGS FEATURE
  // =============================================================

  if (!getIt.isRegistered<SettingsRemoteDataSource>()) {
    getIt.registerLazySingleton<SettingsRemoteDataSource>(
      () => SettingsRemoteDataSourceImpl(getIt<DioClient>()),
    );
  }

  if (!getIt.isRegistered<SettingsRepository>()) {
    getIt.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(
        remote: getIt<SettingsRemoteDataSource>(),
        userIdLocal: getIt<UserIdLocalDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<GetMySettings>()) {
    getIt.registerLazySingleton<GetMySettings>(
      () => GetMySettings(getIt<SettingsRepository>()),
    );
  }

  if (!getIt.isRegistered<UpsertSettings>()) {
    getIt.registerLazySingleton<UpsertSettings>(
      () => UpsertSettings(getIt<SettingsRepository>()),
    );
  }

  // Settings đang cần "GetAllBudgets" để lấy list budgets check hasAnyBudget
  if (!getIt.isRegistered<GetAllBudgets>()) {
    getIt.registerLazySingleton<GetAllBudgets>(
      () => GetAllBudgets(getIt<BudgetsRepository>()),
    );
  }

  if (!getIt.isRegistered<SettingsCubit>()) {
    getIt.registerFactory<SettingsCubit>(
      () => SettingsCubit(
        getMySettings: getIt<GetMySettings>(),
        upsertSettings: getIt<UpsertSettings>(),
        getAllBudgets: getIt<GetAllBudgets>(),
      ),
    );
  }
}
