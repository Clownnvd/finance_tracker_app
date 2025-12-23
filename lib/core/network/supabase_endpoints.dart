/// Centralized Supabase REST endpoints
/// Used by Dio (Auth / PostgREST / Storage)
///
/// Base URL (example):
///   https://xyzcompany.supabase.co
///
/// Full request example:
///   POST {baseUrl}/auth/v1/token?grant_type=password
///
class SupabaseEndpoints {
  SupabaseEndpoints._();

  // =======================
  // Auth (GoTrue)
  // =======================

  /// POST /auth/v1/signup
  static const String authSignUp = '/auth/v1/signup';

  /// POST /auth/v1/token?grant_type=password
  static const String authToken = '/auth/v1/token';

  /// GET /auth/v1/user
  static const String authUser = '/auth/v1/user';

  /// POST /auth/v1/logout
  /// (Optional — usually not required for mobile apps)
  static const String authLogout = '/auth/v1/logout';

  // =======================
  // Database (PostgREST)
  // =======================

  /// Base path for PostgREST
  static const String rest = '/rest/v1';

  /// Example usage:
  ///   GET /rest/v1/profiles?select=*
  ///   POST /rest/v1/profiles
  static String table(String tableName) => '$rest/$tableName';

  // =======================
  // Storage
  // =======================

  /// Base path for Storage API
  static const String storage = '/storage/v1';

  /// List objects in bucket
  /// GET /storage/v1/object/list/{bucket}
  static String storageList(String bucket) =>
      '$storage/object/list/$bucket';

  /// Upload object
  /// POST /storage/v1/object/{bucket}/{path}
  static String storageUpload(String bucket, String path) =>
      '$storage/object/$bucket/$path';

  /// Download object (public or authorized)
  /// GET /storage/v1/object/public/{bucket}/{path}
  static String storagePublic(String bucket, String path) =>
      '$storage/object/public/$bucket/$path';
}
