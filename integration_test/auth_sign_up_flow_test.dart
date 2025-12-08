// integration_test/auth_sign_up_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:finance_tracking_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full auth flow: Welcome -> Login -> Sign Up', (tester) async {
    app.main();

    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.textContaining('Welcome to Personal'), findsOneWidget);

    final registerFinder = find.byWidgetPredicate(
      (widget) => widget is Text && widget.data?.trim() == 'Register',
    );
    expect(registerFinder, findsOneWidget);

    await tester.tap(registerFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
