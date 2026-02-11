import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/theme_provider.dart';
import 'screens/dashboard_screen.dart';
import 'shared/widgets/keyboard_shortcut_wrapper.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ref.watch(themeProvider),
      darkTheme: AppTheme.build(Brightness.dark),
      theme: AppTheme.build(Brightness.light),
      scrollBehavior: KeyboardScrollBehavior(),
      home: DashboardScreen(),
    );
  }
}
