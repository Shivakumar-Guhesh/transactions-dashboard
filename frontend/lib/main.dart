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
  // incomes = sharedPrefs.getStringList("incomes") ?? [];
  // expenses = sharedPrefs.getStringList("expenses") ?? [];
  // List<string> expenses

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
    // for (var category in incomes) {
    //   selectedCategoriesState.addDeSelectedIncomeCategory(category);
    // }
    // for (var category in expenses) {
    //   selectedCategoriesState.addDeSelectedExpenseCategory(category);
    // }
    selectedCategoriesState.fetchAndSetList();
    return MaterialApp(
      title: 'Transactions Dashboard',
      debugShowCheckedModeBanner: false,
      // darkTheme: CustomTheme.darkThemeData(),
      // theme: CustomTheme.lightThemeData(context),
      // darkTheme: ThemeData.from(colorScheme: darkColors),
      darkTheme: ThemeData.from(colorScheme: MaterialTheme.darkScheme()),
      theme: ThemeData.from(colorScheme: MaterialTheme.lightScheme()),
      // theme: ThemeData.from(colorScheme: lightColors),
      // theme: ThemeData.from(
      //   colorScheme: ColorScheme.fromSeed(
      //       seedColor: Colors.green, brightness: Brightness.light),
      //   // colorSchemeSeed: Color.fromRGBO(188, 0, 74, 1.0)
      // ),
      // theme: AppTheme.lightTheme,
      themeMode:
          appThemeState.isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
