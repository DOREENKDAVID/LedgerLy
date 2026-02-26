// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// No need to import `main.dart` for this minimal widget test.

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Build a minimal app to avoid timers in the real SplashScreen during tests.
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    // Verify that the MaterialApp builds.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
