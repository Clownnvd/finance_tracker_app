import 'package:equatable/equatable.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';

class AddTransactionState extends Equatable {
  final bool isLoading;
  final String? error;

  final TransactionType type;
  final CategoryEntity? category;

  final double amount;
  final DateTime date;
  final String note;

  const AddTransactionState({
    required this.isLoading,
    required this.type,
    required this.amount,
    required this.date,
    required this.note,
    this.category,
    this.error,
  });

  factory AddTransactionState.initial() {
    final now = DateTime.now();
    return AddTransactionState(
      isLoading: false,
      type: TransactionType.expense,
      amount: 0,
      date: DateTime(now.year, now.month, now.day),
      note: '',
    );
  }

  bool get canSubmit => !isLoading && amount > 0 && category != null;

  AddTransactionState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    TransactionType? type,
    CategoryEntity? category,
    double? amount,
    DateTime? date,
    String? note,
    bool clearCategory = false,
  }) {
    return AddTransactionState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      type: type ?? this.type,
      category: clearCategory ? null : (category ?? this.category),
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    type,
    category,
    amount,
    date,
    note,
  ];
}
