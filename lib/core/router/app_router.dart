import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracking_app/core/di/di.dart';
import 'package:finance_tracking_app/feature/users/auth/presentation/cubit/auth_cubit.dart';

import 'package:finance_tracking_app/feature/users/auth/presentation/pages/welcome_screen.dart';
import 'package:finance_tracking_app/feature/users/auth/presentation/pages/login_screen.dart';
import 'package:finance_tracking_app/feature/users/auth/presentation/pages/sign_up_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
}

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const LoginScreen(),
          ),
          settings: settings,
        );

      case AppRoutes.signUp:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const SignUpScreen(),
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
