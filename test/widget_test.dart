// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:youtube_inbackground_newversion/main.dart';
import 'package:youtube_inbackground_newversion/view/HomePage.dart';
import 'package:youtube_inbackground_newversion/view/MainPage.dart';

void main() {
  testWidgets('Y&B testing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    //expect(find.text('1'), findsNothing);
    expect(find.byType(MainPage), findsOneWidget);
    //final button = find.byIcon(Icons.home);
    //tester.tap(button)
    //expect(find.byType(HomePage), findsOneWidget);
    // Tap the '+' icon and trigger a frame.
    await tester.pump();
    expect(find.text("Search Something"), findsOneWidget);
    //// Verify that our counter has incremented.
    //expect(find.text('1'), findsOneWidget);
  });
}
