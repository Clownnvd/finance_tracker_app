import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/add_transaction.dart';

import 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final AddTransaction _addTransaction;
  final UserIdLocalDataSource _userIdLocal;

  AddTransactionCubit({
    required AddTransaction addTransaction,
    required UserIdLocalDataSource userIdLocal,
  })  : _addTransaction = addTransaction,
        _userIdLocal = userIdLocal,
        super(AddTransactionState.initial());

  /// Category drives the transaction type.
  /// Selecting an INCOME category => tx.type becomes INCOME automatically.
  /// Selecting an EXPENSE category => tx.type becomes EXPENSE automatically.
  void setCategory(CategoryEntity category) {
    emit(
      state.copyWith(
        category: category,
        type: category.type, // ✅ infer type from category
        clearError: true,
      ),
    );
  }

  void clearCategory() {
    emit(
      state.copyWith(
        clearCategory: true,
        clearError: true,
      ),
    );
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount, clearError: true));
  }

  void setDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    emit(state.copyWith(date: d, clearError: true));
  }

  void setNote(String note) {
    emit(state.copyWith(note: note, clearError: true));
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  Future<bool> submit() async {
    if (state.isLoading) return false;

    if (state.amount <= 0) {
      emit(state.copyWith(error: 'Amount must be greater than 0.'));
      return false;
    }

    final category = state.category;
    if (category == null) {
      emit(state.copyWith(error: 'Please select a category.'));
      return false;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final userId = await _userIdLocal.getUserId();
      final uid = userId?.trim();
      if (uid == null || uid.isEmpty) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Missing user session. Please login again.',
        ));
        return false;
      }

      final tx = TransactionEntity(
        userId: uid,
        type: category.type, // ✅ always trust category.type
        amount: state.amount,
        date: state.date,
        note: state.note.trim().isEmpty ? null : state.note.trim(),
        categoryId: category.id,
      );

      await _addTransaction(tx);

      emit(AddTransactionState.initial());
      return true;
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: ExceptionMapper.map(e).toString(),
      ));
      return false;
    }
  }
}
