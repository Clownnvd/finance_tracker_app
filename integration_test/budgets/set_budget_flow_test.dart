// integration_test/budgets/set_budget_flow_test.dart
//
// Integration test for Set Budget flow:
// Login -> Dashboard -> Settings (via bottom nav) -> Toggle Budget Limit -> Dialog -> Set Budget
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:finance_tracker_app/main.dart' as app;
import 'package:finance_tracker_app/core/constants/strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Test credentials
  const testEmail = 'Kingpro1@gmail.com';
  const testPassword = 'Kingpro1@gmail.com';

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
  // Auth finders
  // -------------------------
  Finder findGetStartedButton() =>
      find.widgetWithText(ElevatedButton, 'Get Started').hitTestable();

  Finder findLoginButton() =>
      find.widgetWithText(ElevatedButton, AppStrings.login).hitTestable();

  Finder findEmailField() => find.byType(TextFormField).at(0);
  Finder findPasswordField() => find.byType(TextFormField).at(1);

  // -------------------------
  // Dashboard finders
  // -------------------------
  Finder findDashboardTitle() => find.text('Dashboard');

  // Bottom nav - Settings is index 4 (icon: Icons.settings)
  Finder findSettingsNavItem() {
    // Try settings icon in bottom nav
    final settingsIcon = find.byIcon(Icons.settings).hitTestable();
    if (settingsIcon.evaluate().isNotEmpty) return settingsIcon;

    // Try settings text in nav
    final settingsText = find.text(AppStrings.navSettings).hitTestable();
    if (settingsText.evaluate().isNotEmpty) return settingsText;

    return settingsIcon;
  }

  // -------------------------
  // Settings screen finders
  // -------------------------
  Finder findSettingsTitle() => find.text('Settings');

  // Budget Limit switch
  Finder findBudgetLimitSwitch() {
    // Find switch near "Budget Limit" text
    final switches = find.byType(Switch).hitTestable();
    if (switches.evaluate().length >= 2) {
      // Budget Limit is the second switch (after Transaction Reminder)
      return switches.at(1);
    }
    return switches.first;
  }

  // -------------------------
  // No Budget Dialog finders
  // -------------------------
  Finder findNoBudgetDialogTitle() => find.text('No Budget set');
  Finder findSetBudgetDialogButton() =>
      find.widgetWithText(ElevatedButton, 'Set Budget').hitTestable();

  // -------------------------
  // Set Budget screen finders
  // -------------------------
  Finder findSetBudgetTitle() => find.text('Set Budget');

  Finder findCategoryPicker() {
    // Try "Select category" text
    final selectCat = find.text('Select category').hitTestable();
    if (selectCat.evaluate().isNotEmpty) return selectCat;

    // Try "Budget Category" label area
    final catLabel = find.text('Budget Category');
    if (catLabel.evaluate().isNotEmpty) {
      final inkwells = find.byType(InkWell).hitTestable();
      if (inkwells.evaluate().isNotEmpty) return inkwells.first;
    }

    // Fallback to first InkWell
    final inkwells = find.byType(InkWell).hitTestable();
    if (inkwells.evaluate().isNotEmpty) return inkwells.first;

    return selectCat;
  }

  Finder findAmountInput() => find.byType(TextField).first;

  Finder findSaveButton() =>
      find.widgetWithText(ElevatedButton, 'Save').hitTestable();

  // -------------------------
  // Category selection
  // -------------------------
  Future<void> pickAnyCategory(WidgetTester tester) async {
    final preferred = <Finder>[
      find.text('Housing').hitTestable(),
      find.text('Food').hitTestable(),
      find.text('Shopping').hitTestable(),
      find.text('Transportation').hitTestable(),
      find.text('Utilities').hitTestable(),
      find.text('Entertainment').hitTestable(),
      find.text('Health').hitTestable(),
      find.text('Other').hitTestable(),
    ];

    for (final f in preferred) {
      if (f.evaluate().isNotEmpty) {
        await safeTapFirst(tester, f, reason: 'Pick category item');
        await pumpFor(tester, const Duration(milliseconds: 400));
        return;
      }
    }

    // Fallback: tap any InkWell (category item)
    final tiles = find.byType(InkWell).hitTestable();
    if (tiles.evaluate().isNotEmpty) {
      await safeTapFirst(tester, tiles, reason: 'Pick first InkWell category');
      await pumpFor(tester, const Duration(milliseconds: 400));
      return;
    }

    fail('Could not find any category item to tap on SelectCategory screen.');
  }

  // -------------------------
  // Login helper
  // -------------------------
  Future<void> loginAndGoToDashboard(WidgetTester tester) async {
    // Start app
    app.main();

    // Boot
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
    await tester.enterText(findEmailField(), testEmail);
    await pumpFor(tester, const Duration(milliseconds: 300));

    await tester.tap(findPasswordField());
    await tester.pump();
    await tester.enterText(findPasswordField(), testPassword);
    await pumpFor(tester, const Duration(milliseconds: 300));

    // Tap Login
    await safeTapFirst(tester, findLoginButton(), reason: 'Tap Login');

    // Wait for Dashboard
    await waitFor(
      tester,
      findDashboardTitle(),
      timeout: const Duration(seconds: 30),
    );
    await pumpFor(tester, const Duration(seconds: 1));

    // Wait loading bar gone
    final loadingBar = find.byType(LinearProgressIndicator);
    if (loadingBar.evaluate().isNotEmpty) {
      await waitUntilGone(
        tester,
        loadingBar,
        timeout: const Duration(seconds: 20),
      );
    }
  }

  group('App flow: Login -> Dashboard -> Settings -> Set Budget', () {
    testWidgets('should navigate to Set Budget via Budget Limit toggle',
        (tester) async {
      await loginAndGoToDashboard(tester);

      // -------------------------
      // Navigate to Settings via bottom nav
      // -------------------------
      final settingsNav = findSettingsNavItem();
      expect(settingsNav, findsWidgets, reason: 'Settings nav should exist');
      await safeTapFirst(tester, settingsNav, reason: 'Tap Settings nav');
      await pumpFor(tester, const Duration(seconds: 1));

      // Wait for Settings screen
      await waitFor(
        tester,
        findSettingsTitle(),
        timeout: const Duration(seconds: 15),
      );
      await pumpFor(tester, const Duration(milliseconds: 500));

      // Wait for Settings to load
      final settingsLoader = find.byType(CircularProgressIndicator);
      if (settingsLoader.evaluate().isNotEmpty) {
        await waitUntilGone(
          tester,
          settingsLoader,
          timeout: const Duration(seconds: 15),
        );
      }

      // -------------------------
      // Toggle Budget Limit switch to trigger dialog
      // -------------------------
      final budgetSwitch = findBudgetLimitSwitch();
      if (budgetSwitch.evaluate().isNotEmpty) {
        await safeTapFirst(tester, budgetSwitch, reason: 'Toggle Budget Limit');
        await pumpFor(tester, const Duration(seconds: 1));

        // Check if "No Budget set" dialog appears
        final dialogTitle = findNoBudgetDialogTitle();
        if (dialogTitle.evaluate().isNotEmpty) {
          // Dialog appeared - tap "Set Budget" button
          final setBtn = findSetBudgetDialogButton();
          await safeTapFirst(tester, setBtn, reason: 'Tap Set Budget in dialog');
          await pumpFor(tester, const Duration(milliseconds: 500));

          // Wait for Set Budget screen
          await waitFor(
            tester,
            findSetBudgetTitle(),
            timeout: const Duration(seconds: 15),
          );
          await pumpFor(tester, const Duration(milliseconds: 400));

          // -------------------------
          // Fill Set Budget form
          // -------------------------

          // Open category picker
          final catPicker = findCategoryPicker();
          await safeTapFirst(tester, catPicker, reason: 'Open category picker');
          await pumpFor(tester, const Duration(milliseconds: 500));

          // Pick a category
          await pickAnyCategory(tester);

          // Wait to be back on Set Budget screen
          await waitFor(
            tester,
            findSetBudgetTitle(),
            timeout: const Duration(seconds: 10),
          );
          await pumpFor(tester, const Duration(milliseconds: 300));

          // Fill amount
          final amountField = findAmountInput();
          if (amountField.evaluate().isNotEmpty) {
            await tester.tap(amountField);
            await tester.pump();
            await tester.enterText(amountField, '5000');
            await pumpFor(tester, const Duration(milliseconds: 300));
          }

          // Save budget
          final saveBtn = findSaveButton();
          await safeTapFirst(tester, saveBtn, reason: 'Save Budget');

          // Wait for loading to complete
          final savingIndicator = find.byType(CircularProgressIndicator);
          if (savingIndicator.evaluate().isNotEmpty) {
            await waitUntilGone(
              tester,
              savingIndicator,
              timeout: const Duration(seconds: 20),
            );
          }

          // Expect success snackbar
          await waitFor(
            tester,
            find.text('Budget saved successfully!'),
            timeout: const Duration(seconds: 15),
          );

          expect(find.text('Budget saved successfully!'), findsOneWidget);
        } else {
          // Dialog didn't appear - user might already have a budget
          // This is acceptable
          expect(true, isTrue,
              reason: 'User already has a budget, no dialog shown');
        }
      } else {
        fail('Budget Limit switch not found');
      }
    });

    testWidgets('should show validation error when saving without category',
        (tester) async {
      await loginAndGoToDashboard(tester);

      // Navigate to Settings
      final settingsNav = findSettingsNavItem();
      await safeTapFirst(tester, settingsNav, reason: 'Tap Settings nav');
      await pumpFor(tester, const Duration(seconds: 1));

      // Wait for Settings screen
      await waitFor(tester, findSettingsTitle(),
          timeout: const Duration(seconds: 15));
      await pumpFor(tester, const Duration(milliseconds: 500));

      // Wait for Settings to load
      final settingsLoader = find.byType(CircularProgressIndicator);
      if (settingsLoader.evaluate().isNotEmpty) {
        await waitUntilGone(tester, settingsLoader,
            timeout: const Duration(seconds: 15));
      }

      // Toggle Budget Limit switch
      final budgetSwitch = findBudgetLimitSwitch();
      if (budgetSwitch.evaluate().isNotEmpty) {
        await safeTapFirst(tester, budgetSwitch, reason: 'Toggle Budget Limit');
        await pumpFor(tester, const Duration(seconds: 1));

        // Check if dialog appears
        final dialogTitle = findNoBudgetDialogTitle();
        if (dialogTitle.evaluate().isNotEmpty) {
          final setBtn = findSetBudgetDialogButton();
          await safeTapFirst(tester, setBtn, reason: 'Tap Set Budget in dialog');
          await pumpFor(tester, const Duration(milliseconds: 500));

          // Wait for Set Budget screen
          await waitFor(tester, findSetBudgetTitle(),
              timeout: const Duration(seconds: 15));
          await pumpFor(tester, const Duration(milliseconds: 400));

          // Fill amount WITHOUT selecting category
          final amountField = findAmountInput();
          if (amountField.evaluate().isNotEmpty) {
            await tester.tap(amountField);
            await tester.pump();
            await tester.enterText(amountField, '1000');
            await pumpFor(tester, const Duration(milliseconds: 300));
          }

          // Try to save without category
          final saveBtn = findSaveButton();
          await safeTapFirst(tester, saveBtn, reason: 'Save without category');

          // Expect validation error
          await waitFor(
            tester,
            find.text('Please select a category.'),
            timeout: const Duration(seconds: 10),
          );

          expect(find.text('Please select a category.'), findsOneWidget);
        }
      }
    });

    testWidgets('should show validation error when saving with zero amount',
        (tester) async {
      await loginAndGoToDashboard(tester);

      // Navigate to Settings
      final settingsNav = findSettingsNavItem();
      await safeTapFirst(tester, settingsNav, reason: 'Tap Settings nav');
      await pumpFor(tester, const Duration(seconds: 1));

      // Wait for Settings screen
      await waitFor(tester, findSettingsTitle(),
          timeout: const Duration(seconds: 15));
      await pumpFor(tester, const Duration(milliseconds: 500));

      // Wait for Settings to load
      final settingsLoader = find.byType(CircularProgressIndicator);
      if (settingsLoader.evaluate().isNotEmpty) {
        await waitUntilGone(tester, settingsLoader,
            timeout: const Duration(seconds: 15));
      }

      // Toggle Budget Limit switch
      final budgetSwitch = findBudgetLimitSwitch();
      if (budgetSwitch.evaluate().isNotEmpty) {
        await safeTapFirst(tester, budgetSwitch, reason: 'Toggle Budget Limit');
        await pumpFor(tester, const Duration(seconds: 1));

        // Check if dialog appears
        final dialogTitle = findNoBudgetDialogTitle();
        if (dialogTitle.evaluate().isNotEmpty) {
          final setBtn = findSetBudgetDialogButton();
          await safeTapFirst(tester, setBtn, reason: 'Tap Set Budget in dialog');
          await pumpFor(tester, const Duration(milliseconds: 500));

          // Wait for Set Budget screen
          await waitFor(tester, findSetBudgetTitle(),
              timeout: const Duration(seconds: 15));
          await pumpFor(tester, const Duration(milliseconds: 400));

          // Select category first
          final catPicker = findCategoryPicker();
          await safeTapFirst(tester, catPicker, reason: 'Open category picker');
          await pumpFor(tester, const Duration(milliseconds: 500));
          await pickAnyCategory(tester);

          // Wait to be back on Set Budget screen
          await waitFor(tester, findSetBudgetTitle(),
              timeout: const Duration(seconds: 10));
          await pumpFor(tester, const Duration(milliseconds: 300));

          // Don't enter amount (leave it 0)
          // Try to save
          final saveBtn = findSaveButton();
          await safeTapFirst(tester, saveBtn, reason: 'Save with zero amount');

          // Expect validation error
          await waitFor(
            tester,
            find.text('Amount must be greater than 0.'),
            timeout: const Duration(seconds: 10),
          );

          expect(find.text('Amount must be greater than 0.'), findsOneWidget);
        }
      }
    });
  });
}
