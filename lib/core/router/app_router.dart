import 'package:flutter/material.dart';

// =======================
// AUTH SCREENS
// =======================
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/login_screen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/sign_up_screen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/welcome_screen.dart';

// =======================
// DASHBOARD
// =======================
import 'package:finance_tracker_app/feature/dashboard/presentation/pages/dashboard_screen.dart';

// =======================
// TRANSACTIONS
// =======================
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/pages/add_transaction_screen.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/pages/select_category_screen.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/pages/transaction_history_screen.dart';

/// Centralized route names for the application.
///
/// IMPORTANT:
/// - Always add new routes here
/// - Use these constants instead of hard-coded strings
class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String dashboard = '/dashboard';

  // =======================
  // TRANSACTIONS
  // =======================
  static const String transactionHistory = '/transactions/history';
  static const String addTransaction = '/transactions/add';
  static const String selectCategory = '/transactions/select-category';
}

/// Centralized app router.
///
/// Responsibilities:
/// - Map route name → screen
/// - Do NOT create Bloc/Cubit here
/// - Do NOT put business logic here
/// - Keep navigation predictable and safe
class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // =======================
      // AUTH
      // =======================
      case AppRoutes.welcome:
        return _material(const WelcomeScreen(), settings);

      case AppRoutes.login:
        return _material(const LoginScreen(), settings);

      case AppRoutes.signUp:
        return _material(const SignUpScreen(), settings);

      // =======================
      // DASHBOARD
      // =======================
      case AppRoutes.dashboard:
        return _material(const DashboardScreen(), settings);

      // =======================
      // TRANSACTIONS
      // =======================
      case AppRoutes.transactionHistory:
        return _material(const TransactionHistoryScreen(), settings);

      case AppRoutes.addTransaction:
        return _material(const AddTransactionScreen(), settings);

      case AppRoutes.selectCategory:
        return _material(const SelectCategoryScreen(), settings);

      // =======================
      // FALLBACK
      // =======================
      default:
        return _unknownRoute(settings);
    }
  }

  static MaterialPageRoute _material(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }

  static Route<dynamic> _unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => Scaffold(
        body: Center(
          child: Text(
            'Route not found:\n${settings.name}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
