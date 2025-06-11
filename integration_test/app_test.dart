import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:projekakhirprak/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App starts and navigates correctly', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Verify that the initial screen (Exhibition) is shown
    expect(find.text('Car Exhibition'), findsOneWidget);
    expect(find.text('My Garage'), findsOneWidget);

    // Tap on the 'My Garage' tab
    await tester.tap(find.text('My Garage'));
    await tester.pumpAndSettle();

    // Verify that we have navigated to the Garage screen
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
} 