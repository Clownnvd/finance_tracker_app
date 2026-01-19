import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:finance_tracker_app/main.dart' as app;
import 'package:finance_tracker_app/core/constants/strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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

  // ---- NEW: robust back helper (fixes pageBack crash) ----
  Future<void> goBackToDashboard(WidgetTester tester) async {
    // 1) Try AppBar back buttons (Material)
    final candidates = <Finder>[
      find.byTooltip('Back').hitTestable(),
      find.byIcon(Icons.arrow_back).hitTestable(),
      find.byIcon(Icons.arrow_back_ios_new_rounded).hitTestable(),
      find.byIcon(Icons.arrow_back_ios).hitTestable(),
      find.byIcon(Icons.chevron_left).hitTestable(),
    ];

    for (final f in candidates) {
      if (f.evaluate().isNotEmpty) {
        await safeTapFirst(tester, f, reason: 'Tap app bar back');
        await pumpFor(tester, const Duration(milliseconds: 300));
        return;
      }
    }

    // 2) Fallback: system back (pop route)
    final didPop = await tester.binding.handlePopRoute();
    await tester.pump();
    await pumpFor(tester, const Duration(milliseconds: 300));
    if (didPop) return;

    // 3) Last resort: try Navigator.maybePop via widget tree
    final nav = tester.state<NavigatorState>(find.byType(Navigator));
    final ok = await nav.maybePop();
    await tester.pump();
    await pumpFor(tester, const Duration(milliseconds: 300));
    if (ok) return;

    fail('Could not go back: no back button and route did not pop.');
  }

  Finder findGetStartedButton() =>
      find.widgetWithText(ElevatedButton, 'Get Started').hitTestable();

  Finder findLoginButton() =>
      find.widgetWithText(ElevatedButton, AppStrings.login).hitTestable();

  Finder findEmailField() => find.byType(TextFormField).at(0);
  Finder findPasswordField() => find.byType(TextFormField).at(1);

  Finder findOpenHistoryEntry() {
    final byBottomNav = find.text('History').hitTestable();
    if (byBottomNav.evaluate().isNotEmpty) return byBottomNav;

    final byTitle = find.text('Transaction History').hitTestable();
    if (byTitle.evaluate().isNotEmpty) return byTitle;

    final byIcon1 = find.byIcon(Icons.history).hitTestable();
    if (byIcon1.evaluate().isNotEmpty) return byIcon1;

    final byIcon2 = find.byIcon(Icons.receipt_long).hitTestable();
    if (byIcon2.evaluate().isNotEmpty) return byIcon2;

    final byContains = find.textContaining('History').hitTestable();
    if (byContains.evaluate().isNotEmpty) return byContains;

    return byBottomNav;
  }

  Finder findHistoryTitle() => find.text('Transaction History');

  Finder findReloadCategoriesButton() {
    final byTooltip = find.byTooltip(AppStrings.reloadCategoriesTooltip).hitTestable();
    if (byTooltip.evaluate().isNotEmpty) return byTooltip;

    final byTooltipFallback = find.byTooltip('Reload categories').hitTestable();
    if (byTooltipFallback.evaluate().isNotEmpty) return byTooltipFallback;

    final byIcon = find.byIcon(Icons.refresh_rounded).hitTestable();
    if (byIcon.evaluate().isNotEmpty) return byIcon;

    return byTooltip;
  }

  group('App flow: Dashboard -> Transaction History (new UI)', () {
    testWidgets('should open history, refresh, load more, and go back',
        (tester) async {
      app.main();
      await pumpFor(tester, const Duration(seconds: 2));

      final getStarted = findGetStartedButton();
      if (getStarted.evaluate().isNotEmpty) {
        await safeTapFirst(tester, getStarted, reason: 'Tap Get Started');
        await pumpFor(tester, const Duration(seconds: 1));
      }

      await waitFor(tester, findLoginButton(), timeout: const Duration(seconds: 15));

      await safeTapFirst(tester, findEmailField(), reason: 'Focus email');
      await tester.enterText(findEmailField(), 'Kingpro2@gmail.com');
      await pumpFor(tester, const Duration(milliseconds: 300));

      await safeTapFirst(tester, findPasswordField(), reason: 'Focus password');
      await tester.enterText(findPasswordField(), 'Kingpro2@gmail.com');
      await pumpFor(tester, const Duration(milliseconds: 300));

      await safeTapFirst(tester, findLoginButton(), reason: 'Tap Login');

      await waitFor(tester, find.text('Dashboard'), timeout: const Duration(seconds: 30));
      await pumpFor(tester, const Duration(seconds: 1));

      final dashLoading = find.byType(LinearProgressIndicator);
      if (dashLoading.evaluate().isNotEmpty) {
        await waitUntilGone(tester, dashLoading, timeout: const Duration(seconds: 20));
      }

      // Open Transaction History
      final openHistory = findOpenHistoryEntry();
      await safeTapFirst(tester, openHistory, reason: 'Open Transaction History');
      await waitFor(tester, findHistoryTitle(), timeout: const Duration(seconds: 15));
      await pumpFor(tester, const Duration(milliseconds: 600));

      final blocking = find.byType(CircularProgressIndicator);
      if (blocking.evaluate().isNotEmpty) {
        await waitUntilGone(tester, blocking, timeout: const Duration(seconds: 25));
      }

      final reload = findReloadCategoriesButton();
      if (reload.evaluate().isNotEmpty) {
        await safeTapFirst(tester, reload, reason: 'Reload categories');
        await pumpFor(tester, const Duration(seconds: 1));
      }

      // Pull-to-refresh
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, 500));
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 1));
      }

      final loadingBar = find.byType(LinearProgressIndicator);
      if (loadingBar.evaluate().isNotEmpty) {
        await waitUntilGone(tester, loadingBar, timeout: const Duration(seconds: 25));
      }

      // Try trigger load more
      if (scrollable.evaluate().isNotEmpty) {
        await tester.fling(scrollable.first, const Offset(0, -1400), 3000);
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 2));

        await tester.fling(scrollable.first, const Offset(0, -1400), 3000);
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 2));
      }

      // Back to Dashboard (FIXED)
      await goBackToDashboard(tester);

      await waitFor(tester, find.text('Dashboard'), timeout: const Duration(seconds: 15));
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
