import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/repositories/transactions_repository.dart';

import '../datasources/transactions_remote_data_source.dart';
import '../models/category_model.dart'; // brings CategoryModelX.toEntity()
import '../models/transaction_model.dart'; // brings TransactionModelX.fromEntity + toEntity

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDataSource _remote;
  final UserIdLocalDataSource _userIdLocal;

  TransactionsRepositoryImpl({
    required TransactionsRemoteDataSource remote,
    required UserIdLocalDataSource userIdLocal,
  })  : _remote = remote,
        _userIdLocal = userIdLocal;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final models = await _remote.getCategories();
      return models.map((m) => m.toEntity()).toList(growable: false);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> addTransaction(TransactionEntity tx) async {
    try {
      final userId = await _requireUserId();

      // Ensure user context is attached before going to data layer.
      final txWithUser = TransactionEntity(
        id: tx.id,
        userId: userId,
        categoryId: tx.categoryId,
        type: tx.type,
        amount: tx.amount,
        date: tx.date,
        note: tx.note,
      );

      final model = TransactionModelX.fromEntity(txWithUser);
      await _remote.addTransaction(model);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  /// Transaction history (domain entities) for current user.
  Future<List<TransactionEntity>> getTransactionHistory({
    DateTime? from,
    DateTime? to,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final userId = await _requireUserId();

      final models = await _remote.getTransactionHistory(
        userId: userId,
        from: from,
        to: to,
        limit: limit,
        offset: offset,
      );

      return models.map((m) => m.toEntity()).toList(growable: false);
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  Future<String> _requireUserId() async {
    final userId = await _userIdLocal.getUserId();
    final id = userId?.trim();

    if (id == null || id.isEmpty) {
      throw const AuthException('Missing user_id (user not logged in).');
    }

    return id;
  }
}
