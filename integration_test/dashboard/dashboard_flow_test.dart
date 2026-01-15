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

  group('App flow: Get Started -> Login -> Dashboard', () {
    testWidgets('should navigate to dashboard after login', (tester) async {
      // Start app
      app.main();

      // Give app time to boot (slow, safe)
      await pumpFor(tester, const Duration(seconds: 2));

      // Tap Get Started if exists
      final getStarted = findGetStartedButton();
      if (getStarted.evaluate().isNotEmpty) {
        await tester.tap(getStarted);
        await tester.pump();
        await pumpFor(tester, const Duration(seconds: 1));
      }

      // Wait until Login button appears => LoginScreen ready
      await waitFor(tester, findLoginButton(), timeout: const Duration(seconds: 15));

      // Enter email/password (slow typing style)
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

      // Wait longer for auth + navigation (network can be slow)
      // We wait for Dashboard title as the main signal.
      await waitFor(
        tester,
        find.text('Dashboard'),
        timeout: const Duration(seconds: 30),
      );

      // Extra settle time for dashboard loading UI
      await pumpFor(tester, const Duration(seconds: 2));

      // Assert dashboard anchors
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Recent Transactions'), findsOneWidget);
      expect(find.text('INCOME'), findsOneWidget);
      expect(find.text('EXPENSES'), findsOneWidget);
      expect(find.text('BALANCE'), findsOneWidget);

      // Optional: wait for loading overlay to go away if it exists
      // Dashboard uses LinearProgressIndicator when loading.
      final loadingBar = find.byType(LinearProgressIndicator);
      if (loadingBar.evaluate().isNotEmpty) {
        await waitUntilGone(
          tester,
          loadingBar,
          timeout: const Duration(seconds: 20),
        );
      }
    });
  });
}
