import '../entities/transaction_entity.dart';
import '../repositories/transactions_repository.dart';

/// Retrieves transaction history for the current user.
///
/// This use case:
/// - Delegates data fetching to [TransactionsRepository]
/// - Does NOT handle mapping or error transformation
/// - Throws AppException from lower layers
class GetTransactionHistory {
  final TransactionsRepository _repository;

  const GetTransactionHistory(this._repository);

  /// Fetches transactions with optional date range and pagination.
  ///
  /// [userId]      - Required user identifier
  /// [from]        - Optional start date (inclusive)
  /// [to]          - Optional end date (inclusive)
  /// [limit]       - Max number of records (default 50)
  /// [offset]      - Pagination offset (default 0)
  ///
  /// Throws:
  /// - NetworkException
  /// - AuthException
  /// - ServerException
  Future<List<TransactionEntity>> call({
    required String userId,
    DateTime? from,
    DateTime? to,
    int limit = 50,
    int offset = 0,
  }) {
    return _repository.getTransactionHistory(
      from: from,
      to: to,
      limit: limit,
      offset: offset,
    );
  }
}
