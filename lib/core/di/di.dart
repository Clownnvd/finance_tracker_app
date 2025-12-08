import 'package:finance_tracking_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracking_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finance_tracking_app/feature/users/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_tracking_app/feature/users/auth/domain/repositories/auth_repository.dart';
import 'package:finance_tracking_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracking_app/feature/users/auth/presentation/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

void setupDI() {
  // ===== External =====
  getIt.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );

  // ===== Data sources =====
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: getIt<SupabaseClient>()),
  );

  // ===== Repositories =====
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  // ===== Usecases =====
  getIt.registerLazySingleton<Login>(
    () => Login(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<Signup>(
    () => Signup(getIt<AuthRepository>()),
  );

  // ===== Cubit =====
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      login: getIt<Login>(),
      signup: getIt<Signup>(),
    ),
  );
}
