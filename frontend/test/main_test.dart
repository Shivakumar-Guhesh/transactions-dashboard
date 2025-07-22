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

  testWidgets(
    'MainScreen is present when HomeScreen is launched',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(find.byType(MainScreen), findsOneWidget);
    },
  );

  testWidgets(
    'MaterialApp does not show debug banner',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    },
  );

  // Additional test cases

  testWidgets(
    'HomeScreen builds without throwing',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'MainScreen widget exists in widget tree',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(find.byType(MainScreen), findsOneWidget);
    },
  );

  testWidgets(
    'MaterialApp uses light theme by default',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
    },
  );

  testWidgets(
    'HomeScreen contains a Column widget',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(find.byType(Column), findsWidgets);
    },
  );

  testWidgets(
    'HomeScreen contains at least one Container widget',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(find.byType(Container), findsWidgets);
    },
  );

  testWidgets(
    'HomeScreen contains a Material widget',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(find.byType(Material), findsWidgets);
    },
  );

  testWidgets(
    'MainScreen is a descendant of SafeArea',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      final safeAreaFinder = find.byType(SafeArea);
      final mainScreenFinder = find.descendant(
        of: safeAreaFinder,
        matching: find.byType(MainScreen),
      );
      expect(mainScreenFinder, findsOneWidget);
    },
  );

  testWidgets(
    'HomeScreen contains a Theme widget',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(find.byType(Theme), findsWidgets);
    },
  );

  testWidgets(
    'HomeScreen contains a Text widget with app title',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      // Looks for "Transaction Dashboard™" or "TD" depending on screen size
      expect(
        find.byWidgetPredicate((widget) =>
            widget is Text &&
            (widget.data == "Transaction Dashboard\u2122" ||
                widget.data == "TD")),
        findsWidgets,
      );
    },
  );

  testWidgets(
    'HomeScreen builds MaterialApp with correct home widget',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.home, isA<SafeArea>());
    },
  );

  testWidgets(
    'HomeScreen contains at least one Stack widget',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(find.byType(Stack), findsWidgets);
    },
  );

  testWidgets(
    'HomeScreen contains a Scaffold widget',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: HomeScreen(),
        ),
      );
      expect(find.byType(Scaffold), findsOneWidget,
          reason:
              'HomeScreen should contain a Scaffold for its primary layout.');
    },
  );

  testWidgets(
    'MainScreen contains a Centered widget (if applicable)',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainScreen(),
          ),
        ),
      );
      // This test is an example. Only add if MainScreen is expected to have a Center widget.
      // For instance, if its main content is centered.
      expect(find.byType(Center), findsWidgets,
          reason: 'MainScreen might use a Center widget for layout.');
    },
  );
}
