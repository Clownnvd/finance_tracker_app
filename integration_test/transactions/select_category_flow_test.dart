import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:finance_tracker_app/main.dart' as app;
import 'package:finance_tracker_app/core/constants/strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Wait real time + pump frames.
  Future<void> pumpFor(
    WidgetTester tester,
    Duration duration, {
    Duration step = const Duration(milliseconds: 100),
  }) async {
    var elapsed = Duration.zero;
    while (elapsed < duration) {
      await tester.pump(step);
      elapsed += step;
    }
  }

  // Wait until a widget appears (polling).
  Future<void> waitFor(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    Duration step = const Duration(milliseconds: 100),
  }) async {
    var elapsed = Duration.zero;
    while (elapsed < timeout) {
      await tester.pump(step);
      if (finder.evaluate().isNotEmpty) return;
      elapsed += step;
    }
    fail('Timeout waiting for: $finder');
  }

  // Wait until a widget disappears (polling).
  Future<void> waitUntilGone(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    Duration step = const Duration(milliseconds: 100),
  }) async {
    var elapsed = Duration.zero;
    while (elapsed < timeout) {
      await tester.pump(step);
      if (finder.evaluate().isEmpty) return;
      elapsed += step;
    }
    fail('Timeout waiting for widget to disappear: $finder');
  }

  Finder findGetStartedButton() =>
      find.widgetWithText(ElevatedButton, 'Get Started').hitTestable();

  Finder findLoginButton() =>
      find.widgetWithText(ElevatedButton, AppStrings.login).hitTestable();

  Finder findEmailField() => find.byType(TextFormField).at(0);
  Finder findPasswordField() => find.byType(TextFormField).at(1);

  // -------------------------
  // Dashboard -> Add Transaction
  // -------------------------
  Finder findAddTransactionEntry() {
    // 1) FAB
    final fab = find.byType(FloatingActionButton).hitTestable();
    if (fab.evaluate().isNotEmpty) return fab;

    // 2) common add icons
    final add = find.byIcon(Icons.add).hitTestable();
    if (add.evaluate().isNotEmpty) return add;

    final addCircle = find.byIcon(Icons.add_circle).hitTestable();
    if (addCircle.evaluate().isNotEmpty) return addCircle;

    // 3) text buttons
    final addText = find.textContaining('Add').hitTestable();
    if (addText.evaluate().isNotEmpty) return addText;

    // 4) tooltip
    final tip = find.byTooltip('Add').hitTestable();
    if (tip.evaluate().isNotEmpty) return tip;

    return fab; // will fail later with clearer error
  }

  // -------------------------
  // AddTransactionScreen anchors
  // -------------------------
  Finder findAddTransactionTitle() => find.text('Add transaction');

  // Your screen uses custom fields; easiest is to target TextField/TextFormField in that screen.
  Finder findAmountInput() {
    final tf = find.byType(TextField);
    if (tf.evaluate().isNotEmpty) return tf.first;

    final tff = find.byType(TextFormField);
    if (tff.evaluate().isNotEmpty) return tff.first;

    return tf.first;
  }

  Finder findNoteInput() {
    final tf = find.byType(TextField);
    if (tf.evaluate().isNotEmpty) return tf.last;

    final tff = find.byType(TextFormField);
    if (tff.evaluate().isNotEmpty) return tff.last;

    return tf.last;
  }

  Finder findCategoryFieldTap() {
    // CategoryField thường có chữ "Category" hoặc "Select"
    final byLabel = find.textContaining('Category').hitTestable();
    if (byLabel.evaluate().isNotEmpty) return byLabel;

    final bySelect = find.textContaining('Select').hitTestable();
    if (bySelect.evaluate().isNotEmpty) return bySelect;

    // fallback: tap first InkWell/ListTile after amount
    final tiles = find.byType(ListTile).hitTestable();
    if (tiles.evaluate().isNotEmpty) return tiles.first;

    final inkwell = find.byType(InkWell).hitTestable();
    if (inkwell.evaluate().isNotEmpty) return inkwell.first;

    return byLabel;
  }

  Finder findSaveButton() =>
      find.widgetWithText(ElevatedButton, 'Save').hitTestable();

  // -------------------------
  // SelectCategoryScreen anchors
  // -------------------------
  Finder findSelectCategoryTitle() => find.text('Select category');

  Future<void> pickCategory(WidgetTester tester) async {
    // ưu tiên các name bạn hay có trong seed
    final candidates = <Finder>[
      find.text('Food').hitTestable(),
      find.text('Salary').hitTestable(),
      find.textContaining('Food').hitTestable(),
      find.textContaining('Salary').hitTestable(),
      find.text('EXPENSE').hitTestable(),
      find.text('INCOME').hitTestable(),
    ];

    for (final f in candidates) {
      if (f.evaluate().isNotEmpty) {
        await tester.tap(f.first);
        await tester.pump();
        await pumpFor(tester, const Duration(milliseconds: 400));
        return;
      }
    }

    // fallback: tap first ListTile item
    final tiles = find.byType(ListTile).hitTestable();
    if (tiles.evaluate().isNotEmpty) {
      await tester.tap(tiles.first);
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 400));
      return;
    }

    fail('No category item found to tap.');
  }

  group('App flow: Get Started -> Login -> Dashboard -> Add Transaction', () {
    testWidgets('should add transaction using SelectCategoryScreen and return dashboard', (tester) async {
      // Start app
      app.main();

      // Boot time
      await pumpFor(tester, const Duration(seconds: 2));

      // Tap Get Started if exists
      final getStarted = findGetStartedButton();
      if (getStarted.evaluate().isNotEmpty) {
        await tester.tap(getStarted);
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 1));
      }

      // Wait login ready
      await waitFor(tester, findLoginButton(), timeout: const Duration(seconds: 15));

      // Fill login
      await tester.tap(findEmailField());
      await tester.pump();
      await tester.enterText(findEmailField(), 'Kingpro2@gmail.com');
      await pumpFor(tester, const Duration(milliseconds: 300));

      await tester.tap(findPasswordField());
      await tester.pump();
      await tester.enterText(findPasswordField(), 'Kingpro2@gmail.com');
      await pumpFor(tester, const Duration(milliseconds: 300));

      // Login
      await tester.ensureVisible(findLoginButton());
      await tester.tap(findLoginButton());
      await tester.pump();

      // Wait Dashboard
      await waitFor(tester, find.text('Dashboard'), timeout: const Duration(seconds: 30));
      await pumpFor(tester, const Duration(seconds: 1));

      // Optional: wait dashboard loading gone
      final dashLoading = find.byType(LinearProgressIndicator);
      if (dashLoading.evaluate().isNotEmpty) {
        await waitUntilGone(tester, dashLoading, timeout: const Duration(seconds: 20));
      }

      // -------------------------
      // Open AddTransactionScreen
      // -------------------------
      final addEntry = findAddTransactionEntry();
      await tester.ensureVisible(addEntry);
      await tester.tap(addEntry);
      await tester.pump();

      await waitFor(tester, findAddTransactionTitle(), timeout: const Duration(seconds: 15));
      await pumpFor(tester, const Duration(milliseconds: 500));

      // Fill amount
      final amount = findAmountInput();
      if (amount.evaluate().isNotEmpty) {
        await tester.tap(amount);
        await tester.pump();
        await tester.enterText(amount, '120000');
        await pumpFor(tester, const Duration(milliseconds: 400));
      }

      // Open SelectCategoryScreen
      final categoryTap = findCategoryFieldTap();
      await tester.ensureVisible(categoryTap);
      await tester.tap(categoryTap);
      await tester.pump();

      // Wait select category
      await waitFor(tester, findSelectCategoryTitle(), timeout: const Duration(seconds: 15));
      await pumpFor(tester, const Duration(milliseconds: 300));

      // If loading circle present, wait it gone
      final loadingCircle = find.byType(CircularProgressIndicator);
      if (loadingCircle.evaluate().isNotEmpty) {
        await waitUntilGone(tester, loadingCircle, timeout: const Duration(seconds: 20));
      }

      // Pick category item (this will pop back to AddTransactionScreen)
      await pickCategory(tester);

      // Back to AddTransactionScreen
      await waitFor(tester, findAddTransactionTitle(), timeout: const Duration(seconds: 15));
      await pumpFor(tester, const Duration(milliseconds: 400));

      // Fill note
      final note = findNoteInput();
      if (note.evaluate().isNotEmpty) {
        await tester.tap(note);
        await tester.pump();
        await tester.enterText(note, 'Added from integration test');
        await pumpFor(tester, const Duration(milliseconds: 400));
      }

      // Save
      await tester.ensureVisible(findSaveButton());
      await tester.tap(findSaveButton());
      await tester.pump();

      // Wait saving overlay if any
      final savingBar = find.byType(LinearProgressIndicator);
      if (savingBar.evaluate().isNotEmpty) {
        await waitUntilGone(tester, savingBar, timeout: const Duration(seconds: 25));
      }

      // Success snackbar on AddTransactionScreen
      await waitFor(
        tester,
        find.text('Transaction added'),
        timeout: const Duration(seconds: 20),
      );

      // It should pop back to Dashboard after success in your screen code
      await waitFor(
        tester,
        find.text('Dashboard'),
        timeout: const Duration(seconds: 20),
      );

      // Basic dashboard anchors
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Recent Transactions'), findsOneWidget);
    });
  });
}
