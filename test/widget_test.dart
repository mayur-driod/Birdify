// This is a basic Flutter widget test for Birdify.

import 'package:flutter_test/flutter_test.dart';

import 'package:birdify/main.dart';

void main() {
  testWidgets('BirdifyApp smoke test', (WidgetTester tester) async {
    // Verify the app builds without error.
    expect(BirdifyApp, isNotNull);
  });
}

