import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/pages/add_transaction_screen.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_state.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';

class MockAddTransactionCubit extends MockCubit<AddTransactionState>
    implements AddTransactionCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class _FakeRoute extends Fake implements Route<dynamic> {}

Future<void> _stablePump(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _pumpFor(
  WidgetTester tester,
  Duration duration, {
  Duration step = const Duration(milliseconds: 50),
}) async {
  var elapsed = Duration.zero;
  while (elapsed < duration) {
    await tester.pump(step);
    elapsed += step;
  }
}

Future<void> _safeTapFirst(
  WidgetTester tester,
  Finder finder, {
  required String reason,
}) async {
  if (finder.evaluate().isEmpty) {
    fail('Cannot tap ($reason). Finder not found: $finder');
  }
  await tester.ensureVisible(finder.first);
  await tester.tap(finder.first);
  await tester.pump();
}

Finder _titleFinder() {
  final t1 = find.text('Add Transaction');
  if (t1.evaluate().isNotEmpty) return t1;
  return find.text('Add transaction');
}

Finder _addCtaFinder() => find.text('Add').hitTestable();

class _HostPushScreen extends StatelessWidget {
  const _HostPushScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          key: const Key('open-add-transaction'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => child),
          ),
          child: const Text('Open'),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAddTransactionCubit cubit;
  late MockNavigatorObserver navObserver;

  const incomeCat = CategoryEntity(
    id: 1,
    name: 'Salary',
    type: TransactionType.income,
    icon: 'salary',
  );

  setUpAll(() {
    registerFallbackValue(_FakeRoute());
    registerFallbackValue(AddTransactionState.initial());
    registerFallbackValue(
      TransactionEntity(
        userId: 'u1',
        categoryId: 1,
        type: TransactionType.expense,
        amount: 10,
        date: DateTime(2025, 1, 1),
        note: null,
      ),
    );
  });

  setUp(() {
    cubit = MockAddTransactionCubit();
    navObserver = MockNavigatorObserver();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    required AddTransactionState state,
    Stream<AddTransactionState>? stream,
    bool pushRoute = false,
  }) async {
    when(() => cubit.state).thenReturn(state);
    whenListen<AddTransactionState>(
      cubit,
      stream ?? const Stream<AddTransactionState>.empty(),
      initialState: state,
    );

    final screen = BlocProvider<AddTransactionCubit>.value(
      value: cubit,
      child: const AddTransactionScreen(),
    );

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [navObserver],
        home: pushRoute ? _HostPushScreen(child: screen) : screen,
      ),
    );

    await _stablePump(tester);

    if (pushRoute) {
      await tester.tap(find.byKey(const Key('open-add-transaction')));
      await tester.pump();
      await _stablePump(tester);
      expect(_titleFinder(), findsOneWidget);
    }
  }

  group('AddTransactionScreen (NEW UI) - rendering', () {
    testWidgets('renders title and Add CTA label', (tester) async {
      await pumpScreen(tester, state: AddTransactionState.initial());
      expect(_titleFinder(), findsOneWidget);
      expect(find.text('Add'), findsWidgets);
    });

    testWidgets('shows linear progress when loading', (tester) async {
      final s = AddTransactionState.initial().copyWith(isLoading: true);
      await pumpScreen(tester, state: s);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });

  group('AddTransactionScreen (NEW UI) - snackbar', () {
    testWidgets('shows SnackBar when state.error is set', (tester) async {
      final s0 = AddTransactionState.initial();
      final s1 = s0.copyWith(error: 'Boom');

      await pumpScreen(
        tester,
        state: s0,
        stream: Stream<AddTransactionState>.fromIterable([s1]),
      );

      await _pumpFor(tester, const Duration(milliseconds: 300));

      final snackBars = find.byType(SnackBar);
      expect(snackBars, findsWidgets);

      expect(
        find.descendant(of: snackBars, matching: find.text('Boom')),
        findsAtLeastNWidgets(1),
      );
    });
  });

  group('AddTransactionScreen (NEW UI) - submit flow', () {
    testWidgets(
      'when submit returns false -> does NOT pop',
      (tester) async {
        final canSubmitState = AddTransactionState.initial().copyWith(
          category: incomeCat,
          amount: 100,
        );

        when(() => cubit.submit()).thenAnswer((_) async => false);

        await pumpScreen(
          tester,
          state: canSubmitState,
          pushRoute: true,
        );

        final cta = _addCtaFinder();
        expect(cta, findsWidgets);

        await _safeTapFirst(tester, cta, reason: 'Tap Add CTA');
        await _pumpFor(tester, const Duration(milliseconds: 300));

        verify(() => cubit.submit()).called(1);
        verifyNever(() => navObserver.didPop(any(), any()));
      },
    );

    testWidgets(
      'when cannot submit -> tapping should NOT call submit and should NOT pop',
      (tester) async {
        final cannotSubmitState = AddTransactionState.initial();

        when(() => cubit.submit()).thenAnswer((_) async => true);

        await pumpScreen(
          tester,
          state: cannotSubmitState,
          pushRoute: true,
        );

        final cta = _addCtaFinder();
        if (cta.evaluate().isNotEmpty) {
          await _safeTapFirst(
            tester,
            cta,
            reason: 'Tap Add CTA (should be disabled)',
          );
          await _pumpFor(tester, const Duration(milliseconds: 200));
        }

        verifyNever(() => cubit.submit());
        verifyNever(() => navObserver.didPop(any(), any()));
      },
    );
  });
}
