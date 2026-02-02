import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/network/dio_client.dart';
import 'package:finance_tracker_app/core/network/supabase_endpoints.dart';

/// Remote data source for Monthly Report feature.
///
/// Responsibilities:
/// - Call Supabase REST / View / RPC endpoints
/// - Return raw JSON data (List<Map<String, dynamic>>)
/// - NO domain logic
/// - NO DTO / entity mapping
///
/// Mapping flow:
/// Raw JSON -> DTO (in repository) -> Domain entity (via mapper)
abstract class MonthlyReportRemoteDataSource {
  /// Fetch totals per month for a given year (from v_month_totals view).
  ///
  /// GET /rest/v1/v_month_totals
  Future<List<Map<String, dynamic>>> fetchMonthTotals({
    required String type, // INCOME | EXPENSE
    required int year,
  });

  /// Fetch total for a specific month & type.
  ///
  /// GET /rest/v1/v_month_totals?month=eq.<YYYY-MM-01>&type=eq.INCOME
  Future<List<Map<String, dynamic>>> fetchMonthTotalsViewFiltered({
    required String uid,
    required String monthStartIso,
    required String type,
  });

  /// Fetch category breakdown (RPC).
  ///
  /// POST /rest/v1/rpc/category_totals
  Future<List<Map<String, dynamic>>> fetchCategoryTotals({
    required String uid,
    required String startDateIso,
    required String endDateIso,
    required String catType,
  });

  /// Fetch top expense transactions for a month.
  ///
  /// GET /rest/v1/transactions?...&limit=<n>
  Future<List<Map<String, dynamic>>> fetchTopExpenses({
    required String uid,
    required String startDateIso,
    required String endDateIso,
    int limit,
  });
}

/// Supabase implementation of [MonthlyReportRemoteDataSource].
class MonthlyReportRemoteDataSourceImpl
    implements MonthlyReportRemoteDataSource {
  final DioClient _client;

  MonthlyReportRemoteDataSourceImpl(this._client);

  Dio get _dio => _client.dio;

  @override
  Future<List<Map<String, dynamic>>> fetchMonthTotals({
    required String type,
    required int year,
  }) async {
    final start = '$year-01-01';
    final end = '$year-12-31';

    final res = await _dio.get(
      SupabaseEndpoints.vMonthTotals,
      queryParameters: <String, dynamic>{
        'type': 'eq.$type',
        'month': 'gte.$start',
        // second condition via AND (PostgREST-compatible)
        'and': '(month.lte.$end)',
      },
    );

    return _asListOfMap(res.data);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMonthTotalsViewFiltered({
    required String uid,
    required String monthStartIso,
    required String type,
  }) async {
    final res = await _dio.get(
      SupabaseEndpoints.vMonthTotals,
      queryParameters: <String, dynamic>{
        'month': 'eq.$monthStartIso',
        'type': 'eq.$type',
        // user_id is already enforced by RLS, kept for clarity/future use
        // 'user_id': 'eq.$uid',
      },
    );

    return _asListOfMap(res.data);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCategoryTotals({
    required String uid,
    required String startDateIso,
    required String endDateIso,
    required String catType,
  }) async {
    final res = await _dio.post(
      SupabaseEndpoints.rpcCategoryTotals,
      data: <String, dynamic>{
        'uid': uid,
        'start_date': startDateIso,
        'end_date': endDateIso,
        'cat_type': catType,
      },
    );

    return _asListOfMap(res.data);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTopExpenses({
    required String uid,
    required String startDateIso,
    required String endDateIso,
    int limit = 3,
  }) async {
    final res = await _dio.get(
      SupabaseEndpoints.transactions,
      queryParameters: <String, dynamic>{
        'user_id': 'eq.$uid',
        'date': 'gte.$startDateIso',
        'and': '(date.lte.$endDateIso)',
        'select':
            'id,amount,type,date,note,category_id,categories(name,icon)',
        'order': 'amount.desc',
        'limit': limit.toString(),
        'type': 'eq.EXPENSE',
      },
    );

    return _asListOfMap(res.data);
  }

  // =========================
  // Helpers
  // =========================

  List<Map<String, dynamic>> _asListOfMap(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }
}
