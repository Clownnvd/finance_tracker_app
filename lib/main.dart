import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_size/window_size.dart';

import 'package:finance_tracker_app/core/di/di.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/shared/widgets/error_boundary.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';

const double windowWidth = 500;
const double windowHeight = 854;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded(() async {
    final initResult = await _initApp();

    if (initResult == null) {
      _setupWindow();
      runApp(
        ErrorBoundary(
          reporter: _reportCrash,
          child: const AppRoot(),
        ),
      );
    } else {
      runApp(
        ErrorBoundary(
          reporter: _reportCrash,
          child: ErrorApp(errorMessage: initResult),
        ),
      );
    }
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
  if (v == null || v.isEmpty) {
    throw Exception('Missing $key in .env');
  }
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

void _setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle('Finance Tracker');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));

    getCurrentScreen().then((screen) {
      if (screen == null) return;
      setWindowFrame(
        Rect.fromCenter(
          center: screen.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
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
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(textScaler: const TextScaler.linear(1.0)),
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
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
                  'Please check your .env and Supabase config.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
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
}
