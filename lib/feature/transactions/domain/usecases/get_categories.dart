import '../entities/category_entity.dart';
import '../repositories/transactions_repository.dart';

class GetCategories {
  final TransactionsRepository _repo;

  const GetCategories(this._repo);

  Future<List<CategoryEntity>> call() {
    return _repo.getCategories();
  }
}
