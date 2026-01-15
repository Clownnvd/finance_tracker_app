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

  // -------------------------
  // Existing finders (your flow)
  // -------------------------
  Finder findGetStartedButton() =>
      find.widgetWithText(ElevatedButton, 'Get Started').hitTestable();

  Finder findLoginButton() =>
      find.widgetWithText(ElevatedButton, AppStrings.login).hitTestable();

  Finder findEmailField() => find.byType(TextFormField).at(0);
  Finder findPasswordField() => find.byType(TextFormField).at(1);

  // -------------------------
  // NEW: Dashboard -> Add Transaction finders (flexible)
  // -------------------------
  Finder findAddTransactionEntry() {
    // Try common patterns in priority order
    final fab = find.byType(FloatingActionButton).hitTestable();
    if (fab.evaluate().isNotEmpty) return fab;

    final addIcon = find.byIcon(Icons.add).hitTestable();
    if (addIcon.evaluate().isNotEmpty) return addIcon;

    final addCircle = find.byIcon(Icons.add_circle).hitTestable();
    if (addCircle.evaluate().isNotEmpty) return addCircle;

    final addTextBtn = find.textContaining('Add').hitTestable();
    if (addTextBtn.evaluate().isNotEmpty) return addTextBtn;

    final plusTooltip = find.byTooltip('Add').hitTestable();
    if (plusTooltip.evaluate().isNotEmpty) return plusTooltip;

    // Fallback: return fab anyway (will fail later with clearer error)
    return fab;
  }

  // AddTransactionScreen anchors
  Finder findAddTransactionTitle() => find.text('Add transaction');
  Finder findSaveButton() =>
      find.widgetWithText(ElevatedButton, 'Save').hitTestable();

  // AmountField/NoteField are custom. We can still type into the first
  // editable text fields on the screen.
  Finder findAmountInputAny() => find.byType(TextField).at(0);
  Finder findNoteInputAny() => find.byType(TextField).last;

  // Category field: often ListTile / InkWell / GestureDetector
  Finder findCategoryTapTarget() {
    // Try common text labels
    final byText = find.textContaining('Category').hitTestable();
    if (byText.evaluate().isNotEmpty) return byText;

    // Common icon
    final byIcon = find.byIcon(Icons.category).hitTestable();
    if (byIcon.evaluate().isNotEmpty) return byIcon;

    // Fallback: tap the first ListTile-ish thing after Amount
    final tile = find.byType(InkWell).hitTestable();
    if (tile.evaluate().isNotEmpty) return tile.first;

    return byText;
  }

  // On SelectCategory screen: choose an item
  Future<void> pickAnyCategory(WidgetTester tester) async {
    // Prefer common category names if present
    final preferred = <Finder>[
      find.textContaining('Salary').hitTestable(),
      find.textContaining('Food').hitTestable(),
      find.textContaining('Income').hitTestable(),
      find.textContaining('Expense').hitTestable(),
      find.textContaining('INCOME').hitTestable(),
      find.textContaining('EXPENSE').hitTestable(),
    ];

    for (final f in preferred) {
      if (f.evaluate().isNotEmpty) {
        await tester.tap(f.first);
        await tester.pump();
        await pumpFor(tester, const Duration(milliseconds: 400));
        return;
      }
    }

    // Fallback: tap first ListTile
    final tiles = find.byType(ListTile).hitTestable();
    if (tiles.evaluate().isNotEmpty) {
      await tester.tap(tiles.first);
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 400));
      return;
    }

    // Fallback: tap first tappable text
    final anyText = find.byType(Text).hitTestable();
    if (anyText.evaluate().isNotEmpty) {
      await tester.tap(anyText.first);
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 400));
      return;
    }

    fail('Could not find any category item to tap on SelectCategory screen.');
  }

  group('App flow: Get Started -> Login -> Dashboard -> Add Transaction', () {
    testWidgets('should add a transaction and return to dashboard', (tester) async {
      // Start app
      app.main();

      // boot
      await pumpFor(tester, const Duration(seconds: 2));

      // Tap Get Started if exists
      final getStarted = findGetStartedButton();
      if (getStarted.evaluate().isNotEmpty) {
        await tester.tap(getStarted);
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 1));
      }

      // Wait Login ready
      await waitFor(tester, findLoginButton(), timeout: const Duration(seconds: 15));

      // Enter credentials
      await tester.tap(findEmailField());
      await tester.pump();
      await tester.enterText(findEmailField(), 'Kingpro2@gmail.com');
      await pumpFor(tester, const Duration(milliseconds: 300));

      await tester.tap(findPasswordField());
      await tester.pump();
      await tester.enterText(findPasswordField(), 'Kingpro2@gmail.com');
      await pumpFor(tester, const Duration(milliseconds: 300));

      // Tap Login
      await tester.ensureVisible(findLoginButton());
      await tester.tap(findLoginButton());
      await tester.pump();

      // Wait for Dashboard
      await waitFor(tester, find.text('Dashboard'), timeout: const Duration(seconds: 30));
      await pumpFor(tester, const Duration(seconds: 1));

      // Optional: wait loading bar gone
      final loadingBar = find.byType(LinearProgressIndicator);
      if (loadingBar.evaluate().isNotEmpty) {
        await waitUntilGone(tester, loadingBar, timeout: const Duration(seconds: 20));
      }

      // -------------------------
      // NEW: Navigate to Add Transaction
      // -------------------------
      final addEntry = findAddTransactionEntry();
      await tester.ensureVisible(addEntry);
      await tester.tap(addEntry);
      await tester.pump();

      // Wait AddTransaction screen
      await waitFor(tester, findAddTransactionTitle(), timeout: const Duration(seconds: 15));
      await pumpFor(tester, const Duration(milliseconds: 400));

      // Fill amount (best-effort: first TextField)
      final amountField = findAmountInputAny();
      if (amountField.evaluate().isNotEmpty) {
        await tester.tap(amountField);
        await tester.pump();
        await tester.enterText(amountField, '120000');
        await pumpFor(tester, const Duration(milliseconds: 300));
      }

      // Open category picker
      final catTap = findCategoryTapTarget();
      await tester.ensureVisible(catTap);
      await tester.tap(catTap);
      await tester.pump();

      // Pick a category on the next screen (or bottom sheet)
      await pumpFor(tester, const Duration(milliseconds: 500));
      await pickAnyCategory(tester);

      // Back on AddTransactionScreen (wait title again)
      await waitFor(tester, findAddTransactionTitle(), timeout: const Duration(seconds: 10));
      await pumpFor(tester, const Duration(milliseconds: 300));

      // Fill note (best-effort: last TextField)
      final noteField = findNoteInputAny();
      if (noteField.evaluate().isNotEmpty) {
        await tester.tap(noteField);
        await tester.pump();
        await tester.enterText(noteField, 'Integration test note');
        await pumpFor(tester, const Duration(milliseconds: 300));
      }

      // Save
      await tester.ensureVisible(findSaveButton());
      await tester.tap(findSaveButton());
      await tester.pump();

      // If screen shows loading overlay, wait it out
      final savingBar = find.byType(LinearProgressIndicator);
      if (savingBar.evaluate().isNotEmpty) {
        await waitUntilGone(tester, savingBar, timeout: const Duration(seconds: 20));
      }

      // Expect success snackbar
      await waitFor(
        tester,
        find.text('Transaction added'),
        timeout: const Duration(seconds: 15),
      );

      // After success, screen pops back to previous (dashboard)
      await waitFor(
        tester,
        find.text('Dashboard'),
        timeout: const Duration(seconds: 15),
      );

      // Optional: dashboard anchors still exist
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
