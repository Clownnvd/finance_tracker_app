import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode, PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:finance_tracker_app/core/di/di.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/shared/widgets/error_boundary.dart';

import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) async {
    FlutterError.presentError(details);
    await _reportCrash(details.exception, details.stack ?? StackTrace.current, details: details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    _reportCrash(error, stack);
    return true;
  };

  await runZonedGuarded(() async {
    final initError = await _initApp();

    runApp(
      ErrorBoundary(
        reporter: _reportCrash,
        child: initError == null
            ? const AppRoot()
            : ErrorApp(errorMessage: initError),
      ),
    );
  }, (error, stack) async {
    await _reportCrash(error, stack);
  });
}

Future<String?> _initApp() async {
  try {
    await dotenv.load(fileName: '.env');

    final supabaseUrl = _requireEnv('SUPABASE_URL');
    final supabaseAnonKey = _requireEnv('SUPABASE_ANON_KEY');

    _validateSupabaseUrl(supabaseUrl);
    _validateAnonKey(supabaseAnonKey);

    setupDI(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
    );

    return null;
  } catch (e, st) {
    debugPrintStack(stackTrace: st);
    return e.toString();
  }
}

String _requireEnv(String key) {
  final v = dotenv.env[key]?.trim();
  if (v == null || v.isEmpty) throw Exception('Missing $key in .env');
  return v;
}

void _validateSupabaseUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.isAbsolute || uri.scheme != 'https') {
    throw Exception('Invalid SUPABASE_URL');
  }
}

void _validateAnonKey(String anonKey) {
  final parts = anonKey.split('.');
  final looksLikeJwt = parts.length == 3 && anonKey.startsWith('eyJ');
  if (!looksLikeJwt && anonKey.length < 40) {
    throw Exception('Invalid SUPABASE_ANON_KEY');
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
        BlocProvider<DashboardCubit>(create: (_) => getIt<DashboardCubit>()),
        BlocProvider<SelectCategoryCubit>(create: (_) => getIt<SelectCategoryCubit>()),
        BlocProvider<AddTransactionCubit>(create: (_) => getIt<AddTransactionCubit>()),
        BlocProvider<TransactionHistoryCubit>(create: (_) => getIt<TransactionHistoryCubit>()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Make UI resilient across devices:
      // - keeps user's text scale but prevents extreme values from breaking layout.
      builder: (context, child) {
        final mq = MediaQuery.of(context);

        // Flutter 3.16+ uses TextScaler
        final scaler = mq.textScaler;
        final clamped = TextScaler.linear(
          scaler.scale(1.0).clamp(0.9, 1.2),
        );

        return MediaQuery(
          data: mq.copyWith(textScaler: clamped),
          child: child ?? const SizedBox.shrink(),
        );
      },

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,

      navigatorKey: AppRouter.navigatorKey,
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String errorMessage;

  const ErrorApp({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 64),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'App initialization failed',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      kReleaseMode
                          ? 'Please check your .env and Supabase config.'
                          : 'Fix the error above and restart.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (!kReleaseMode && kIsWeb) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '(Web) If .env is not loading, ensure you added it correctly for web builds.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _reportCrash(
  Object error,
  StackTrace stack, {
  FlutterErrorDetails? details,
}) async {
  debugPrint('💥 Unhandled error: $error');
  debugPrintStack(stackTrace: stack);
  // TODO: integrate Crashlytics/Sentry here for production.
}
