/// Centralized Supabase REST endpoints
/// Used by Dio (Auth / PostgREST / RPC / Storage)
///
/// Base URL (example):
///   https://xyzcompany.supabase.co
///
/// Full request example:
///   POST {baseUrl}/auth/v1/token?grant_type=password
///
class SupabaseEndpoints {
  SupabaseEndpoints._();

  // =============================================================
  // AUTH (GoTrue)
  // =============================================================

  /// POST /auth/v1/signup
  static const String authSignUp = '/auth/v1/signup';

  /// POST /auth/v1/token?grant_type=password
  static const String authTokenPassword =
      '/auth/v1/token?grant_type=password';

  /// POST /auth/v1/token?grant_type=refresh_token
  static const String authTokenRefresh =
      '/auth/v1/token?grant_type=refresh_token';

  /// GET /auth/v1/user
  static const String authUser = '/auth/v1/user';

  /// POST /auth/v1/logout
  static const String authLogout = '/auth/v1/logout';

  // =============================================================
  // DATABASE (PostgREST)
  // =============================================================

  /// Base path for PostgREST
  static const String rest = '/rest/v1';

  /// Generic table access
  ///
  /// Example:
  ///   GET  /rest/v1/transactions?select=*
  ///   POST /rest/v1/transactions
  static String table(String tableName) => '$rest/$tableName';

  // -----------------------
  // USERS (profiles)
  // -----------------------

  /// /rest/v1/users
  static const String users = '$rest/users';

  // -----------------------
  // CATEGORIES (public read)
  // -----------------------

  /// /rest/v1/categories
  static const String categories = '$rest/categories';

  // -----------------------
  // TRANSACTIONS
  // -----------------------

  /// /rest/v1/transactions
  static const String transactions = '$rest/transactions';

  // -----------------------
  // BUDGETS
  // -----------------------

  /// /rest/v1/budgets
  static const String budgets = '$rest/budgets';

  // -----------------------
  // SETTINGS
  // -----------------------

  /// /rest/v1/settings
  static const String settings = '$rest/settings';

  // =============================================================
  // VIEWS
  // =============================================================

  /// Monthly totals view
  ///
  /// Columns:
  /// - user_id
  /// - type (INCOME | EXPENSE)
  /// - month (date)
  /// - total
  ///
  /// Example:
  ///   GET /rest/v1/v_month_totals
  static const String vMonthTotals = '$rest/v_month_totals';

  // =============================================================
  // RPC (Postgres Functions)
  // =============================================================

  /// Category breakdown totals
  ///
  /// POST /rest/v1/rpc/category_totals
  ///
  /// Body:
  /// {
  ///   "uid": "<uuid>",
  ///   "start_date": "2026-01-01",
  ///   "end_date": "2026-01-31",
  ///   "cat_type": "EXPENSE"
  /// }
  static const String rpcCategoryTotals =
      '$rest/rpc/category_totals';

  // =============================================================
  // STORAGE
  // =============================================================

  /// Base path for Storage API
  static const String storage = '/storage/v1';

  /// List objects in bucket
  ///
  /// GET /storage/v1/object/list/{bucket}
  static String storageList(String bucket) =>
      '$storage/object/list/$bucket';

  /// Upload object
  ///
  /// POST /storage/v1/object/{bucket}/{path}
  static String storageUpload(String bucket, String path) =>
      '$storage/object/$bucket/$path';

  /// Download public object
  ///
  /// GET /storage/v1/object/public/{bucket}/{path}
  static String storagePublic(String bucket, String path) =>
      '$storage/object/public/$bucket/$path';

  /// Download private object (requires Authorization header)
  ///
  /// GET /storage/v1/object/{bucket}/{path}
  static String storagePrivate(String bucket, String path) =>
      '$storage/object/$bucket/$path';
}
