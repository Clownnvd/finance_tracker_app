import 'package:equatable/equatable.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';

class SelectCategoryState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<CategoryEntity> expense;
  final List<CategoryEntity> income;
  final int? selectedCategoryId;

  const SelectCategoryState({
    required this.isLoading,
    required this.expense,
    required this.income,
    this.error,
    this.selectedCategoryId,
  });

  factory SelectCategoryState.initial({int? selectedCategoryId}) {
    return SelectCategoryState(
      isLoading: false,
      expense: const [],
      income: const [],
      selectedCategoryId: selectedCategoryId,
    );
  }

  SelectCategoryState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    List<CategoryEntity>? expense,
    List<CategoryEntity>? income,
    int? selectedCategoryId,
  }) {
    return SelectCategoryState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      expense: expense ?? this.expense,
      income: income ?? this.income,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        expense,
        income,
        selectedCategoryId,
      ];
}
