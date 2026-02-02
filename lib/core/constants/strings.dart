// lib/core/constants/app_strings.dart

class AppStrings {
  AppStrings._();

  static const appName = 'Personal Finance Tracker';

  // Welcome
  static const welcome = 'Welcome';
  static const welcomeTitle = 'Welcome to Personal\nFinance Tracker';
  static const welcomeSubtitle = 'Take control of your finances with us.';
  static const getStarted = 'Get Started';

  // Auth
  static const login = 'Login';
  static const register = 'Register';
  static const signUpTitle = 'Sign Up';

  static const signUpSuccess = 'Sign up successful';
  static const signUpSuccessVerifyEmail =
      'Sign up successful. Please verify your email before logging in.';

  static const alreadyHaveAccount = 'Already have an account?';
  static const dontHaveAccount = "Don't have an account?";

  static const fullNameLabel = 'Full Name';
  static const emailLabel = 'Email';
  static const passwordLabel = 'Password';
  static const confirmPasswordLabel = 'Confirm password';

  // Validation - Full name
  static const fullNameRequired = 'Please enter your full name';
  static const fullNameMinLength2 = 'Full name must be at least 2 characters';
  static const fullNameInvalidChars =
      'Full name can only contain letters and spaces';

  // Validation - Email
  static const emailRequired = 'Please enter your email';
  static const invalidEmailFormat = 'Email format is invalid';

  // Validation - Password
  static const passwordRequired = 'Please enter your password';
  static const passwordMinLength8 = 'Password must be at least 8 characters';
  static const passwordNeedUppercase =
      'Password must contain an uppercase letter';
  static const passwordNeedLowercase =
      'Password must contain a lowercase letter';
  static const passwordNeedNumber = 'Password must contain a number';
  static const passwordNeedSpecialChar =
      'Password must contain a special character';

  // Validation - Confirm password
  static const confirmPasswordRequired = 'Please confirm your password';
  static const passwordNotMatch = 'Password does not match';

  // Errors
  static const loginFailed = 'Login failed';
  static const signupFailed = 'Signup failed';
  static const genericError = 'Something went wrong';
  static const sessionExpired = 'Session expired. Please login again.';

  // Dashboard
  static const dashboardTitle = 'Dashboard';
  static const recentTransactions = 'Recent Transactions';
  static const noTransactionsYet = 'No transactions yet.';

  static const income = 'INCOME';
  static const expenses = 'EXPENSES';
  static const balance = 'BALANCE';

  // Bottom nav
  static const navHome = 'Home';
  static const navAdd = 'Add';
  static const navHistory = 'History';
  static const navReport = 'Report';
  static const navSettings = 'Settings';

  // Add transaction
  static const addTransactionTitle = 'Add transaction';
  static const save = 'Save';
  static const transactionAdded = 'Transaction added';

  // Select category
  static const selectCategoryTitle = 'Select category';
  static const expenseUpper = 'EXPENSE';
  static const incomeUpper = 'INCOME';

  // Transaction history
  static const transactionHistoryTitle = 'Transaction History';
  static const reloadCategoriesTooltip = 'Reload categories';
  static const categoryLoadFailedPrefix = 'Category load failed: ';
}
