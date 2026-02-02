import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/budgets/domain/entities/budget.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/cubit/budgets_cubit.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/cubit/budgets_state.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/pages/set_budget_screen.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/widgets/budget_amount_display.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/widgets/budget_amount_input.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/widgets/budget_category_picker.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/widgets/budget_month_picker.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';

class MockBudgetsCubit extends MockCubit<BudgetsState> implements BudgetsCubit {}

class _FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockBudgetsCubit mockCubit;

  setUpAll(() {
    registerFallbackValue(_FakeRoute());
    registerFallbackValue(BudgetsState.initial());
  });

  setUp(() {
    mockCubit = MockBudgetsCubit();
  });

  tearDown(() async {
    await mockCubit.close();
  });

  Future<void> stablePump(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
  }

  Future<void> pumpFor(
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

  Widget buildTestApp({
    BudgetsState? state,
    Stream<BudgetsState>? stream,
    CategoryEntity? categoryToReturn,
  }) {
    final initialState = state ?? BudgetsState.initial().copyWith(isLoading: false);

    when(() => mockCubit.state).thenReturn(initialState);
    whenListen<BudgetsState>(
      mockCubit,
      stream ?? const Stream<BudgetsState>.empty(),
      initialState: initialState,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRouter.navigatorKey,
      theme: AppTheme.light,
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.selectCategory) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    AppRouter.navigatorKey.currentContext!,
                    categoryToReturn,
                  );
                },
                child: const Text('Select Category'),
              ),
            ),
            settings: settings,
          );
        }
        return null;
      },
      home: BlocProvider<BudgetsCubit>.value(
        value: mockCubit,
        child: const SetBudgetScreen(),
      ),
    );
  }

  group('SetBudgetScreen', () {
    testWidgets('renders all required widgets', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await stablePump(tester);

      expect(find.text('Set Budget'), findsOneWidget);
      expect(find.byType(BudgetAmountDisplay), findsOneWidget);
      expect(find.byType(BudgetCategoryPicker), findsOneWidget);
      expect(find.byType(BudgetAmountInput), findsOneWidget);
      expect(find.byType(BudgetMonthPicker), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    });

    testWidgets('displays initial amount as \$0', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await stablePump(tester);

      expect(find.text('\$0'), findsOneWidget);
    });

    testWidgets('displays "Select category" when no category selected',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await stablePump(tester);

      expect(find.text('Select category'), findsOneWidget);
    });

    testWidgets('updates amount display when entering amount', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await stablePump(tester);

      final amountInput = find.byType(TextField);
      await tester.enterText(amountInput, '2500');
      await tester.pump();

      expect(find.text('\$2,500'), findsOneWidget);
    });

    testWidgets('navigates to select category and updates UI when category selected',
        (tester) async {
      final testCategory = const CategoryEntity(
        id: 5,
        name: 'Food',
        type: TransactionType.expense,
        icon: 'food',
      );

      await tester.pumpWidget(buildTestApp(categoryToReturn: testCategory));
      await stablePump(tester);

      // Tap on category picker
      await tester.tap(find.byType(BudgetCategoryPicker));
      await tester.pumpAndSettle();

      // Select category from mock screen
      await tester.tap(find.text('Select Category'));
      await tester.pumpAndSettle();

      // Should show category name
      expect(find.text('Food'), findsOneWidget);
    });

    testWidgets('shows validation error when saving without category',
        (tester) async {
      await tester.pumpWidget(buildTestApp());
      await stablePump(tester);

      // Enter amount
      final amountInput = find.byType(TextField);
      await tester.enterText(amountInput, '1000');
      await tester.pump();

      // Tap save without selecting category
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await pumpFor(tester, const Duration(milliseconds: 300));

      // Should show error snackbar
      expect(find.text('Please select a category.'), findsOneWidget);
    });

    testWidgets('shows validation error when saving with zero amount',
        (tester) async {
      final testCategory = const CategoryEntity(
        id: 5,
        name: 'Food',
        type: TransactionType.expense,
        icon: 'food',
      );

      await tester.pumpWidget(buildTestApp(categoryToReturn: testCategory));
      await stablePump(tester);

      // Select category
      await tester.tap(find.byType(BudgetCategoryPicker));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select Category'));
      await tester.pumpAndSettle();

      // Tap save without entering amount
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await pumpFor(tester, const Duration(milliseconds: 300));

      // Should show error snackbar
      expect(find.text('Amount must be greater than 0.'), findsOneWidget);
    });

    testWidgets('calls createOrUpdate when form is valid', (tester) async {
      when(() => mockCubit.createOrUpdate(
            categoryId: any(named: 'categoryId'),
            amount: any(named: 'amount'),
            month: any(named: 'month'),
          )).thenAnswer((_) async {});

      final testCategory = const CategoryEntity(
        id: 5,
        name: 'Food',
        type: TransactionType.expense,
        icon: 'food',
      );

      await tester.pumpWidget(buildTestApp(categoryToReturn: testCategory));
      await stablePump(tester);

      // Select category
      await tester.tap(find.byType(BudgetCategoryPicker));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select Category'));
      await tester.pumpAndSettle();

      // Enter amount
      final amountInput = find.byType(TextField);
      await tester.enterText(amountInput, '1000');
      await tester.pump();

      // Tap save
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump();

      verify(() => mockCubit.createOrUpdate(
            categoryId: 5,
            amount: 1000,
            month: any(named: 'month'),
          )).called(1);
    });

    testWidgets('shows loading indicator when saving', (tester) async {
      final savingState = BudgetsState.initial().copyWith(
        isLoading: false,
        isSaving: true,
      );

      await tester.pumpWidget(buildTestApp(state: savingState));
      await stablePump(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('disables save button when saving', (tester) async {
      final savingState = BudgetsState.initial().copyWith(
        isLoading: false,
        isSaving: true,
      );

      await tester.pumpWidget(buildTestApp(state: savingState));
      await stablePump(tester);

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton).last,
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shows success snackbar when budget saved', (tester) async {
      final controller = StreamController<BudgetsState>();

      when(() => mockCubit.clearLastSaved()).thenReturn(null);

      await tester.pumpWidget(buildTestApp(
        state: BudgetsState.initial().copyWith(isLoading: false),
        stream: controller.stream,
      ));
      await stablePump(tester);

      // Emit state with lastCreatedOrUpdated
      controller.add(BudgetsState.initial().copyWith(
        isLoading: false,
        isSaving: false,
        lastCreatedOrUpdated: const Budget(
          id: 1,
          userId: 'user-1',
          categoryId: 5,
          amount: 1000,
          month: 1,
        ),
      ));

      await pumpFor(tester, const Duration(milliseconds: 300));

      expect(find.text('Budget saved successfully!'), findsOneWidget);

      await controller.close();
    });

    testWidgets('shows error snackbar when error occurs', (tester) async {
      final controller = StreamController<BudgetsState>();

      await tester.pumpWidget(buildTestApp(
        state: BudgetsState.initial().copyWith(isLoading: false),
        stream: controller.stream,
      ));
      await stablePump(tester);

      // Emit state with error
      controller.add(BudgetsState.initial().copyWith(
        isLoading: false,
        isSaving: false,
        errorMessage: 'Failed to save budget',
      ));

      await pumpFor(tester, const Duration(milliseconds: 300));

      expect(find.text('Failed to save budget'), findsOneWidget);

      await controller.close();
    });

    testWidgets('month picker changes selected month', (tester) async {
      await tester.pumpWidget(buildTestApp());
      await stablePump(tester);

      // Find and tap month dropdown
      final dropdown = find.byType(DropdownButton<int>);
      expect(dropdown, findsOneWidget);

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Select different month (e.g., June)
      await tester.tap(find.text('June').last);
      await tester.pumpAndSettle();

      // Month should be updated (verify via UI if visible or cubit call)
      expect(find.text('June'), findsOneWidget);
    });
  });
}
