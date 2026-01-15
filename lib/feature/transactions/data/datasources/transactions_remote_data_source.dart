import 'package:dio/dio.dart';

import 'package:finance_tracker_app/core/error/dio_exception_mapper.dart';
import 'package:finance_tracker_app/core/network/dio_client.dart';
import 'package:finance_tracker_app/core/network/supabase_endpoints.dart';

import '../models/category_model.dart';
import '../models/transaction_model.dart';

abstract class TransactionsRemoteDataSource {
  Future<List<CategoryModel>> getCategories({CancelToken? cancelToken});

  Future<void> addTransaction(
    TransactionModel tx, {
    CancelToken? cancelToken,
  });

  /// Fetches transaction history for a user.
  ///
  /// - Uses PostgREST filters.
  /// - Supports optional date range + pagination.
  /// - Orders newest first.
  Future<List<TransactionModel>> getTransactionHistory({
    required String userId,
    DateTime? from,
    DateTime? to,
    int limit = 50,
    int offset = 0,
    CancelToken? cancelToken,
  });
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final DioClient _client;

  TransactionsRemoteDataSourceImpl(this._client);

  Dio get _dio => _client.dio;

  @override
  Future<List<CategoryModel>> getCategories({CancelToken? cancelToken}) async {
    try {
      final res = await _dio.get(
        SupabaseEndpoints.categories,
        queryParameters: const {
          'select': 'id,name,type,icon',
          'order': 'type.asc,name.asc',
        },
        cancelToken: cancelToken,
      );

      final data = res.data;

      if (data is! List) {
        throw const FormatException(
          'Invalid categories response (expected List).',
        );
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromApi)
          .toList(growable: false);
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }

  @override
  Future<void> addTransaction(
    TransactionModel tx, {
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.post(
        SupabaseEndpoints.transactions,
        data: tx.toInsertJson(),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionHistory({
    required String userId,
    DateTime? from,
    DateTime? to,
    int limit = 50,
    int offset = 0,
    CancelToken? cancelToken,
  }) async {
    try {
      final params = <String, dynamic>{
        // Select only what you need (keep it explicit)
        'select': 'id,user_id,category_id,type,amount,note,date',

        // Must filter by current user (RLS should also protect this)
        'user_id': 'eq.$userId',

        // Pagination (PostgREST)
        'limit': limit,
        'offset': offset,

        // Newest first
        'order': 'date.desc,id.desc',
      };

      if (from != null) {
        params['date'] = 'gte.${_dateOnly(from)}';
      }
      if (to != null) {
        // If both from & to exist, PostgREST needs AND via multiple params:
        // date=gte... & date=lte...
        // So when from exists, keep date=gte... and add date=lte... using `and`.
        //
        // Simplest: use PostgREST `and` only when both are present.
        if (from != null) {
          params.remove('date');
          params['and'] =
              '(date.gte.${_dateOnly(from)},date.lte.${_dateOnly(to)})';
        } else {
          params['date'] = 'lte.${_dateOnly(to)}';
        }
      }

      final res = await _dio.get(
        SupabaseEndpoints.transactions,
        queryParameters: params,
        cancelToken: cancelToken,
      );

      final data = res.data;

      if (data is! List) {
        throw const FormatException(
          'Invalid transaction history response (expected List).',
        );
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(TransactionModel.fromApi)
          .toList(growable: false);
    } on DioException catch (e) {
      throw DioExceptionMapper.map(e);
    }
  }
}

String _dateOnly(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}
