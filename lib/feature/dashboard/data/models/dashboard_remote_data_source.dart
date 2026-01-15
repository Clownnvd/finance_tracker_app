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

  Future<DashboardSummaryModel> fetchSummaryForMonth(DateTime month) async {
    final start = _monthStart(month);

    final res = await _dio.get(
      SupabaseEndpoints.vMonthTotals, // ✅ dùng constant (không table('...') nữa)
      queryParameters: {
        'select': 'type,month,total',
        'month': 'eq.${_dateOnly(start)}',
      },
    );

    return DashboardSummaryModel.fromMonthTotals(res.data as List<dynamic>);
  }

  Future<List<DashboardTransactionModel>> fetchRecentTransactionsForMonth({
    required DateTime month,
    int limit = 20,
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
    );

    final list = (res.data as List).cast<Map<String, dynamic>>();

    // ✅ MUST: fromApi (parse categories(name,icon))
    return list.map(DashboardTransactionModel.fromApi).toList();
  }

  Future<List<DashboardCategoryBreakdownModel>> fetchCategoryBreakdownForMonth({
    required String uid,
    required DateTime month,
    required String type,
  }) async {
    final start = _monthStart(month);
    final end = _monthEnd(month);

    final res = await _dio.post(
      SupabaseEndpoints.rpcCategoryTotals, // ✅ dùng constant
      data: {
        'uid': uid,
        'start_date': _dateOnly(start),
        'end_date': _dateOnly(end),
        'cat_type': type,
      },
    );

    final list = (res.data as List).cast<Map<String, dynamic>>();

    // ✅ RPC trả đúng shape category_id, name, total, percent
    return list.map(DashboardCategoryBreakdownModel.fromApi).toList();
  }
}
