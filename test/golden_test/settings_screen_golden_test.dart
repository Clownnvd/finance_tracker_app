import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';
import 'package:finance_tracker_app/feature/settings/presentation/cubit/settings_cubit.dart';
import 'package:finance_tracker_app/feature/settings/presentation/cubit/settings_state.dart';
import 'package:finance_tracker_app/feature/settings/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

Widget _buildGoldenApp(SettingsCubit cubit) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: BlocProvider<SettingsCubit>.value(
      value: cubit,
      child: const SettingsScreen(),
    ),
  );
}

Future<void> _pumpStable(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(SettingsState.initial());
  });

  void _stubCubitMethods(MockSettingsCubit cubit) {
    when(() => cubit.load()).thenAnswer((_) async {});
    when(() => cubit.toggleReminder(any())).thenAnswer((_) async {});
    when(() => cubit.toggleBudgetLimit(any())).thenAnswer((_) async {});
    when(() => cubit.toggleTips(any())).thenAnswer((_) async {});
    when(() => cubit.consumePrompt()).thenReturn(null);
  }

  group('SettingsScreen golden', () {
    testWidgets('loading state', (tester) async {
      final cubit = MockSettingsCubit();
      _stubCubitMethods(cubit);

      final state = SettingsState.initial();

      when(() => cubit.state).thenReturn(state);
      whenListen<SettingsState>(
        cubit,
        Stream<SettingsState>.fromIterable([state]),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(SettingsScreen),
        matchesGoldenFile('goldens/settings_screen_loading.png'),
      );
    });

    testWidgets('loaded state (all toggles on)', (tester) async {
      final cubit = MockSettingsCubit();
      _stubCubitMethods(cubit);

      final state = SettingsState.initial().copyWith(
        isLoading: false,
        settings: const AppSettings(
          reminderOn: true,
          budgetAlertOn: true,
          tipsOn: true,
        ),
        hasAnyBudget: true,
      );

      when(() => cubit.state).thenReturn(state);
      whenListen<SettingsState>(
        cubit,
        const Stream<SettingsState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(SettingsScreen),
        matchesGoldenFile('goldens/settings_screen_loaded_all_on.png'),
      );
    });

    testWidgets('loaded state (all toggles off)', (tester) async {
      final cubit = MockSettingsCubit();
      _stubCubitMethods(cubit);

      final state = SettingsState.initial().copyWith(
        isLoading: false,
        settings: const AppSettings(
          reminderOn: false,
          budgetAlertOn: false,
          tipsOn: false,
        ),
        hasAnyBudget: false,
      );

      when(() => cubit.state).thenReturn(state);
      whenListen<SettingsState>(
        cubit,
        const Stream<SettingsState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(SettingsScreen),
        matchesGoldenFile('goldens/settings_screen_loaded_all_off.png'),
      );
    });

    testWidgets('error state (SnackBar visible)', (tester) async {
      final cubit = MockSettingsCubit();
      _stubCubitMethods(cubit);

      final s0 = SettingsState.initial().copyWith(isLoading: false);
      final s1 = s0.copyWith(errorMessage: 'Failed to load settings');

      when(() => cubit.state).thenReturn(s1);
      whenListen<SettingsState>(
        cubit,
        Stream<SettingsState>.fromIterable([s1]),
        initialState: s0,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await expectLater(
        find.byType(SettingsScreen),
        matchesGoldenFile('goldens/settings_screen_error.png'),
      );
    });
  });
}
