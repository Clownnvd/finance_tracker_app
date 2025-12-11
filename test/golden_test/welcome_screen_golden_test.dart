import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/welcome_screen.dart';

void main() {
  testWidgets('WelcomeScreen golden snapshot', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

    await expectLater(
      find.byType(WelcomeScreen),
      matchesGoldenFile('goldens/welcome_screen.png'),
    );
  });
}
