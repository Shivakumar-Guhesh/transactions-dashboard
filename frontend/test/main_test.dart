import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/main.dart';
import 'package:frontend/screens/main_screen.dart';

void main() {
  testWidgets(
    'HomeScreen displays MainScreen inside SafeArea',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(MainScreen), findsOneWidget);
    },
  );

  testWidgets(
    'MaterialApp has correct title',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, equals('Transactions Dashboard'));
    },
  );

  testWidgets(
    'HomeScreen uses correct theme mode',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, isA<ThemeMode>());
    },
  );

  testWidgets(
    'SafeArea widget is present in HomeScreen',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(find.byType(SafeArea), findsOneWidget);
    },
  );
}
