// lib/feature/dashboard/data/models/dashboard_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/network/dio_client.dart';
import 'package:finance_tracker_app/core/network/supabase_endpoints.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_models.dart';

class DashboardRemoteDataSource {
  final DioClient _client;

  DashboardRemoteDataSource(this._client);

  Dio get _dio => _client.dio;

  static String _dateOnly(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  DateTime _monthStart(DateTime d) => DateTime(d.year, d.month, 1);
  DateTime _monthEnd(DateTime d) => DateTime(d.year, d.month + 1, 0);

  Future<DashboardSummaryModel> fetchSummaryForMonth(
    DateTime month, {
    CancelToken? cancelToken,
  }) async {
    final start = _monthStart(month);

    final res = await _dio.get(
      SupabaseEndpoints.vMonthTotals,
      queryParameters: {
        'select': 'type,month,total',
        'month': 'eq.${_dateOnly(start)}',
      },
      cancelToken: cancelToken,
    );

    return DashboardSummaryModel.fromMonthTotals(res.data as List<dynamic>);
  }

  Future<List<DashboardTransactionModel>> fetchRecentTransactionsForMonth({
    required DateTime month,
    int limit = 20,
    CancelToken? cancelToken,
  }) async {
    final start = _monthStart(month);
    final end = _monthEnd(month);

    final res = await _dio.get(
      SupabaseEndpoints.transactions,
      queryParameters: {
        'select': 'id,type,amount,note,date,category_id,categories(name,icon)',
        'date': 'gte.${_dateOnly(start)}',
        'and': '(date.lte.${_dateOnly(end)})',
        'order': 'date.desc',
        'limit': limit,
      },
      cancelToken: cancelToken,
    );

    final list = (res.data as List).cast<Map<String, dynamic>>();

    return list.map(DashboardTransactionModel.fromApi).toList();
  }

  Future<List<DashboardCategoryBreakdownModel>> fetchCategoryBreakdownForMonth({
    required String uid,
    required DateTime month,
    required String type,
    CancelToken? cancelToken,
  }) async {
    final start = _monthStart(month);
    final end = _monthEnd(month);

    final res = await _dio.post(
      SupabaseEndpoints.rpcCategoryTotals,
      data: {
        'uid': uid,
        'start_date': _dateOnly(start),
        'end_date': _dateOnly(end),
        'cat_type': type,
      },
      cancelToken: cancelToken,
    );

    final list = (res.data as List).cast<Map<String, dynamic>>();

    return list.map(DashboardCategoryBreakdownModel.fromApi).toList();
  }
}
