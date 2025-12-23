import 'package:finance_tracker_app/feature/users/auth/presentation/pages/dashboard_screen.dart';
import 'package:flutter/material.dart';

import 'package:finance_tracker_app/feature/users/auth/presentation/pages/welcome_screen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/login_screen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/sign_up_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';

  // ✅ New
  static const String dashboard = '/dashboard';
}

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return _material(const WelcomeScreen(), settings);

      case AppRoutes.login:
        return _material(const LoginScreen(), settings);

      case AppRoutes.signUp:
        return _material(const SignUpScreen(), settings);

      // ✅ New
      case AppRoutes.dashboard:
        return _material(const DashboardScreen(), settings);

      default:
        return _unknownRoute(settings);
    }
  }

  static MaterialPageRoute _material(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }

  static Route<dynamic> _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route not found')),
      ),
    );
  }
}
