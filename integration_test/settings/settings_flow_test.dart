import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:finance_tracker_app/main.dart' as app;
import 'package:finance_tracker_app/core/constants/strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ================= Helpers =================
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
    required String reason,
  }) async {
    if (finder.evaluate().isEmpty) {
      fail('Cannot tap ($reason). Finder not found: $finder');
    }
    await tester.ensureVisible(finder.first);
    await tester.tap(finder.first);
    await tester.pump();
  }

  Future<void> goBack(WidgetTester tester) async {
    final candidates = <Finder>[
      find.byTooltip('Back').hitTestable(),
      find.byIcon(Icons.arrow_back).hitTestable(),
      find.byIcon(Icons.arrow_back_ios_new_rounded).hitTestable(),
      find.byIcon(Icons.arrow_back_ios).hitTestable(),
      find.byIcon(Icons.chevron_left).hitTestable(),
    ];

    for (final f in candidates) {
      if (f.evaluate().isNotEmpty) {
        await safeTapFirst(tester, f, reason: 'Tap back button');
        await pumpFor(tester, const Duration(milliseconds: 300));
        return;
      }
    }

    final didPop = await tester.binding.handlePopRoute();
    await tester.pump();
    await pumpFor(tester, const Duration(milliseconds: 300));
    if (didPop) return;

    final nav = tester.state<NavigatorState>(find.byType(Navigator));
    final ok = await nav.maybePop();
    await tester.pump();
    await pumpFor(tester, const Duration(milliseconds: 300));
    if (ok) return;

    fail('Could not go back: no back button and route did not pop.');
  }

  // ================= Finders =================
  Finder findGetStartedButton() =>
      find.widgetWithText(ElevatedButton, AppStrings.getStarted).hitTestable();

  Finder findLoginButton() =>
      find.widgetWithText(ElevatedButton, AppStrings.login).hitTestable();

  Finder findEmailField() => find.byType(TextFormField).at(0);
  Finder findPasswordField() => find.byType(TextFormField).at(1);

  // Dashboard anchors (đúng theo test dashboard bạn dùng trước đó)
  Finder findDashboardTitle() => find.text(AppStrings.dashboardTitle);
  Finder findRecentTransactions() => find.text('Recent Transactions');
  Finder findIncome() => find.text('INCOME');
  Finder findExpenses() => find.text('EXPENSES');
  Finder findBalance() => find.text('BALANCE');

  Finder findSettingsNav() => find.text(AppStrings.navSettings).hitTestable();

  // ================= Flows =================
  Future<void> loginToDashboard(WidgetTester tester) async {
    app.main();
    await pumpFor(tester, const Duration(seconds: 2));

    final getStarted = findGetStartedButton();
    if (getStarted.evaluate().isNotEmpty) {
      await safeTapFirst(tester, getStarted, reason: 'Tap Get Started');
      await pumpFor(tester, const Duration(seconds: 1));
    }

    await waitFor(tester, findLoginButton(),
        timeout: const Duration(seconds: 15));

    await safeTapFirst(tester, findEmailField(), reason: 'Focus email');
    await tester.enterText(findEmailField(), 'Kingpro1@gmail.com');
    await pumpFor(tester, const Duration(milliseconds: 300));

    await safeTapFirst(tester, findPasswordField(), reason: 'Focus password');
    await tester.enterText(findPasswordField(), 'Kingpro1@gmail.com');
    await pumpFor(tester, const Duration(milliseconds: 300));

    await safeTapFirst(tester, findLoginButton(), reason: 'Tap Login');

    await waitFor(tester, findDashboardTitle(),
        timeout: const Duration(seconds: 30));
    await pumpFor(tester, const Duration(seconds: 1));

    final dashLoading = find.byType(LinearProgressIndicator);
    if (dashLoading.evaluate().isNotEmpty) {
      await waitUntilGone(tester, dashLoading,
          timeout: const Duration(seconds: 20));
    }
  }

  Future<void> assertDashboard(WidgetTester tester) async {
    // Chờ dashboard render ổn định
    await waitFor(tester, findDashboardTitle(),
        timeout: const Duration(seconds: 15));
    await pumpFor(tester, const Duration(milliseconds: 400));

    // Assert anchors
    expect(findDashboardTitle(), findsOneWidget);

    // Nếu app bạn có lúc chưa load transactions kịp, có thể đổi thành waitForAny
    expect(findRecentTransactions(), findsOneWidget);
    expect(findIncome(), findsOneWidget);
    expect(findExpenses(), findsOneWidget);
    expect(findBalance(), findsOneWidget);
  }

  // ================= Tests =================
  group('FULL Settings flow: Login -> Dashboard -> Settings -> Account & Security', () {
    testWidgets('should validate dashboard then open settings and account security',
        (tester) async {
      await loginToDashboard(tester);

      // ✅ Include Dashboard assertions here
      await assertDashboard(tester);

      // Open Settings
      await safeTapFirst(tester, findSettingsNav(), reason: 'Open Settings');
      await waitFor(tester, find.text('Settings'),
          timeout: const Duration(seconds: 15));

      final loading = find.byType(CircularProgressIndicator);
      if (loading.evaluate().isNotEmpty) {
        await waitUntilGone(tester, loading, timeout: const Duration(seconds: 20));
      }

      // Dismiss optional "No Budget set" dialog
      final noBudget = find.text('No Budget set');
      if (noBudget.evaluate().isNotEmpty) {
        final cancel = find.widgetWithText(TextButton, 'Cancel');
        if (cancel.evaluate().isNotEmpty) {
          await safeTapFirst(tester, cancel, reason: 'Dismiss no-budget dialog');
          await pumpFor(tester, const Duration(milliseconds: 400));
        }
      }

      // Settings items
      expect(find.text('Transaction Reminder'), findsOneWidget);
      expect(find.text('Budget Limit'), findsOneWidget);
      expect(find.text('Tips & Recommendations'), findsOneWidget);
      expect(find.text('Account & Security'), findsOneWidget);

      // Toggle first switch if exists
      final switches = find.byType(Switch);
      if (switches.evaluate().isNotEmpty) {
        await safeTapFirst(tester, switches.first, reason: 'Toggle first switch');
        await pumpFor(tester, const Duration(milliseconds: 200));
      }

      // Open Account & Security
      await safeTapFirst(
        tester,
        find.text('Account & Security'),
        reason: 'Open Account & Security',
      );
      await waitFor(tester, find.text('Account & Security'),
          timeout: const Duration(seconds: 10));

      // Go back to Settings
      await goBack(tester);
      await waitFor(tester, find.text('Settings'),
          timeout: const Duration(seconds: 10));

      // (Optional) back to Dashboard if you want:
      // await goBack(tester);
      // await waitFor(tester, findDashboardTitle(), timeout: const Duration(seconds: 10));
    });
  });
}
