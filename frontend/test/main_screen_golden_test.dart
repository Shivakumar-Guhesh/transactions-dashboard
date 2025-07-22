import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:frontend/main.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  /// A minimal helper to wrap `HomeScreen` with [ProviderScope] and [MaterialApp].
  Widget buildTestableApp({
    required Widget child,
    // ThemeData theme = const ThemeData.light(),
    ThemeData? theme, // Make the parameter nullable
    bool withDirectionality = false,
    TextDirection direction = TextDirection.ltr,
  }) {
    final app = ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: child,
      ),
    );

    return withDirectionality
        ? Directionality(textDirection: direction, child: app)
        : app;
  }

  group('HomeScreen Golden Visual Tests', () {
    testGoldens('Light mode layout', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestableApp(child: const HomeScreen()),
        surfaceSize: const Size(1280, 800),
      );
      await screenMatchesGolden(tester, 'home_screen_light_mode');
    });

    testGoldens('Dark mode layout', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestableApp(
          child: const HomeScreen(),
          theme: ThemeData.dark(),
        ),
        surfaceSize: const Size(1280, 800),
      );
      await screenMatchesGolden(tester, 'home_screen_dark_mode');
    });

    testGoldens('Large desktop layout', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestableApp(child: const HomeScreen()),
        surfaceSize: const Size(1600, 900),
      );
      await screenMatchesGolden(tester, 'home_screen_large');
    });

    testGoldens('Mobile layout (iPhone X size)', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestableApp(child: const HomeScreen()),
        surfaceSize: const Size(375, 812),
      );
      await screenMatchesGolden(tester, 'home_screen_mobile');
    });

    testGoldens('Short height layout', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestableApp(child: const HomeScreen()),
        surfaceSize: const Size(1280, 400),
      );
      await screenMatchesGolden(tester, 'home_screen_short_height');
    });

    testGoldens('RTL layout rendering', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestableApp(
          child: const HomeScreen(),
          withDirectionality: true,
          direction: TextDirection.rtl,
        ),
        surfaceSize: const Size(1280, 800),
      );
      await screenMatchesGolden(tester, 'home_screen_rtl');
    });

    testGoldens('Empty UI state', (tester) async {
      await tester.pumpWidgetBuilder(
        buildTestableApp(child: const HomeScreen()),
        surfaceSize: const Size(1280, 800),
      );
      await screenMatchesGolden(tester, 'home_screen_empty_state');
    });

    testGoldens('Populated dashboard UI (stubbed)', (tester) async {
      await tester.pumpWidgetBuilder(
        ProviderScope(
          overrides: [
            // TODO: override providers with mock data for populated UI
            // e.g., dashboardDataProvider.overrideWithValue(...)
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            home: const HomeScreen(),
          ),
        ),
        surfaceSize: const Size(1280, 800),
      );
      await screenMatchesGolden(tester, 'home_screen_populated');
    });

    testGoldens('Long text handling', (tester) async {
      await tester.pumpWidgetBuilder(
        ProviderScope(
          overrides: [
            // TODO: override any text providers with long content
            // e.g., appTitleProvider.overrideWithValue("A very very very long title...")
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            home: const HomeScreen(),
          ),
        ),
        surfaceSize: const Size(1280, 800),
      );
      await screenMatchesGolden(tester, 'home_screen_long_text');
    });

    testGoldens('Drawer open state', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();

      await tester.pumpWidgetBuilder(
        ProviderScope(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              key: scaffoldKey,
              drawer: const Drawer(
                child: ListTile(title: Text('Menu Item')),
              ),
              body: const HomeScreen(),
            ),
          ),
        ),
        surfaceSize: const Size(1280, 800),
      );

      scaffoldKey.currentState?.openDrawer();
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'home_screen_drawer_open');
    });

    testGoldens('Sidebar collapsed (stubbed)', (tester) async {
      await tester.pumpWidgetBuilder(
        ProviderScope(
          overrides: [
            // TODO: Replace with actual collapsed sidebar override if applicable
            // sidebarStateProvider.overrideWithValue(SidebarState.collapsed),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            home: const HomeScreen(),
          ),
        ),
        surfaceSize: const Size(1280, 800),
      );

      await screenMatchesGolden(tester, 'home_screen_sidebar_collapsed');
    });
  });
}
