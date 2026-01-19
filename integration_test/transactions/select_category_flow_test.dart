import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:finance_tracker_app/main.dart' as app;
import 'package:finance_tracker_app/core/constants/strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // =========================
  // Helpers
  // =========================
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

  Future<void> safeTapFirst(
    WidgetTester tester,
    Finder finder, {
    String? reason,
  }) async {
    if (finder.evaluate().isEmpty) {
      fail(reason ?? 'Tried to tap but no widget found: $finder');
    }
    await tester.ensureVisible(finder.first);
    await tester.tap(finder.first);
    await tester.pump();
  }

  // =========================
  // Login flow finders
  // =========================
  Finder findGetStartedButton() =>
      find.widgetWithText(ElevatedButton, 'Get Started').hitTestable();

  Finder findLoginButton() =>
      find.widgetWithText(ElevatedButton, AppStrings.login).hitTestable();

  Finder findEmailField() => find.byType(TextFormField).at(0);
  Finder findPasswordField() => find.byType(TextFormField).at(1);

  // =========================
  // Dashboard -> Add Transaction entry
  // =========================
  Finder findAddTransactionEntry() {
    final fab = find.byType(FloatingActionButton).hitTestable();
    if (fab.evaluate().isNotEmpty) return fab;

    final add = find.byIcon(Icons.add).hitTestable();
    if (add.evaluate().isNotEmpty) return add;

    final addCircle = find.byIcon(Icons.add_circle).hitTestable();
    if (addCircle.evaluate().isNotEmpty) return addCircle;

    final addText = find.textContaining('Add').hitTestable();
    if (addText.evaluate().isNotEmpty) return addText;

    final tip = find.byTooltip('Add').hitTestable();
    if (tip.evaluate().isNotEmpty) return tip;

    return fab; // will fail with clear message in safeTapFirst
  }

  // =========================
  // AddTransactionScreen anchors (NEW UI)
  // =========================
  Finder findAddTransactionTitle() => find.text('Add Transaction');

  Finder findAmountInput() {
    final tf = find.byType(TextField);
    if (tf.evaluate().isNotEmpty) return tf.first;

    final tff = find.byType(TextFormField);
    if (tff.evaluate().isNotEmpty) return tff.first;

    return tf;
  }

  Finder findNoteInput() {
    final tf = find.byType(TextField);
    if (tf.evaluate().isNotEmpty) return tf.last;

    final tff = find.byType(TextFormField);
    if (tff.evaluate().isNotEmpty) return tff.last;

    return tf;
  }

  Finder findCategoryFieldTap() {
    // New UI: label "Category" and a highlighted selection row
    final housing = find.text('Housing').hitTestable();
    if (housing.evaluate().isNotEmpty) return housing;

    final select = find.text('Select category').hitTestable();
    if (select.evaluate().isNotEmpty) return select;

    final byLabel = find.text('Category');
    if (byLabel.evaluate().isNotEmpty) {
      final inkwells = find.byType(InkWell).hitTestable();
      if (inkwells.evaluate().isNotEmpty) return inkwells.first;
    }

    final inkwell = find.byType(InkWell).hitTestable();
    if (inkwell.evaluate().isNotEmpty) return inkwell.first;

    final tiles = find.byType(ListTile).hitTestable();
    if (tiles.evaluate().isNotEmpty) return tiles.first;

    return find.textContaining('Category').hitTestable();
  }

  // NEW UI: CTA button is "Add" (often not ElevatedButton)
  Finder findAddButton() {
    final byText = find.text('Add').hitTestable();
    if (byText.evaluate().isNotEmpty) return byText;

    final inkwell = find.byType(InkWell).hitTestable();
    if (inkwell.evaluate().isNotEmpty) return inkwell.last;

    final gesture = find.byType(GestureDetector).hitTestable();
    if (gesture.evaluate().isNotEmpty) return gesture.last;

    return byText;
  }

  // =========================
  // SelectCategoryScreen anchors
  // =========================
  Finder findSelectCategoryTitle() => find.text('Select category');

  Future<void> pickCategory(WidgetTester tester) async {
    final candidates = <Finder>[
      find.text('Housing').hitTestable(),
      find.text('Food').hitTestable(),
      find.text('Shopping').hitTestable(),
      find.text('Salary').hitTestable(),
      find.text('Freelance').hitTestable(),
      find.text('Investments').hitTestable(),
      find.text('Other').hitTestable(),
      find.textContaining('Food').hitTestable(),
      find.textContaining('Salary').hitTestable(),
    ];

    for (final f in candidates) {
      if (f.evaluate().isNotEmpty) {
        await safeTapFirst(tester, f, reason: 'Pick a category item');
        await pumpFor(tester, const Duration(milliseconds: 400));
        return;
      }
    }

    final tiles = find.byType(InkWell).hitTestable();
    if (tiles.evaluate().isNotEmpty) {
      await safeTapFirst(tester, tiles, reason: 'Pick first tappable category (InkWell)');
      await pumpFor(tester, const Duration(milliseconds: 400));
      return;
    }

    final listTiles = find.byType(ListTile).hitTestable();
    if (listTiles.evaluate().isNotEmpty) {
      await safeTapFirst(tester, listTiles, reason: 'Pick first tappable category (ListTile)');
      await pumpFor(tester, const Duration(milliseconds: 400));
      return;
    }

    fail('No category item found to tap.');
  }

  group('App flow: Get Started -> Login -> Dashboard -> Add Transaction', () {
    testWidgets('should add transaction using NEW Add UI and return dashboard',
        (tester) async {
      // Start app
      app.main();

      // Boot time
      await pumpFor(tester, const Duration(seconds: 2));

      // Tap Get Started if exists
      final getStarted = findGetStartedButton();
      if (getStarted.evaluate().isNotEmpty) {
        await safeTapFirst(tester, getStarted, reason: 'Tap Get Started');
        await pumpFor(tester, const Duration(seconds: 1));
      }

      // Wait login ready
      await waitFor(
        tester,
        findLoginButton(),
        timeout: const Duration(seconds: 15),
      );

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
      await safeTapFirst(tester, findLoginButton(), reason: 'Tap Login');

      // Wait Dashboard
      await waitFor(
        tester,
        find.text('Dashboard'),
        timeout: const Duration(seconds: 30),
      );
      await pumpFor(tester, const Duration(seconds: 1));

      // Optional: wait dashboard loading gone
      final dashLoading = find.byType(LinearProgressIndicator);
      if (dashLoading.evaluate().isNotEmpty) {
        await waitUntilGone(
          tester,
          dashLoading,
          timeout: const Duration(seconds: 20),
        );
      }

      // -------------------------
      // Open AddTransactionScreen (NEW UI)
      // -------------------------
      final addEntry = findAddTransactionEntry();
      await safeTapFirst(tester, addEntry, reason: 'Open Add Transaction from Dashboard');

      await waitFor(
        tester,
        findAddTransactionTitle(),
        timeout: const Duration(seconds: 15),
      );
      await pumpFor(tester, const Duration(milliseconds: 500));

      // Fill amount
      final amount = findAmountInput();
      if (amount.evaluate().isNotEmpty) {
        await safeTapFirst(tester, amount, reason: 'Tap amount input');
        await tester.enterText(amount, '2500');
        await pumpFor(tester, const Duration(milliseconds: 400));
      }

      // Open SelectCategoryScreen
      final categoryTap = findCategoryFieldTap();
      await safeTapFirst(tester, categoryTap, reason: 'Open category picker');

      // Wait select category
      await waitFor(
        tester,
        findSelectCategoryTitle(),
        timeout: const Duration(seconds: 15),
      );
      await pumpFor(tester, const Duration(milliseconds: 300));

      // If loading circle present, wait it gone
      final loadingCircle = find.byType(CircularProgressIndicator);
      if (loadingCircle.evaluate().isNotEmpty) {
        await waitUntilGone(
          tester,
          loadingCircle,
          timeout: const Duration(seconds: 20),
        );
      }

      // Pick category item (this will pop back)
      await pickCategory(tester);

      // Back to AddTransactionScreen
      await waitFor(
        tester,
        findAddTransactionTitle(),
        timeout: const Duration(seconds: 15),
      );
      await pumpFor(tester, const Duration(milliseconds: 400));

      // Fill note
      final note = findNoteInput();
      if (note.evaluate().isNotEmpty) {
        await safeTapFirst(tester, note, reason: 'Tap note input');
        await tester.enterText(note, 'Added from integration test');
        await pumpFor(tester, const Duration(milliseconds: 400));
      }

      // Submit (NEW button text: Add)
      final addBtn = findAddButton();
      await safeTapFirst(tester, addBtn, reason: 'Tap Add button');

      // Wait saving overlay if any
      final savingBar = find.byType(LinearProgressIndicator);
      if (savingBar.evaluate().isNotEmpty) {
        await waitUntilGone(
          tester,
          savingBar,
          timeout: const Duration(seconds: 25),
        );
      }

      // Success snackbar
      await waitFor(
        tester,
        find.text(AppStrings.transactionAdded),
        timeout: const Duration(seconds: 20),
      );

      // Pop back to Dashboard
      await waitFor(
        tester,
        find.text('Dashboard'),
        timeout: const Duration(seconds: 20),
      );

      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
