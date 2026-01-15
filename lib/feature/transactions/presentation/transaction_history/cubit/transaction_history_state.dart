import 'package:equatable/equatable.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';

class TransactionHistoryState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  final List<TransactionEntity> items;

  final String? error;

  // Optional filters (safe to keep for future)
  final DateTime? from;
  final DateTime? to;

  const TransactionHistoryState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.items,
    this.error,
    this.from,
    this.to,
  });

  factory TransactionHistoryState.initial({
    DateTime? from,
    DateTime? to,
  }) {
    return TransactionHistoryState(
      isLoading: false,
      isLoadingMore: false,
      hasMore: true,
      items: const <TransactionEntity>[],
      error: null,
      from: from,
      to: to,
    );
  }

  TransactionHistoryState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    List<TransactionEntity>? items,
    String? error,
    bool clearError = false,
    DateTime? from,
    DateTime? to,
    bool clearFilters = false,
  }) {
    return TransactionHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      items: items ?? this.items,
      error: clearError ? null : (error ?? this.error),
      from: clearFilters ? null : (from ?? this.from),
      to: clearFilters ? null : (to ?? this.to),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingMore,
        hasMore,
        items,
        error,
        from,
        to,
      ];
}
