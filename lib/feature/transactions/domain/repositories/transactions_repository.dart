import '../entities/category_entity.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionsRepository {
  Future<List<CategoryEntity>> getCategories();

  /// Inserts a new transaction for current user.
  /// Throws AppException (Validation/Auth/Network/Server) from lower layers.
  Future<void> addTransaction(TransactionEntity tx);

  /// Fetches transaction history for current user (supports filters + paging).
  ///
  /// Notes:
  /// - Use [from] and [to] for date filtering (inclusive).
  /// - Use [limit]/[offset] for pagination.
  /// - Sorting should be newest first in the data layer.
  ///
  /// Throws AppException (Validation/Auth/Network/Server) from lower layers.
  Future<List<TransactionEntity>> getTransactionHistory({
    DateTime? from,
    DateTime? to,
    int limit = 50,
    int offset = 0,
  });
}
