import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/repositories/transactions_repository.dart';

import 'transaction_history_state.dart';

class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final TransactionsRepository _repo;

  TransactionHistoryCubit({required TransactionsRepository repo})
      : _repo = repo,
        super(TransactionHistoryState.initial());

  CancelToken? _cancelToken;

  static const int _pageSize = 20;

  Future<void> load({DateTime? from, DateTime? to}) async {
    if (state.isLoading) return;

    _cancelOngoing();
    _cancelToken = CancelToken();

    emit(state.copyWith(
      isLoading: true,
      error: null,
      items: <TransactionEntity>[],
      hasMore: true,
      isLoadingMore: false,
    ));

    try {
      final items = await _repo.getTransactionHistory(
        from: from,
        to: to,
        limit: _pageSize,
        offset: 0,
      );

      emit(state.copyWith(
        isLoading: false,
        items: items,
        hasMore: items.length >= _pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: ExceptionMapper.map(e).toString(),
      ));
    }
  }

  Future<void> refresh({DateTime? from, DateTime? to}) async {
    await load(from: from, to: to);
  }

  Future<void> loadMore({DateTime? from, DateTime? to}) async {
    if (!state.hasMore) return;
    if (state.isLoading || state.isLoadingMore) return;

    _cancelOngoing();
    _cancelToken = CancelToken();

    emit(state.copyWith(isLoadingMore: true, error: null));

    try {
      final next = await _repo.getTransactionHistory(
        from: from,
        to: to,
        limit: _pageSize,
        offset: state.items.length,
      );

      emit(state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...next],
        hasMore: next.length >= _pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        error: ExceptionMapper.map(e).toString(),
      ));
    }
  }

  void _cancelOngoing() {
    if (_cancelToken?.isCancelled == false) {
      _cancelToken?.cancel();
    }
    _cancelToken = null;
  }

  @override
  Future<void> close() {
    _cancelOngoing();
    return super.close();
  }
}
