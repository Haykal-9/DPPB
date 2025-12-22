// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes/main.dart';
import 'package:tubes/pages/login_page.dart';

void main() {
  testWidgets('App starts successfully and shows LoginPage', (WidgetTester tester) async {
    // Set a larger test size to avoid overflow
    await tester.binding.setSurfaceSize(const Size(800, 600));
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the app built successfully
    expect(find.byType(MyApp), findsOneWidget);
    
    // Verify that LoginPage is displayed as the initial route
    expect(find.byType(LoginPage), findsOneWidget);
  });
  
  testWidgets('App has correct title', (WidgetTester tester) async {
    // Set a larger test size to avoid overflow
    await tester.binding.setSurfaceSize(const Size(800, 600));
    
    await tester.pumpWidget(const MyApp());
    
    // Get the MaterialApp widget
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    
    // Verify the title
    expect(materialApp.title, 'Tapal Kuda Coffee');
  });
}
