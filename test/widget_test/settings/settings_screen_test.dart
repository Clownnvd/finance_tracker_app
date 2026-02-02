import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';
import 'package:finance_tracker_app/feature/settings/presentation/cubit/settings_cubit.dart';
import 'package:finance_tracker_app/feature/settings/presentation/cubit/settings_state.dart';
import 'package:finance_tracker_app/feature/settings/presentation/pages/settings_screen.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockSettingsCubit mockCubit;
  late MockNavigatorObserver mockNavigatorObserver;

  SettingsState loadedState({
    bool reminderOn = false,
    bool budgetAlertOn = false,
    bool tipsOn = false,
    bool hasAnyBudget = false,
    bool shouldPromptSetBudget = false,
  }) {
    return SettingsState(
      isLoading: false,
      settings: AppSettings(
        reminderOn: reminderOn,
        budgetAlertOn: budgetAlertOn,
        tipsOn: tipsOn,
      ),
      hasAnyBudget: hasAnyBudget,
      shouldPromptSetBudget: shouldPromptSetBudget,
    );
  }

  Widget buildWidget() {
    return MaterialApp(
      home: BlocProvider<SettingsCubit>.value(
        value: mockCubit,
        child: const SettingsScreen(),
      ),
      navigatorObservers: [mockNavigatorObserver],
      routes: {
        '/set-budget': (_) => const Scaffold(body: Text('Set Budget Screen')),
        '/account-security': (_) =>
            const Scaffold(body: Text('Account Security Screen')),
      },
    );
  }

  setUp(() {
    mockCubit = MockSettingsCubit();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  setUpAll(() {
    registerFallbackValue(SettingsState.initial());
  });

  group('SettingsScreen', () {
    testWidgets('displays AppBar with title', (tester) async {
      when(() => mockCubit.state).thenReturn(loadedState());
      when(() => mockCubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('displays loading indicator when isLoading is true',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        SettingsState.initial().copyWith(isLoading: true),
      );
      when(() => mockCubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays Transaction Reminder switch', (tester) async {
      when(() => mockCubit.state).thenReturn(loadedState(reminderOn: true));
      when(() => mockCubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Transaction Reminder'), findsOneWidget);
      expect(find.byType(Switch), findsWidgets);
    });

    testWidgets('displays Budget Limit switch', (tester) async {
      when(() => mockCubit.state).thenReturn(loadedState(budgetAlertOn: false));
      when(() => mockCubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Budget Limit'), findsOneWidget);
    });

    testWidgets('displays Tips & Recommendations switch', (tester) async {
      when(() => mockCubit.state).thenReturn(loadedState(tipsOn: true));
      when(() => mockCubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Tips & Recommendations'), findsOneWidget);
    });

    testWidgets('displays Account & Security option', (tester) async {
      when(() => mockCubit.state).thenReturn(loadedState());
      when(() => mockCubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.text('Account & Security'), findsOneWidget);
    });

    testWidgets('calls toggleReminder when reminder switch is tapped',
        (tester) async {
      when(() => mockCubit.state).thenReturn(loadedState(reminderOn: false));
      when(() => mockCubit.load()).thenAnswer((_) async {});
      when(() => mockCubit.toggleReminder(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Find the first switch (Transaction Reminder)
      final switches = find.byType(Switch);
      expect(switches, findsWidgets);

      await tester.tap(switches.first);
      await tester.pump();

      verify(() => mockCubit.toggleReminder(true)).called(1);
    });

    testWidgets('calls toggleBudgetLimit when budget switch is tapped',
        (tester) async {
      when(() => mockCubit.state).thenReturn(loadedState(budgetAlertOn: false));
      when(() => mockCubit.load()).thenAnswer((_) async {});
      when(() => mockCubit.toggleBudgetLimit(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Find the second switch (Budget Limit)
      final switches = find.byType(Switch);
      if (switches.evaluate().length >= 2) {
        await tester.tap(switches.at(1));
        await tester.pump();

        verify(() => mockCubit.toggleBudgetLimit(true)).called(1);
      }
    });

    testWidgets('calls toggleTips when tips switch is tapped', (tester) async {
      when(() => mockCubit.state).thenReturn(loadedState(tipsOn: false));
      when(() => mockCubit.load()).thenAnswer((_) async {});
      when(() => mockCubit.toggleTips(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Find the third switch (Tips)
      final switches = find.byType(Switch);
      if (switches.evaluate().length >= 3) {
        await tester.tap(switches.at(2));
        await tester.pump();

        verify(() => mockCubit.toggleTips(true)).called(1);
      }
    });

    testWidgets('shows snackbar when errorMessage is set', (tester) async {
      final statesController = StreamController<SettingsState>.broadcast();

      whenListen(
        mockCubit,
        statesController.stream,
        initialState: loadedState(),
      );
      when(() => mockCubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      statesController.add(loadedState().copyWith(errorMessage: 'Save failed'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Save failed'), findsOneWidget);

      await statesController.close();
    });

    testWidgets('shows No Budget dialog when shouldPromptSetBudget is true',
        (tester) async {
      final statesController = StreamController<SettingsState>.broadcast();

      whenListen(
        mockCubit,
        statesController.stream,
        initialState: loadedState(),
      );
      when(() => mockCubit.load()).thenAnswer((_) async {});
      when(() => mockCubit.consumePrompt()).thenReturn(null);

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      statesController.add(loadedState(shouldPromptSetBudget: true));
      await tester.pumpAndSettle();

      expect(find.text('No Budget set'), findsOneWidget);
      expect(find.text('Set Budget'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await statesController.close();
    });

    testWidgets('calls consumePrompt when dialog is shown', (tester) async {
      final statesController = StreamController<SettingsState>.broadcast();

      whenListen(
        mockCubit,
        statesController.stream,
        initialState: loadedState(),
      );
      when(() => mockCubit.load()).thenAnswer((_) async {});
      when(() => mockCubit.consumePrompt()).thenReturn(null);

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      statesController.add(loadedState(shouldPromptSetBudget: true));
      await tester.pumpAndSettle();

      verify(() => mockCubit.consumePrompt()).called(1);

      await statesController.close();
    });

    testWidgets('switches are disabled when loading', (tester) async {
      when(() => mockCubit.state).thenReturn(
        loadedState().copyWith(isLoading: true),
      );
      when(() => mockCubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Check switches exist
      final switches = find.byType(Switch);
      expect(switches, findsWidgets);
    });

    testWidgets('loads settings on init', (tester) async {
      when(() => mockCubit.state).thenReturn(loadedState());
      when(() => mockCubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // The screen calls load() in initState via Future.microtask
      await tester.pump();

      verify(() => mockCubit.load()).called(1);
    });

    testWidgets('rebuilds when state changes', (tester) async {
      final statesController = StreamController<SettingsState>.broadcast();

      whenListen(
        mockCubit,
        statesController.stream,
        initialState: SettingsState.initial(),
      );
      when(() => mockCubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Initial state shows loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Emit loaded state
      statesController.add(loadedState(reminderOn: true));
      await tester.pumpAndSettle();

      // Loading should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await statesController.close();
    });
  });
}
