// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bida_staff_app/app.dart';

void main() {
  testWidgets('Bida Staff App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that our app shows the welcome message.
    expect(find.text('Welcome to Bida Staff App'), findsOneWidget);
    expect(find.text('Billiard Club Management System'), findsOneWidget);
    expect(find.text('Features Coming Soon:'), findsOneWidget);
    
    // Verify that our app shows the billiard icon.
    expect(find.byIcon(Icons.sports_bar), findsOneWidget);
  });
}
