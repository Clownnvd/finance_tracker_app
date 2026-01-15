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
  // Dashboard -> Transaction History entry (EDIT HERE if needed)
  // -------------------------
  Finder findOpenHistoryEntry() {
    // common texts
    final byText1 = find.text('Transaction History').hitTestable();
    if (byText1.evaluate().isNotEmpty) return byText1;

    final byText2 = find.textContaining('History').hitTestable();
    if (byText2.evaluate().isNotEmpty) return byText2;

    // common icons
    final byIcon1 = find.byIcon(Icons.history).hitTestable();
    if (byIcon1.evaluate().isNotEmpty) return byIcon1;

    final byIcon2 = find.byIcon(Icons.receipt_long).hitTestable();
    if (byIcon2.evaluate().isNotEmpty) return byIcon2;

    // common menu
    final byMenu = find.byIcon(Icons.menu).hitTestable();
    if (byMenu.evaluate().isNotEmpty) return byMenu;

    return byText1; // will fail clearly later
  }

  Finder findHistoryTitle() => find.text('Transaction History');
  Finder findReloadCategoriesButton() => find.byTooltip('Reload categories').hitTestable();

  group('App flow: Dashboard -> Transaction History', () {
    testWidgets('should open history, refresh, and go back', (tester) async {
      // Start app
      app.main();

      await pumpFor(tester, const Duration(seconds: 2));

      // Tap Get Started if exists
      final getStarted = findGetStartedButton();
      if (getStarted.evaluate().isNotEmpty) {
        await tester.tap(getStarted);
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 1));
      }

      // Wait until Login button appears
      await waitFor(tester, findLoginButton(), timeout: const Duration(seconds: 15));

      // Enter email/password
      await tester.tap(findEmailField());
      await tester.pump();
      await tester.enterText(findEmailField(), 'Kingpro2@gmail.com');
      await pumpFor(tester, const Duration(milliseconds: 400));

      await tester.tap(findPasswordField());
      await tester.pump();
      await tester.enterText(findPasswordField(), 'Kingpro2@gmail.com');
      await pumpFor(tester, const Duration(milliseconds: 400));

      // Tap Login
      await tester.ensureVisible(findLoginButton());
      await tester.tap(findLoginButton());
      await tester.pump();

      // Wait Dashboard
      await waitFor(tester, find.text('Dashboard'), timeout: const Duration(seconds: 30));
      await pumpFor(tester, const Duration(seconds: 1));

      // Optional: wait dashboard loading overlay to disappear
      final dashLoading = find.byType(LinearProgressIndicator);
      if (dashLoading.evaluate().isNotEmpty) {
        await waitUntilGone(tester, dashLoading, timeout: const Duration(seconds: 20));
      }

      // -------------------------
      // Open Transaction History
      // -------------------------
      final openHistory = findOpenHistoryEntry();
      await tester.ensureVisible(openHistory);
      await tester.tap(openHistory);
      await tester.pump();

      await waitFor(tester, findHistoryTitle(), timeout: const Duration(seconds: 15));
      await pumpFor(tester, const Duration(milliseconds: 600));

      // If initial blocking loading happens (HistoryList may show progress)
      final anyProgress = find.byType(CircularProgressIndicator);
      if (anyProgress.evaluate().isNotEmpty) {
        await waitUntilGone(tester, anyProgress, timeout: const Duration(seconds: 25));
      }

      // If category banner error appears, it's acceptable (network may fail).
      // But we can also try tapping Reload categories.
      final reload = findReloadCategoriesButton();
      if (reload.evaluate().isNotEmpty) {
        await tester.tap(reload);
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 1));
      }

      // -------------------------
      // Pull-to-refresh (RefreshIndicator in screen wraps HistoryList)
      // -------------------------
      // drag down enough to trigger refresh
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, 500));
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 1));
      }

      // Wait potential loading bar to end
      final loadingBar = find.byType(LinearProgressIndicator);
      if (loadingBar.evaluate().isNotEmpty) {
        await waitUntilGone(tester, loadingBar, timeout: const Duration(seconds: 25));
      }

      // -------------------------
      // Best-effort: scroll to bottom to trigger loadMore
      // (HistoryList must call onLoadMore when near end; if not, this is harmless)
      // -------------------------
      if (scrollable.evaluate().isNotEmpty) {
        await tester.fling(scrollable.first, const Offset(0, -1200), 2500);
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 2));

        await tester.fling(scrollable.first, const Offset(0, -1200), 2500);
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 2));
      }

      // -------------------------
      // Back to Dashboard
      // -------------------------
      await tester.pageBack();
      await tester.pump();

      await waitFor(tester, find.text('Dashboard'), timeout: const Duration(seconds: 15));
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
