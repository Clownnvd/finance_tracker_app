import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/pages/dashboard_screen.dart';

class MockDashboardCubit extends MockCubit<DashboardState>
    implements DashboardCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockDashboardCubit cubit;
  late MockNavigatorObserver navObserver;

  setUp(() {
    cubit = MockDashboardCubit();
    navObserver = MockNavigatorObserver();

    // initState() sẽ gọi load(recentLimit: 3)
    when(() => cubit.load(
          month: any(named: 'month'),
          recentLimit: any(named: 'recentLimit'),
          force: any(named: 'force'),
        )).thenAnswer((_) async {});

    when(() => cubit.refresh(recentLimit: any(named: 'recentLimit')))
        .thenAnswer((_) async {});
  });

  DashboardData buildData({
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

  Future<void> pumpDashboard(
    WidgetTester tester, {
    required DashboardState initial,
    List<DashboardState> stream = const [],
  }) async {
    when(() => cubit.state).thenReturn(initial);

    whenListen(
      cubit,
      Stream<DashboardState>.fromIterable(stream),
      initialState: initial,
    );

    await tester.pumpWidget(
      BlocProvider<DashboardCubit>.value(
        value: cubit,
        child: MaterialApp(
          navigatorObservers: [navObserver],
          routes: {
            '/': (_) => const DashboardScreen(),
            AppRoutes.addTransaction: (_) =>
                const Scaffold(body: Text('AddTx')),
            AppRoutes.transactionHistory: (_) =>
                const Scaffold(body: Text('HistoryPage')),
          },
          initialRoute: '/',
        ),
      ),
    );

    // chạy microtask trong initState()
    await tester.pump();
  }

  group('DashboardScreen', () {
    testWidgets('calls cubit.load(recentLimit: 3) on first build',
        (tester) async {
      final s0 = DashboardState.initial();

      await pumpDashboard(tester, initial: s0);

      verify(() => cubit.load(recentLimit: 3)).called(1);
    });

    testWidgets('shows loading overlay when isLoading = true', (tester) async {
      final s0 = DashboardState.initial().copyWith(isLoading: true);

      await pumpDashboard(tester, initial: s0);

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty text when no recent and not loading',
        (tester) async {
      final s0 = DashboardState.initial().copyWith(
        isLoading: false,
        data: buildData(recent: const []),
      );

      await pumpDashboard(tester, initial: s0);

      expect(find.text('Recent Transactions'), findsOneWidget);
      expect(find.text('No transactions yet.'), findsOneWidget);
    });

    testWidgets('renders recent transaction content', (tester) async {
      final tx = DashboardTransaction(
        id: 1,
        title: 'Food',
        icon: 'food',
        date: DateTime(2026, 1, 5),
        amount: 1234.0,
        isIncome: false,
        note: 'Lunch',
        categoryId: 10,
      );

      final s0 = DashboardState.initial().copyWith(
        isLoading: false,
        data: buildData(recent: [tx]),
      );

      await pumpDashboard(tester, initial: s0);

      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Jan 5'), findsOneWidget); // _dateShort
      expect(find.text('\$1,234'), findsOneWidget); // _money
      expect(find.text('Lunch'), findsOneWidget);
    });

    testWidgets('shows SnackBar when state.error is emitted', (tester) async {
      final s0 = DashboardState.initial();
      final s1 = s0.copyWith(error: 'Something went wrong');

      await pumpDashboard(tester, initial: s0, stream: [s1]);

      await tester.pump(); // render snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('pull-to-refresh calls cubit.refresh(recentLimit: 3)',
        (tester) async {
      final s0 = DashboardState.initial().copyWith(
        isLoading: false,
        data: buildData(recent: const []),
      );

      await pumpDashboard(tester, initial: s0);

      await tester.drag(find.byType(Scrollable), const Offset(0, 300));
      await tester.pump(); // start refresh
      await tester.pump(const Duration(milliseconds: 300));

      verify(() => cubit.refresh(recentLimit: 3)).called(1);
    });

    testWidgets('tapping Add navigates to AddTransaction route',
        (tester) async {
      final s0 = DashboardState.initial().copyWith(
        isLoading: false,
        data: buildData(recent: const []),
      );

      await pumpDashboard(tester, initial: s0);

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('AddTx'), findsOneWidget);
    });

    testWidgets('tapping History navigates to TransactionHistory route',
        (tester) async {
      final s0 = DashboardState.initial().copyWith(
        isLoading: false,
        data: buildData(recent: const []),
      );

      await pumpDashboard(tester, initial: s0);

      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      expect(find.text('HistoryPage'), findsOneWidget);
    });
  });
}
