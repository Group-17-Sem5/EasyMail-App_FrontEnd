// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:easy_mail_app_frontend/screens/homePage.dart';
import 'package:easy_mail_app_frontend/shared_widgets/userAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_mail_app_frontend/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(ProviderScope(
    //   child: MaterialApp(
    //     home: MyHomePage(
    //       title: 'Easy Mail',
    //     ),
    //   ),
    // ));
  });
  testWidgets('Home Page test', (WidgetTester tester) async {
    await tester.pumpWidget(MyHomePage(title: "easymail"));
    expect(find.text('easymail'), findsOneWidget);
    expect(find.text("I'm a post man"), findsOneWidget);
    expect(find.text("I'm a user"), findsOneWidget);
  });
}
