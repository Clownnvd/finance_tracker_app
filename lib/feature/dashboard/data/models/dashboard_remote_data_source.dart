import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/error/exception_mapper.dart';

abstract class DashboardRemoteDataSource {
  Future<List<dynamic>> fetchMonthTotals(DateTime month);
  Future<List<Map<String, dynamic>>> fetchRecentTransactions();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<List<dynamic>> fetchMonthTotals(DateTime month) async {
    try {
      final monthStart =
          DateTime(month.year, month.month, 1).toIso8601String().split('T').first;

      final res = await dio.get(
        '/rest/v1/v_month_totals',
        queryParameters: {
          'month': 'eq.$monthStart',
          'select': 'type,total',
        },
      );

      return List<dynamic>.from(res.data);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchRecentTransactions() async {
    try {
      final res = await dio.get(
        '/rest/v1/transactions',
        queryParameters: {
          'select': 'amount,type,date,categories(name,icon)',
          'order': 'date.desc',
          'limit': '5',
        },
      );

      return List<Map<String, dynamic>>.from(res.data);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
