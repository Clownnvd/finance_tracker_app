// integration_test/app_flow_add_transaction_test.dart
//
// FULL FILE
// Keeps your original flow (Get Started -> Login -> Dashboard),
// but FIXES ONLY the Dashboard -> Add Transaction part to match NEW UI:
//
// - Title: "Add Transaction"
// - CTA button: "Add" (NOT ElevatedButton)
// - Category picker is tappable via "Category" label / selected name / first InkWell
//
// Also fixes the crash: StateError (Bad state: No element)
// by never calling ensureVisible/tap on a Finder with 0 elements.

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

  // Tap a finder safely (requires it exists).
  Future<void> safeTapFirst(
    WidgetTester tester,
    Finder finder, {
    String? reason,
  }) async {
    expect(
      finder,
      findsWidgets,
      reason: reason ?? 'Expected widget to exist before tap.',
    );

    await tester.ensureVisible(finder.first);
    await tester.tap(finder.first);
    await tester.pump();
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
  // Dashboard -> Add Transaction entry (flexible)
  // -------------------------
  Finder findAddTransactionEntry() {
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

    return fab;
  }

  // -------------------------
  // UPDATED: AddTransactionScreen anchors for NEW UI
  // -------------------------
  Finder findAddTransactionTitle() => find.text('Add Transaction');

  // NEW UI: button might be InkWell/GestureDetector/Container, not ElevatedButton.
  Finder findAddButton() {
    // 1) prefer tapping the "Add" text itself (most stable)
    final byText = find.text('Add').hitTestable();
    if (byText.evaluate().isNotEmpty) return byText;

    // 2) fallback to common tappables
    final inkwell = find.byType(InkWell).hitTestable();
    if (inkwell.evaluate().isNotEmpty) return inkwell.last;

    final gesture = find.byType(GestureDetector).hitTestable();
    if (gesture.evaluate().isNotEmpty) return gesture.last;

    final container = find.byType(Container).hitTestable();
    if (container.evaluate().isNotEmpty) return container.last;

    // fallback: will fail with a clear message in safeTapFirst
    return byText;
  }

  // Amount/Note: still TextField in your codebase.
  Finder findAmountInputAny() => find.byType(TextField).at(0);
  Finder findNoteInputAny() => find.byType(TextField).last;

  // Category field: new UI shows a "Category" label and a selectable row
  Finder findCategoryTapTarget() {
    // Try tapping on selected name (e.g. Housing) if already set
    final housing = find.text('Housing').hitTestable();
    if (housing.evaluate().isNotEmpty) return housing;

    // Try common placeholder if your UI uses it anywhere
    final select = find.text('Select category').hitTestable();
    if (select.evaluate().isNotEmpty) return select;

    // Try label "Category" and then nearest InkWell
    final label = find.text('Category');
    if (label.evaluate().isNotEmpty) {
      final inkwells = find.byType(InkWell).hitTestable();
      if (inkwells.evaluate().isNotEmpty) return inkwells.first;
    }

    // Fallback: first InkWell on the screen
    final inkwells = find.byType(InkWell).hitTestable();
    if (inkwells.evaluate().isNotEmpty) return inkwells.first;

    // fallback
    return find.text('Category').hitTestable();
  }

  // On SelectCategory screen: choose an item
  Future<void> pickAnyCategory(WidgetTester tester) async {
    final preferred = <Finder>[
      find.text('Housing').hitTestable(),
      find.text('Food').hitTestable(),
      find.text('Shopping').hitTestable(),
      find.text('Salary').hitTestable(),
      find.text('Freelance').hitTestable(),
      find.text('Investments').hitTestable(),
      find.text('Other').hitTestable(),
    ];

    for (final f in preferred) {
      if (f.evaluate().isNotEmpty) {
        await safeTapFirst(tester, f, reason: 'Pick category item');
        await pumpFor(tester, const Duration(milliseconds: 400));
        return;
      }
    }

    final tiles = find.byType(InkWell).hitTestable();
    if (tiles.evaluate().isNotEmpty) {
      await safeTapFirst(tester, tiles, reason: 'Pick first InkWell category');
      await pumpFor(tester, const Duration(milliseconds: 400));
      return;
    }

    final anyText = find.byType(Text).hitTestable();
    if (anyText.evaluate().isNotEmpty) {
      await safeTapFirst(tester, anyText, reason: 'Pick first tappable text');
      await pumpFor(tester, const Duration(milliseconds: 400));
      return;
    }

    fail('Could not find any category item to tap on SelectCategory screen.');
  }

  group('App flow: Get Started -> Login -> Dashboard -> Add Transaction', () {
    testWidgets('should add a transaction and return to dashboard',
        (tester) async {
      // Start app
      app.main();

      // boot
      await pumpFor(tester, const Duration(seconds: 2));

      // Tap Get Started if exists
      final getStarted = findGetStartedButton();
      if (getStarted.evaluate().isNotEmpty) {
        await safeTapFirst(tester, getStarted, reason: 'Tap Get Started');
        await pumpFor(tester, const Duration(seconds: 1));
      }

      // Wait Login ready
      await waitFor(tester, findLoginButton(),
          timeout: const Duration(seconds: 15));

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
      await safeTapFirst(tester, findLoginButton(), reason: 'Tap Login');

      // Wait for Dashboard
      await waitFor(
        tester,
        find.text('Dashboard'),
        timeout: const Duration(seconds: 30),
      );
      await pumpFor(tester, const Duration(seconds: 1));

      // Optional: wait loading bar gone
      final loadingBar = find.byType(LinearProgressIndicator);
      if (loadingBar.evaluate().isNotEmpty) {
        await waitUntilGone(
          tester,
          loadingBar,
          timeout: const Duration(seconds: 20),
        );
      }

      // -------------------------
      // UPDATED: Navigate to Add Transaction (new UI)
      // -------------------------
      final addEntry = findAddTransactionEntry();
      await safeTapFirst(tester, addEntry, reason: 'Open Add Transaction');

      // Wait AddTransaction screen (new title)
      await waitFor(
        tester,
        findAddTransactionTitle(),
        timeout: const Duration(seconds: 15),
      );
      await pumpFor(tester, const Duration(milliseconds: 400));

      // Fill amount
      final amountField = findAmountInputAny();
      if (amountField.evaluate().isNotEmpty) {
        await tester.tap(amountField);
        await tester.pump();
        await tester.enterText(amountField, '2500');
        await pumpFor(tester, const Duration(milliseconds: 300));
      }

      // Open category picker
      final catTap = findCategoryTapTarget();
      await safeTapFirst(tester, catTap, reason: 'Open category picker');

      // Pick category
      await pumpFor(tester, const Duration(milliseconds: 500));
      await pickAnyCategory(tester);

      // Back on AddTransaction screen
      await waitFor(
        tester,
        findAddTransactionTitle(),
        timeout: const Duration(seconds: 10),
      );
      await pumpFor(tester, const Duration(milliseconds: 300));

      // Fill note
      final noteField = findNoteInputAny();
      if (noteField.evaluate().isNotEmpty) {
        await tester.tap(noteField);
        await tester.pump();
        await tester.enterText(noteField, 'Integration test note');
        await pumpFor(tester, const Duration(milliseconds: 300));
      }

      // Submit (new button text: Add)
      final addBtn = findAddButton();
      await safeTapFirst(tester, addBtn, reason: 'Submit Add Transaction');

      // If screen shows loading overlay, wait it out
      final savingBar = find.byType(LinearProgressIndicator);
      if (savingBar.evaluate().isNotEmpty) {
        await waitUntilGone(
          tester,
          savingBar,
          timeout: const Duration(seconds: 20),
        );
      }

      // Expect success snackbar
      await waitFor(
        tester,
        find.text(AppStrings.transactionAdded),
        timeout: const Duration(seconds: 15),
      );

      // After success, screen pops back to dashboard
      await waitFor(
        tester,
        find.text('Dashboard'),
        timeout: const Duration(seconds: 15),
      );

      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
