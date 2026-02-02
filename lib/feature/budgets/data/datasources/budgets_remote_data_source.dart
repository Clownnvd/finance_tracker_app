import 'package:dio/dio.dart';

import 'package:finance_tracker_app/core/network/dio_client.dart';
import 'package:finance_tracker_app/core/network/supabase_endpoints.dart';

abstract class BudgetsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getMyBudgets({
    required String uid,
  });

  Future<List<Map<String, dynamic>>> createBudget({
    required String uid,
    required int categoryId,
    required double amount,
    required int month,
  });

  Future<List<Map<String, dynamic>>> updateBudget({
    required int budgetId,
    double? amount,
    int? categoryId,
    int? month,
  });

  Future<List<Map<String, dynamic>>> deleteBudget({
    required int budgetId,
  });
}

class BudgetsRemoteDataSourceImpl implements BudgetsRemoteDataSource {
  final DioClient _client;
  BudgetsRemoteDataSourceImpl(this._client);

  Dio get _dio => _client.dio;

  @override
  Future<List<Map<String, dynamic>>> getMyBudgets({required String uid}) async {
    final res = await _dio.get(
      SupabaseEndpoints.budgets,
      queryParameters: <String, dynamic>{
        'user_id': 'eq.$uid',
        'order': 'month.asc',
      },
    );
    return _asListOfMap(res.data);
  }

  @override
  Future<List<Map<String, dynamic>>> createBudget({
    required String uid,
    required int categoryId,
    required double amount,
    required int month,
  }) async {
    final res = await _dio.post(
      SupabaseEndpoints.budgets,
      options: Options(headers: const {'Prefer': 'return=representation'}),
      data: <String, dynamic>{
        'user_id': uid,
        'category_id': categoryId,
        'amount': amount,
        'month': month,
      },
    );
    return _asListOfMap(res.data);
  }

  @override
  Future<List<Map<String, dynamic>>> updateBudget({
    required int budgetId,
    double? amount,
    int? categoryId,
    int? month,
  }) async {
    final patch = <String, dynamic>{};
    if (amount != null) patch['amount'] = amount;
    if (categoryId != null) patch['category_id'] = categoryId;
    if (month != null) patch['month'] = month;

    final res = await _dio.patch(
      SupabaseEndpoints.budgets,
      queryParameters: <String, dynamic>{
        'id': 'eq.$budgetId',
      },
      options: Options(headers: const {'Prefer': 'return=representation'}),
      data: patch,
    );

    return _asListOfMap(res.data);
  }

  @override
  Future<List<Map<String, dynamic>>> deleteBudget({
    required int budgetId,
  }) async {
    final res = await _dio.delete(
      SupabaseEndpoints.budgets,
      queryParameters: <String, dynamic>{
        'id': 'eq.$budgetId',
      },
      options: Options(headers: const {'Prefer': 'return=representation'}),
    );
    return _asListOfMap(res.data);
  }

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
