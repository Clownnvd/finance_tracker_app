import 'package:finance_tracker_app/feature/users/auth/presentation/pages/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WelcomeScreen shows "Welcome" text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    expect(find.text('Welcome'), findsOneWidget);
  });
}
