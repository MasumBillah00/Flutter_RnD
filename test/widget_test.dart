import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:autologout_biometric/main.dart';
import 'package:autologout_biometric/todo_app/database/dataase_helper.dart';
import 'package:autologout_biometric/todo_app/database/note_database.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create the required dependencies
    final databaseHelper = TodoDatabaseHelper();
    final noteDatabaseProvider = DatabaseProvider();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(databaseHelper, noteDatabaseProvider));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
