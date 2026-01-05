import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:finance_tracker_app/core/network/dio_client.dart';

import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';

final getIt = GetIt.instance;

void setupDI({
  required String supabaseUrl,
  required String supabaseAnonKey,
}) {
  // =======================
  // Secure Storage (token)
  // =======================
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  );

  getIt.registerLazySingleton<SessionLocalDataSource>(
    () => SessionLocalDataSourceSecure(storage: getIt<FlutterSecureStorage>()),
  );

  // =======================
  // Dio
  // =======================
  getIt.registerLazySingleton<Dio>(
    () => DioClient(
      baseUrl: supabaseUrl,
      anonKey: supabaseAnonKey,
      tokenProvider: () => getIt<SessionLocalDataSource>().getAccessToken(),
    ).dio,
  );

  // =======================
  // Data Sources
  // =======================
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<Dio>()),
  );

  // =======================
  // Repositories
  // =======================
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: getIt<AuthRemoteDataSource>(),
      sessionLocal: getIt<SessionLocalDataSource>(),
    ),
  );

  // =======================
  // Usecases
  // =======================
  getIt.registerLazySingleton<Login>(
    () => Login(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<Signup>(
    () => Signup(getIt<AuthRepository>()),
  );

  // =======================
  // Cubits
  // =======================
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      login: getIt<Login>(),
      signup: getIt<Signup>(),
    ),
  );
}
