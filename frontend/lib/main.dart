import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/transaction_data_provider.dart';

import 'package:frontend/screens/main_screen.dart';

import 'package:frontend/theme/generated_green_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferences =
    Provider<SharedPreferences>((_) => throw UnimplementedError());
List<String> incomes = [];
List<String> expenses = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferences.overrideWithValue(sharedPrefs),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);
    final selectedCategoriesState = ref.read(selectedCategoriesStateNotifier);
    selectedCategoriesState.fetchAndSetList();
    return MaterialApp(
      title: 'Transactions Dashboard',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.from(colorScheme: MaterialTheme.darkScheme()),
      theme: ThemeData.from(colorScheme: MaterialTheme.lightScheme()),
      themeMode:
          appThemeState.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
