import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './providers/theme_provider.dart';
import './screens/main_screen.dart';
import './theme/generated_green_theme.dart';
// import './theme/generated_purple_theme.dart';
import './theme/generated_text_theme.dart';
import './providers/selected_categories_provider.dart';

// final sharedPreferences =
// Provider<SharedPreferences>((_) => throw UnimplementedError());
final sharedPreferences =
    Provider<SharedPreferencesWithCache>((_) => throw UnimplementedError());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final sharedPrefs = await SharedPreferences.getInstance();
  final sharedPrefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions());

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferences.overrideWithValue(sharedPrefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  build(BuildContext context, WidgetRef ref) {
    final selectedCategoriesState = ref.read(selectedCategoriesStateNotifier);
    selectedCategoriesState.fetchAndSetList();
    return const HomeScreen();
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);
    TextTheme textTheme = createTextTheme(
      context: context,
      bodyFontString: "Montserrat",
      displayFontString: "Merriweather",
    );
    return MaterialApp(
      title: 'Transactions Dashboard',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.from(
        colorScheme: MaterialTheme.darkMediumContrastScheme(),
        textTheme: textTheme,
      ),
      theme: ThemeData.from(
        colorScheme: MaterialTheme.lightMediumContrastScheme(),
        textTheme: textTheme,
      ),
      themeMode:
          appThemeState.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: const SafeArea(
        child: MainScreen(),
      ),
    );
  }
}
