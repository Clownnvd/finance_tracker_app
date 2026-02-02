import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/budgets/domain/entities/budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/repositories/budgets_repository.dart';
import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';
import 'package:finance_tracker_app/feature/settings/domain/repositories/settings_repository.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/get_all_budgets.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/get_my_settings.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/upsert_settings.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockBudgetsRepository extends Mock implements BudgetsRepository {}

void main() {
  late MockSettingsRepository mockSettingsRepo;
  late MockBudgetsRepository mockBudgetsRepo;

  const testSettings = AppSettings(
    reminderOn: true,
    budgetAlertOn: false,
    tipsOn: true,
  );

  Budget testBudget({int id = 1}) {
    return Budget(
      id: id,
      userId: 'user-1',
      categoryId: 1,
      amount: 1000,
      month: 1,
    );
  }

  setUp(() {
    mockSettingsRepo = MockSettingsRepository();
    mockBudgetsRepo = MockBudgetsRepository();
  });

  setUpAll(() {
    registerFallbackValue(AppSettings.defaults);
  });

  group('GetMySettings', () {
    late GetMySettings usecase;

    setUp(() {
      usecase = GetMySettings(mockSettingsRepo);
    });

    test('returns saved settings when user has settings', () async {
      when(() => mockSettingsRepo.getMine())
          .thenAnswer((_) async => testSettings);

      final result = await usecase.call();

      expect(result.reminderOn, true);
      expect(result.budgetAlertOn, false);
      expect(result.tipsOn, true);
      verify(() => mockSettingsRepo.getMine()).called(1);
    });

    test('returns default settings when user has no saved settings', () async {
      when(() => mockSettingsRepo.getMine()).thenAnswer((_) async => null);

      final result = await usecase.call();

      expect(result, AppSettings.defaults);
      expect(result.reminderOn, false);
      expect(result.budgetAlertOn, false);
      expect(result.tipsOn, false);
    });

    test('propagates exception from repository', () async {
      when(() => mockSettingsRepo.getMine())
          .thenThrow(Exception('Network error'));

      expect(
        () => usecase.call(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('UpsertSettings', () {
    late UpsertSettings usecase;

    setUp(() {
      usecase = UpsertSettings(mockSettingsRepo);
    });

    test('returns updated settings from repository', () async {
      when(() => mockSettingsRepo.upsert(any()))
          .thenAnswer((_) async => testSettings);

      final result = await usecase.call(testSettings);

      expect(result.reminderOn, true);
      expect(result.budgetAlertOn, false);
      expect(result.tipsOn, true);
      verify(() => mockSettingsRepo.upsert(testSettings)).called(1);
    });

    test('passes settings object to repository', () async {
      const newSettings = AppSettings(
        reminderOn: false,
        budgetAlertOn: true,
        tipsOn: false,
      );

      when(() => mockSettingsRepo.upsert(any()))
          .thenAnswer((_) async => newSettings);

      await usecase.call(newSettings);

      verify(() => mockSettingsRepo.upsert(newSettings)).called(1);
    });

    test('propagates exception from repository', () async {
      when(() => mockSettingsRepo.upsert(any()))
          .thenThrow(Exception('Save failed'));

      expect(
        () => usecase.call(testSettings),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('GetAllBudgets', () {
    late GetAllBudgets usecase;

    setUp(() {
      usecase = GetAllBudgets(mockBudgetsRepo);
    });

    test('returns list of budgets from repository', () async {
      final budgets = [testBudget(id: 1), testBudget(id: 2)];
      when(() => mockBudgetsRepo.getMyBudgets())
          .thenAnswer((_) async => budgets);

      final result = await usecase.call();

      expect(result, hasLength(2));
      expect(result[0].id, 1);
      expect(result[1].id, 2);
      verify(() => mockBudgetsRepo.getMyBudgets()).called(1);
    });

    test('returns empty list when user has no budgets', () async {
      when(() => mockBudgetsRepo.getMyBudgets()).thenAnswer((_) async => []);

      final result = await usecase.call();

      expect(result, isEmpty);
    });

    test('propagates exception from repository', () async {
      when(() => mockBudgetsRepo.getMyBudgets())
          .thenThrow(Exception('Network error'));

      expect(
        () => usecase.call(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
