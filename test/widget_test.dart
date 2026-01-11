import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chroma_switch/main.dart';
import 'package:chroma_switch/core/di/service_locator.dart';

void main() {
  setUpAll(() {
    // Setup dependencies before tests
    setupDependencies();
  });

  testWidgets('ChromaSwitchApp renders without error', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ChromaSwitchApp()));

    // Verify the app renders without crashing
    expect(find.byType(ChromaSwitchApp), findsOneWidget);
  });
}
