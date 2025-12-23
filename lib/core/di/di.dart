import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../network/session_local_data_source.dart';
import '../network/session_local_data_source_prefs.dart';

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
  // Session storage (SharedPreferences for ALL platforms)
  // =======================
  getIt.registerLazySingleton<SessionLocalDataSource>(
    () => SessionLocalDataSourcePrefs(),
  );

  // =======================
  // Dio
  // =======================
  getIt.registerLazySingleton<Dio>(() {
    final client = DioClient(
      baseUrl: supabaseUrl,
      anonKey: supabaseAnonKey,
      tokenProvider: () => getIt<SessionLocalDataSource>().getAccessToken(),
    );
    print('Dio registered: ${getIt.isRegistered<Dio>()}');

    return client.dio;
  });

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
  getIt.registerLazySingleton<Login>(() => Login(getIt<AuthRepository>()));
  getIt.registerLazySingleton<Signup>(() => Signup(getIt<AuthRepository>()));

  // =======================
  // Cubits
  // =======================
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(login: getIt<Login>(), signup: getIt<Signup>()),
  );
}
