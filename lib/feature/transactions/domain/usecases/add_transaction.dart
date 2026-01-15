import 'package:finance_tracker_app/core/error/exceptions.dart';

import '../entities/transaction_entity.dart';
import '../repositories/transactions_repository.dart';

class AddTransaction {
  final TransactionsRepository _repo;

  const AddTransaction(this._repo);

  Future<void> call(TransactionEntity tx) async {
    _validate(tx);
    await _repo.addTransaction(tx);
  }

  void _validate(TransactionEntity tx) {
    if (tx.userId.trim().isEmpty) {
      throw const ValidationException('Missing user id');
    }

    if (tx.categoryId <= 0) {
      throw const ValidationException('Please select a category');
    }

    if (tx.amount.isNaN || tx.amount.isInfinite || tx.amount <= 0) {
      throw const ValidationException('Amount must be greater than 0');
    }

    // date must be valid (not epoch)
    if (tx.date.year < 2000) {
      throw const ValidationException('Invalid date');
    }

    final note = tx.note?.trim() ?? '';
    if (note.length > 300) {
      throw const ValidationException('Note is too long (max 300 chars)');
    }
  }
}
