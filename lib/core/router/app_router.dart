// lib/core/router/app_router.dart

import 'package:flutter/material.dart';

import 'package:finance_tracking_app/feature/users/presentation/pages/welcome_screen.dart';
import 'package:finance_tracking_app/feature/users/presentation/pages/login_screen.dart';
import 'package:finance_tracking_app/feature/users/presentation/pages/sign_up_screen.dart';

/// Định nghĩa tên route dùng chung trong app
class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
}

/// Router trung tâm cho toàn bộ app
class AppRouter {
  // Nếu muốn dùng điều hướng bằng navigatorKey (không cần context)
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// onGenerateRoute cho MaterialApp
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case AppRoutes.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );

      // fallback: nếu route không khớp, trả về màn hình đơn giản
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
