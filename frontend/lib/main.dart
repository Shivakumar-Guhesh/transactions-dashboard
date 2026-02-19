import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'providers/theme_provider.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'shared/widgets/keyboard_shortcut_wrapper.dart';
import 'theme/app_theme.dart';

void main() async {
  await initializeDateFormatting('en_IN', null);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transaction Dashboard',
      themeMode: ref.watch(themeProvider),
      darkTheme: AppTheme.build(Brightness.dark),
      theme: AppTheme.build(Brightness.light),
      scrollBehavior: KeyboardScrollBehavior(),
      home: const DashboardScreen(),
    );
  }
}
