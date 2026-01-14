// Main widget test file
// Individual widget tests are in their respective test files:
// - test/widget/recipe_card_test.dart
// - test/widget/search_bar_test.dart
// - test/widget/favorite_button_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:posha/main.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive for testing
    Hive.init('test/hive_test');
  });

  testWidgets('App should start without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
