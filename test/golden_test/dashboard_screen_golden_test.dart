import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardCubit extends MockCubit<DashboardState>
    implements DashboardCubit {}

Widget _buildGoldenApp(DashboardCubit cubit) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: BlocProvider<DashboardCubit>.value(
      value: cubit,
      child: const DashboardScreen(),
    ),
  );
}

DashboardData _fakeData({
  double income = 5000,
  double expenses = 1200,
  List<DashboardTransaction> recent = const [],
}) {
  return DashboardData(
    month: DateTime(2026, 1, 1),
    summary: DashboardSummary(income: income, expenses: expenses),
    expenseBreakdown: const [],
    incomeBreakdown: const [],
    recent: recent,
  );
}

Future<void> _pumpStable(WidgetTester tester) async {
  // Do NOT use pumpAndSettle because LinearProgressIndicator keeps animating.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(DashboardState.initial());
  });

  void _stubCubitApis(MockDashboardCubit cubit) {
    // Matches: cubit.load(recentLimit: 3) from initState()
    when(() => cubit.load(
          recentLimit: any(named: 'recentLimit'),
        )).thenAnswer((_) async {});

    // Matches: cubit.load(month: ..., recentLimit: ..., force: ...)
    when(() => cubit.load(
          month: any(named: 'month'),
          recentLimit: any(named: 'recentLimit'),
          force: any(named: 'force'),
        )).thenAnswer((_) async {});

    // RefreshIndicator calls refresh(recentLimit: 3)
    when(() => cubit.refresh(
          recentLimit: any(named: 'recentLimit'),
        )).thenAnswer((_) async {});
  }

  group('DashboardScreen golden', () {
    testWidgets('initial / empty state', (tester) async {
      final cubit = MockDashboardCubit();
      _stubCubitApis(cubit);

      final state = DashboardState.initial().copyWith(
        isLoading: false,
        data: _fakeData(recent: const []),
      );

      when(() => cubit.state).thenReturn(state);
      whenListen<DashboardState>(
        cubit,
        const Stream<DashboardState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(DashboardScreen),
        matchesGoldenFile('golden_test/goldens/dashboard_screen_empty.png'),
      );
    });

    testWidgets('loading state', (tester) async {
      final cubit = MockDashboardCubit();
      _stubCubitApis(cubit);

      final loading = DashboardState.initial().copyWith(isLoading: true);

      when(() => cubit.state).thenReturn(loading);
      whenListen<DashboardState>(
        cubit,
        Stream<DashboardState>.fromIterable([loading]),
        initialState: loading,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(DashboardScreen),
        matchesGoldenFile('golden_test/goldens/dashboard_screen_loading.png'),
      );
    });

    testWidgets('data state (with transactions)', (tester) async {
      final cubit = MockDashboardCubit();
      _stubCubitApis(cubit);

      final tx1 = DashboardTransaction(
        id: 1,
        title: 'Food',
        icon: 'food',
        date: DateTime(2026, 1, 5),
        amount: 1234,
        isIncome: false,
        note: 'Lunch',
        categoryId: 10,
      );

      final tx2 = DashboardTransaction(
        id: 2,
        title: 'Salary',
        icon: 'work',
        date: DateTime(2026, 1, 3),
        amount: 2500,
        isIncome: true,
        note: null,
        categoryId: 11,
      );

      final state = DashboardState.initial().copyWith(
        isLoading: false,
        data: _fakeData(income: 8000, expenses: 2500, recent: [tx1, tx2]),
      );

      when(() => cubit.state).thenReturn(state);
      whenListen<DashboardState>(
        cubit,
        const Stream<DashboardState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(DashboardScreen),
        matchesGoldenFile(
          'golden_test/goldens/dashboard_screen_with_transactions.png',
        ),
      );
    });

    testWidgets('error snackbar', (tester) async {
      final cubit = MockDashboardCubit();
      _stubCubitApis(cubit);

      final base = DashboardState.initial().copyWith(
        isLoading: false,
        data: _fakeData(recent: const []),
      );

      final errorState = base.copyWith(error: 'Something went wrong');

      when(() => cubit.state).thenReturn(base);
      whenListen<DashboardState>(
        cubit,
        Stream<DashboardState>.fromIterable([errorState]),
        initialState: base,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));

      // First frame + listener delivery
      await tester.pump();
      await tester.pump();

      // Let SnackBar animation settle (but not pumpAndSettle)
      await tester.pump(const Duration(milliseconds: 500));

      await expectLater(
        find.byType(DashboardScreen),
        matchesGoldenFile('golden_test/goldens/dashboard_screen_error.png'),
      );
    });
  });
}
