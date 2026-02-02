import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/budgets/domain/entities/budget.dart';
import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/get_all_budgets.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/get_my_settings.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/upsert_settings.dart';
import 'package:finance_tracker_app/feature/settings/presentation/cubit/settings_cubit.dart';
import 'package:finance_tracker_app/feature/settings/presentation/cubit/settings_state.dart';

class MockGetMySettings extends Mock implements GetMySettings {}

class MockUpsertSettings extends Mock implements UpsertSettings {}

class MockGetAllBudgets extends Mock implements GetAllBudgets {}

void main() {
  late MockGetMySettings mockGetMySettings;
  late MockUpsertSettings mockUpsertSettings;
  late MockGetAllBudgets mockGetAllBudgets;
  late SettingsCubit cubit;

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

  setUpAll(() {
    registerFallbackValue(AppSettings.defaults);
  });

  setUp(() {
    mockGetMySettings = MockGetMySettings();
    mockUpsertSettings = MockUpsertSettings();
    mockGetAllBudgets = MockGetAllBudgets();

    cubit = SettingsCubit(
      getMySettings: mockGetMySettings,
      upsertSettings: mockUpsertSettings,
      getAllBudgets: mockGetAllBudgets,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('SettingsCubit', () {
    group('load', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits [isLoading=true, isLoading=false with settings and budgets] on success',
        build: () {
          when(() => mockGetMySettings()).thenAnswer((_) async => testSettings);
          when(() => mockGetAllBudgets())
              .thenAnswer((_) async => [testBudget()]);
          return cubit;
        },
        act: (c) => c.load(),
        expect: () => [
          isA<SettingsState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<SettingsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.settings, 'settings', testSettings)
              .having((s) => s.hasAnyBudget, 'hasAnyBudget', true)
              .having((s) => s.shouldPromptSetBudget, 'shouldPromptSetBudget', false),
        ],
        verify: (_) {
          verify(() => mockGetMySettings()).called(1);
          verify(() => mockGetAllBudgets()).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'sets hasAnyBudget=false when no budgets',
        build: () {
          when(() => mockGetMySettings()).thenAnswer((_) async => testSettings);
          when(() => mockGetAllBudgets()).thenAnswer((_) async => []);
          return cubit;
        },
        act: (c) => c.load(),
        expect: () => [
          isA<SettingsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<SettingsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.hasAnyBudget, 'hasAnyBudget', false),
        ],
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits error on failure',
        build: () {
          when(() => mockGetMySettings()).thenThrow(Exception('Network error'));
          return cubit;
        },
        act: (c) => c.load(),
        expect: () => [
          isA<SettingsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<SettingsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('consumePrompt', () {
      blocTest<SettingsCubit, SettingsState>(
        'sets shouldPromptSetBudget to false',
        build: () => cubit,
        seed: () => SettingsState.initial().copyWith(
          isLoading: false,
          shouldPromptSetBudget: true,
        ),
        act: (c) => c.consumePrompt(),
        expect: () => [
          isA<SettingsState>()
              .having((s) => s.shouldPromptSetBudget, 'shouldPromptSetBudget', false),
        ],
      );

      blocTest<SettingsCubit, SettingsState>(
        'does nothing when shouldPromptSetBudget is already false',
        build: () => cubit,
        seed: () => SettingsState.initial().copyWith(
          isLoading: false,
          shouldPromptSetBudget: false,
        ),
        act: (c) => c.consumePrompt(),
        expect: () => <SettingsState>[],
      );
    });

    group('toggleReminder', () {
      blocTest<SettingsCubit, SettingsState>(
        'saves settings with reminderOn toggled',
        build: () {
          when(() => mockUpsertSettings(any())).thenAnswer((inv) async {
            return inv.positionalArguments[0] as AppSettings;
          });
          return cubit;
        },
        seed: () => SettingsState.initial().copyWith(
          isLoading: false,
          settings: AppSettings.defaults,
        ),
        act: (c) => c.toggleReminder(true),
        expect: () => [
          isA<SettingsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<SettingsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.settings.reminderOn, 'reminderOn', true),
        ],
        verify: (_) {
          verify(() => mockUpsertSettings(any(
                that: isA<AppSettings>()
                    .having((s) => s.reminderOn, 'reminderOn', true),
              ))).called(1);
        },
      );
    });

    group('toggleTips', () {
      blocTest<SettingsCubit, SettingsState>(
        'saves settings with tipsOn toggled',
        build: () {
          when(() => mockUpsertSettings(any())).thenAnswer((inv) async {
            return inv.positionalArguments[0] as AppSettings;
          });
          return cubit;
        },
        seed: () => SettingsState.initial().copyWith(
          isLoading: false,
          settings: AppSettings.defaults,
        ),
        act: (c) => c.toggleTips(true),
        expect: () => [
          isA<SettingsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<SettingsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.settings.tipsOn, 'tipsOn', true),
        ],
      );
    });

    group('toggleBudgetLimit', () {
      blocTest<SettingsCubit, SettingsState>(
        'shows prompt when enabling budget limit with no budgets',
        build: () => cubit,
        seed: () => SettingsState.initial().copyWith(
          isLoading: false,
          hasAnyBudget: false,
          settings: AppSettings.defaults,
        ),
        act: (c) => c.toggleBudgetLimit(true),
        expect: () => [
          isA<SettingsState>()
              .having((s) => s.settings.budgetAlertOn, 'budgetAlertOn', false)
              .having((s) => s.shouldPromptSetBudget, 'shouldPromptSetBudget', true),
        ],
        verify: (_) {
          verifyNever(() => mockUpsertSettings(any()));
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'saves settings when enabling budget limit with existing budgets',
        build: () {
          when(() => mockUpsertSettings(any())).thenAnswer((inv) async {
            return inv.positionalArguments[0] as AppSettings;
          });
          return cubit;
        },
        seed: () => SettingsState.initial().copyWith(
          isLoading: false,
          hasAnyBudget: true,
          settings: AppSettings.defaults,
        ),
        act: (c) => c.toggleBudgetLimit(true),
        expect: () => [
          isA<SettingsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<SettingsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.settings.budgetAlertOn, 'budgetAlertOn', true),
        ],
        verify: (_) {
          verify(() => mockUpsertSettings(any(
                that: isA<AppSettings>()
                    .having((s) => s.budgetAlertOn, 'budgetAlertOn', true),
              ))).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'saves settings when disabling budget limit',
        build: () {
          when(() => mockUpsertSettings(any())).thenAnswer((inv) async {
            return inv.positionalArguments[0] as AppSettings;
          });
          return cubit;
        },
        seed: () => SettingsState.initial().copyWith(
          isLoading: false,
          hasAnyBudget: false,
          settings: const AppSettings(
            reminderOn: false,
            budgetAlertOn: true,
            tipsOn: false,
          ),
        ),
        act: (c) => c.toggleBudgetLimit(false),
        expect: () => [
          isA<SettingsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<SettingsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.settings.budgetAlertOn, 'budgetAlertOn', false),
        ],
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits error when save fails',
        build: () {
          when(() => mockUpsertSettings(any()))
              .thenThrow(Exception('Save failed'));
          return cubit;
        },
        seed: () => SettingsState.initial().copyWith(
          isLoading: false,
          hasAnyBudget: true,
          settings: AppSettings.defaults,
        ),
        act: (c) => c.toggleBudgetLimit(true),
        expect: () => [
          isA<SettingsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<SettingsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });
  });
}
