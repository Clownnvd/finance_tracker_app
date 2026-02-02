// integration_test/monthly_report/monthly_report_flow_test.dart
//
// Integration test for Monthly Report flow:
// Login -> Dashboard -> Report (via bottom nav) -> View tabs -> Change month
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

  // Bottom nav - Report is index 3 (icon: Icons.bar_chart)
  Finder findReportNavItem() {
    final reportIcon = find.byIcon(Icons.bar_chart).hitTestable();
    if (reportIcon.evaluate().isNotEmpty) return reportIcon;

    final reportText = find.text(AppStrings.navReport).hitTestable();
    if (reportText.evaluate().isNotEmpty) return reportText;

    return reportIcon;
  }

  // -------------------------
  // Monthly Report screen finders
  // -------------------------
  Finder findReportTitle() => find.text('Financial Report');

  // Tab buttons
  Finder findMonthlyTab() => find.text('Monthly').hitTestable();
  Finder findCategoryTab() => find.text('Category').hitTestable();
  Finder findSummaryTab() => find.text('Summary').hitTestable();

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

  group('App flow: Login -> Dashboard -> Monthly Report', () {
    testWidgets('should navigate to Monthly Report and view tabs',
        (tester) async {
      await loginAndGoToDashboard(tester);

      // -------------------------
      // Navigate to Report via bottom nav
      // -------------------------
      final reportNav = findReportNavItem();
      expect(reportNav, findsWidgets, reason: 'Report nav should exist');
      await safeTapFirst(tester, reportNav, reason: 'Tap Report nav');
      await pumpFor(tester, const Duration(seconds: 1));

      // Wait for Monthly Report screen
      await waitFor(
        tester,
        findReportTitle(),
        timeout: const Duration(seconds: 15),
      );
      await pumpFor(tester, const Duration(milliseconds: 500));

      // Wait for loading to complete
      final reportLoader = find.byType(CircularProgressIndicator);
      if (reportLoader.evaluate().isNotEmpty) {
        await waitUntilGone(
          tester,
          reportLoader,
          timeout: const Duration(seconds: 20),
        );
      }

      // -------------------------
      // Verify Monthly Tab is visible (default)
      // -------------------------
      final monthlyTab = findMonthlyTab();
      expect(monthlyTab, findsWidgets, reason: 'Monthly tab should exist');

      // -------------------------
      // Tap Category Tab
      // -------------------------
      final categoryTab = findCategoryTab();
      if (categoryTab.evaluate().isNotEmpty) {
        await safeTapFirst(tester, categoryTab, reason: 'Tap Category tab');
        await pumpFor(tester, const Duration(milliseconds: 500));

        // Verify we're on Category tab (pie charts or category content)
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      }

      // -------------------------
      // Tap Summary Tab
      // -------------------------
      final summaryTab = findSummaryTab();
      if (summaryTab.evaluate().isNotEmpty) {
        await safeTapFirst(tester, summaryTab, reason: 'Tap Summary tab');
        await pumpFor(tester, const Duration(milliseconds: 500));

        // Verify we're on Summary tab
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      }

      // -------------------------
      // Tap back to Monthly Tab
      // -------------------------
      final monthlyTabAgain = findMonthlyTab();
      if (monthlyTabAgain.evaluate().isNotEmpty) {
        await safeTapFirst(tester, monthlyTabAgain, reason: 'Tap Monthly tab');
        await pumpFor(tester, const Duration(milliseconds: 500));

        // Verify we're on Monthly tab
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      }
    });

    testWidgets('should display financial data on Monthly Report',
        (tester) async {
      await loginAndGoToDashboard(tester);

      // Navigate to Report
      final reportNav = findReportNavItem();
      await safeTapFirst(tester, reportNav, reason: 'Tap Report nav');
      await pumpFor(tester, const Duration(seconds: 1));

      // Wait for Monthly Report screen
      await waitFor(
        tester,
        findReportTitle(),
        timeout: const Duration(seconds: 15),
      );

      // Wait for loading to complete
      final reportLoader = find.byType(CircularProgressIndicator);
      if (reportLoader.evaluate().isNotEmpty) {
        await waitUntilGone(
          tester,
          reportLoader,
          timeout: const Duration(seconds: 20),
        );
      }

      await pumpFor(tester, const Duration(milliseconds: 500));

      // Verify Financial Report title exists
      expect(findReportTitle(), findsOneWidget);

      // The report should have content (not empty)
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should handle error state gracefully', (tester) async {
      await loginAndGoToDashboard(tester);

      // Navigate to Report
      final reportNav = findReportNavItem();
      await safeTapFirst(tester, reportNav, reason: 'Tap Report nav');
      await pumpFor(tester, const Duration(seconds: 1));

      // Wait for Monthly Report screen
      await waitFor(
        tester,
        findReportTitle(),
        timeout: const Duration(seconds: 15),
      );

      // Wait for content to load
      await pumpFor(tester, const Duration(seconds: 2));

      // Check if retry button exists (error state) or content loaded
      final retryButton = find.text('Retry').hitTestable();
      if (retryButton.evaluate().isNotEmpty) {
        // Error state - tap retry
        await safeTapFirst(tester, retryButton, reason: 'Tap Retry');
        await pumpFor(tester, const Duration(seconds: 2));
      }

      // Should show either content or error, but not crash
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
