import 'package:dio/dio.dart';

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
  /// [from]        - Optional start date (inclusive)
  /// [to]          - Optional end date (inclusive)
  /// [limit]       - Max number of records (default 50)
  /// [offset]      - Pagination offset (default 0)
  /// [cancelToken] - Optional token to cancel the request
  ///
  /// Throws:
  /// - NetworkException
  /// - AuthException
  /// - ServerException
  Future<List<TransactionEntity>> call({
    DateTime? from,
    DateTime? to,
    int limit = 50,
    int offset = 0,
    CancelToken? cancelToken,
  }) {
    return _repository.getTransactionHistory(
      from: from,
      to: to,
      limit: limit,
      offset: offset,
      cancelToken: cancelToken,
    );
  }
}
