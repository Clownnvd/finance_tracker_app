import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/usecases/get_dashboard_data.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';

class _MockGetDashboardData extends Mock implements GetDashboardData {}

class _FakeDateTime extends Fake implements DateTime {}

void main() {
  late _MockGetDashboardData mockUsecase;

  setUpAll(() {
    registerFallbackValue(_FakeDateTime());
  });

  setUp(() {
    mockUsecase = _MockGetDashboardData();
  });

  DashboardData fakeData({
    DateTime? month,
    double income = 1000,
    double expenses = 200,
    int recentCount = 3,
  }) {
    final m = DateTime((month ?? DateTime(2026, 1, 1)).year,
        (month ?? DateTime(2026, 1, 1)).month, 1);

    return DashboardData(
      month: m,
      summary: DashboardSummary(income: income, expenses: expenses),
      expenseBreakdown: const [],
      incomeBreakdown: const [],
      recent: List.generate(
        recentCount,
        (i) => DashboardTransaction(
          id: i + 1,
          title: 'Tx $i',
          icon: 'money',
          date: DateTime(2026, 1, 1).add(Duration(days: i)),
          amount: (i + 1) * 10.0,
          isIncome: i.isEven,
          note: i.isEven ? 'note' : null,
          categoryId: null,
        ),
      ),
    );
  }

  test('initial state should be DashboardState.initial()', () {
    final cubit = DashboardCubit(getDashboardData: mockUsecase);

    expect(cubit.state, isA<DashboardState>());
    expect(cubit.state.isLoading, false);
    expect(cubit.state.data, isNull);
    expect(cubit.state.error, isNull);
    expect(cubit.state.month.day, 1);

    cubit.close();
  });

  blocTest<DashboardCubit, DashboardState>(
    'load() success emits loading then data',
    build: () {
      when(() => mockUsecase(
            month: any(named: 'month'),
            recentLimit: any(named: 'recentLimit'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((invocation) async {
        final m = invocation.namedArguments[#month] as DateTime;
        return fakeData(month: m);
      });

      return DashboardCubit(getDashboardData: mockUsecase);
    },
    act: (cubit) => cubit.load(month: DateTime(2026, 1, 15), recentLimit: 3),
    expect: () => [
      isA<DashboardState>()
          .having((s) => s.isLoading, 'isLoading', true)
          .having((s) => s.error, 'error', isNull)
          .having((s) => s.month, 'month', DateTime(2026, 1, 1)),
      isA<DashboardState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.error, 'error', isNull)
          .having((s) => s.data, 'data', isNotNull)
          .having((s) => s.month, 'month', DateTime(2026, 1, 1)),
    ],
    verify: (_) {
      verify(() => mockUsecase(month: DateTime(2026, 1, 1), recentLimit: 3, cancelToken: any(named: 'cancelToken')))
          .called(1);
      verifyNoMoreInteractions(mockUsecase);
    },
  );

  blocTest<DashboardCubit, DashboardState>(
    'load() error emits loading then error',
    build: () {
      when(() => mockUsecase(
            month: any(named: 'month'),
            recentLimit: any(named: 'recentLimit'),
            cancelToken: any(named: 'cancelToken'),
          )).thenThrow(Exception('boom'));

      return DashboardCubit(getDashboardData: mockUsecase);
    },
    act: (cubit) => cubit.load(month: DateTime(2026, 1, 20), recentLimit: 3),
    expect: () => [
      isA<DashboardState>()
          .having((s) => s.isLoading, 'isLoading', true)
          .having((s) => s.error, 'error', isNull)
          .having((s) => s.month, 'month', DateTime(2026, 1, 1)),
      isA<DashboardState>()
          .having((s) => s.isLoading, 'isLoading', false)
          .having((s) => s.data, 'data', isNull)
          .having((s) => s.error, 'error', contains('boom')),
    ],
  );

  blocTest<DashboardCubit, DashboardState>(
    'prevMonth() loads previous month (normalized to first day)',
    build: () {
      when(() => mockUsecase(
            month: any(named: 'month'),
            recentLimit: any(named: 'recentLimit'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => fakeData(month: DateTime(2026, 1, 1)));

      final cubit = DashboardCubit(getDashboardData: mockUsecase);
      // set current month = Feb 2026 (first day)
      return cubit..emit(cubit.state.copyWith(month: DateTime(2026, 2, 1)));
    },
    act: (cubit) => cubit.prevMonth(recentLimit: 3),
    verify: (_) {
      verify(() => mockUsecase(month: DateTime(2026, 1, 1), recentLimit: 3, cancelToken: any(named: 'cancelToken')))
          .called(1);
    },
  );

  blocTest<DashboardCubit, DashboardState>(
    'nextMonth() loads next month (normalized to first day)',
    build: () {
      when(() => mockUsecase(
            month: any(named: 'month'),
            recentLimit: any(named: 'recentLimit'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => fakeData(month: DateTime(2026, 2, 1)));

      final cubit = DashboardCubit(getDashboardData: mockUsecase);
      return cubit..emit(cubit.state.copyWith(month: DateTime(2026, 1, 1)));
    },
    act: (cubit) => cubit.nextMonth(recentLimit: 3),
    verify: (_) {
      verify(() => mockUsecase(month: DateTime(2026, 2, 1), recentLimit: 3, cancelToken: any(named: 'cancelToken')))
          .called(1);
    },
  );

  blocTest<DashboardCubit, DashboardState>(
    'refresh() forces load even if isLoading=true',
    build: () {
      when(() => mockUsecase(
            month: any(named: 'month'),
            recentLimit: any(named: 'recentLimit'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => fakeData(month: DateTime(2026, 1, 1)));

      final cubit = DashboardCubit(getDashboardData: mockUsecase);
      return cubit
        ..emit(cubit.state.copyWith(
          isLoading: true,
          month: DateTime(2026, 1, 1),
        ));
    },
    act: (cubit) => cubit.refresh(recentLimit: 3),
    verify: (_) {
      verify(() => mockUsecase(month: DateTime(2026, 1, 1), recentLimit: 3, cancelToken: any(named: 'cancelToken')))
          .called(1);
    },
  );
}
