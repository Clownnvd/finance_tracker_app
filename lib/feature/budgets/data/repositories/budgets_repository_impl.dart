import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';
import 'package:finance_tracker_app/core/utils/app_logger.dart';

import '../../domain/entities/budget.dart';
import '../../domain/repositories/budgets_repository.dart';
import '../datasources/budgets_remote_data_source.dart';
import '../dto/budget_dto.dart';
import '../mappers/budget_mapper.dart';

class BudgetsRepositoryImpl implements BudgetsRepository {
  final BudgetsRemoteDataSource _remote;
  final UserIdLocalDataSource _userIdLocal;

  BudgetsRepositoryImpl({
    required BudgetsRemoteDataSource remote,
    required UserIdLocalDataSource userIdLocal,
  })  : _remote = remote,
        _userIdLocal = userIdLocal;

  @override
  Future<List<Budget>> getMyBudgets() async {
    try {
      final uid = await _requireUserId();
      final raw = await _remote.getMyBudgets(uid: uid);
      final dtos = raw.map(BudgetDto.fromJson).toList();
      return BudgetMapper.toDomainList(dtos);
    } catch (e, st) {
      AppLogger.repository('getMyBudgets failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<Budget> createBudget({
    required int categoryId,
    required double amount,
    required int month,
  }) async {
    try {
      final uid = await _requireUserId();
      final raw = await _remote.createBudget(
        uid: uid,
        categoryId: categoryId,
        amount: amount,
        month: month,
      );

      if (raw.isEmpty) {
        throw const FormatException('Create budget failed: empty response');
      }

      final dto = BudgetDto.fromJson(raw.first);
      return BudgetMapper.toDomain(dto);
    } catch (e, st) {
      AppLogger.repository('createBudget failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<Budget> updateBudget({
    required int budgetId,
    double? amount,
    int? categoryId,
    int? month,
  }) async {
    try {
      final raw = await _remote.updateBudget(
        budgetId: budgetId,
        amount: amount,
        categoryId: categoryId,
        month: month,
      );

      if (raw.isEmpty) {
        throw const FormatException('Update budget failed: empty response');
      }

      final dto = BudgetDto.fromJson(raw.first);
      return BudgetMapper.toDomain(dto);
    } catch (e, st) {
      AppLogger.repository('updateBudget failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<void> deleteBudget({required int budgetId}) async {
    try {
      await _remote.deleteBudget(budgetId: budgetId);
    } catch (e, st) {
      AppLogger.repository('deleteBudget failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<bool> hasAnyBudget() async {
    final list = await getMyBudgets();
    return list.isNotEmpty;
  }

  Future<String> _requireUserId() async {
    final uid = await _userIdLocal.getUserId();
    if (uid == null || uid.trim().isEmpty) {
      throw const FormatException('User ID is missing. Please login again.');
    }
    return uid.trim();
  }
}
