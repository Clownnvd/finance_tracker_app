import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/repositories/transactions_repository.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/get_categories.dart';

class MockTransactionsRepository extends Mock implements TransactionsRepository {}

void main() {
  late MockTransactionsRepository repo;
  late GetCategories usecase;

  setUp(() {
    repo = MockTransactionsRepository();
    usecase = GetCategories(repo);
  });

  test('returns categories from repo', () async {
    const items = [
      CategoryEntity(id: 1, name: 'Food', type: TransactionType.expense, icon: 'food'),
      CategoryEntity(id: 2, name: 'Salary', type: TransactionType.income, icon: 'salary'),
    ];

    when(() => repo.getCategories()).thenAnswer((_) async => items);

    final res = await usecase();

    expect(res, items);
    verify(() => repo.getCategories()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
