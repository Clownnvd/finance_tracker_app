import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';
import 'package:finance_tracker_app/core/utils/app_logger.dart';

import 'package:finance_tracker_app/feature/monthly_report/data/models/report_remote_data_source.dart';
import 'package:finance_tracker_app/feature/monthly_report/data/mappers/category_total_mapper.dart';
import 'package:finance_tracker_app/feature/monthly_report/data/mappers/month_total_mapper.dart';
import 'package:finance_tracker_app/feature/monthly_report/data/mappers/top_expense_mapper.dart';

import 'package:finance_tracker_app/feature/monthly_report/data/dto/category_total_dto.dart';
import 'package:finance_tracker_app/feature/monthly_report/data/dto/month_total_dto.dart';
import 'package:finance_tracker_app/feature/monthly_report/data/dto/top_expense_dto.dart';

import 'package:finance_tracker_app/feature/monthly_report/domain/entities/category_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/month_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/top_expense.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/repositories/report_repository.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/money.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/report_month.dart';

/// Supabase-backed implementation of [MonthlyReportRepository].
///
/// Responsibilities:
/// - Read current userId from secure storage
/// - Call remote data source (views / RPC / REST)
/// - Convert raw JSON -> DTO
/// - Map DTO -> Domain entities
/// - Normalize errors via [ExceptionMapper]
class MonthlyReportRepositoryImpl implements MonthlyReportRepository {
  final MonthlyReportRemoteDataSource _remote;
  final UserIdLocalDataSource _userIdLocal;

  MonthlyReportRepositoryImpl({
    required MonthlyReportRemoteDataSource remote,
    required UserIdLocalDataSource userIdLocal,
  })  : _remote = remote,
        _userIdLocal = userIdLocal;

  // =============================================================
  // YEARLY TREND (Monthly totals for chart)
  // =============================================================

  @override
  Future<List<MonthTotal>> getYearTotals({
    required int year,
    required MonthTotalType type,
  }) async {
    try {
      final rawList = await _remote.fetchMonthTotals(
        type: type.toApi(),
        year: year,
      );

      final dtos = rawList.map(MonthTotalDto.fromJson).toList();
      return MonthTotalMapper.toDomainList(dtos);
    } catch (e, st) {
      AppLogger.repository('getYearTotals failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  // =============================================================
  // MONTH SUMMARY (Income / Expense total)
  // =============================================================

  @override
  Future<Money> getMonthTotal({
    required ReportMonth month,
    required MonthTotalType type,
  }) async {
    try {
      final uid = await _requireUserId();

      final rawList = await _remote.fetchMonthTotalsViewFiltered(
        uid: uid,
        monthStartIso: month.startIso,
        type: type.toApi(),
      );

      if (rawList.isEmpty) {
        return Money.zero;
      }

      final dto = MonthTotalDto.fromJson(rawList.first);
      return Money(dto.total);
    } catch (e, st) {
      AppLogger.repository('getMonthTotal failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  // =============================================================
  // CATEGORY BREAKDOWN (Pie chart)
  // =============================================================

  @override
  Future<List<CategoryTotal>> getCategoryTotals({
    required ReportMonth month,
    required MonthTotalType type,
  }) async {
    try {
      final uid = await _requireUserId();

      final rawList = await _remote.fetchCategoryTotals(
        uid: uid,
        startDateIso: month.startIso,
        endDateIso: month.endIso,
        catType: type.toApi(),
      );

      final dtos = rawList.map(CategoryTotalDto.fromJson).toList();
      return CategoryTotalMapper.toDomainList(dtos);
    } catch (e, st) {
      AppLogger.repository('getCategoryTotals failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  // =============================================================
  // TOP EXPENSES
  // =============================================================

  @override
  Future<List<TopExpense>> getTopExpenses({
    required ReportMonth month,
    int limit = 3,
  }) async {
    try {
      final uid = await _requireUserId();

      final rawList = await _remote.fetchTopExpenses(
        uid: uid,
        startDateIso: month.startIso,
        endDateIso: month.endIso,
        limit: limit,
      );

      final dtos = rawList.map(TopExpenseDto.fromJson).toList();
      return TopExpenseMapper.toDomainList(dtos);
    } catch (e, st) {
      AppLogger.repository('getTopExpenses failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  // =============================================================
  // Helpers
  // =============================================================

  Future<String> _requireUserId() async {
    final uid = await _userIdLocal.getUserId();
    if (uid == null || uid.trim().isEmpty) {
      throw const FormatException('User ID is missing. Please login again.');
    }
    return uid.trim();
  }
}
