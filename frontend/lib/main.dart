import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/theme_provider.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text('MainApp')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
        tooltip: 'Toggle',
        child: brightness == Brightness.dark
            ? const Icon(Icons.light_mode_outlined)
            : const Icon(Icons.dark_mode_outlined),
      ),
    );
  }
}
