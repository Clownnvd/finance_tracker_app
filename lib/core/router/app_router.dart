import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

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

// =======================
// REPORTS
// =======================
import 'package:finance_tracker_app/feature/monthly_report/presentation/pages/monthly_report_page.dart';

// =======================
// SETTINGS
// =======================
import 'package:finance_tracker_app/feature/settings/presentation/pages/settings_screen.dart';
import 'package:finance_tracker_app/feature/settings/presentation/pages/account_security_screen.dart';

// =======================
// BUDGETS
// =======================
import 'package:finance_tracker_app/feature/budgets/presentation/pages/set_budget_screen.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/cubit/budgets_cubit.dart';

/// Centralized route names for the application.
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

  // =======================
  // REPORTS
  // =======================
  static const String monthlyReport = '/reports/monthly';

  // =======================
  // SETTINGS
  // =======================
  static const String settings = '/settings';
  static const String accountSecurity = '/settings/account-security';

  // =======================
  // BUDGETS
  // =======================
  static const String setBudget = '/budgets/set';
}

/// Centralized app router.
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
      // REPORTS
      // =======================
      case AppRoutes.monthlyReport:
        return _material(const MonthlyReportPage(), settings);

      // =======================
      // SETTINGS
      // =======================
      case AppRoutes.settings:
        return _material(const SettingsScreen(), settings);

      case AppRoutes.accountSecurity:
        return _material(const AccountSecurityScreen(), settings);

      // =======================
      // BUDGETS
      // =======================
      case AppRoutes.setBudget:
        return _material(
          BlocProvider<BudgetsCubit>(
            create: (_) => GetIt.I<BudgetsCubit>(),
            child: const SetBudgetScreen(),
          ),
          settings,
        );

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
