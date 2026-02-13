import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleTheme() {
    final currentMode = state;

    if (currentMode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      state = (brightness == Brightness.dark)
          ? ThemeMode.light
          : ThemeMode.dark;
    } else {
      state = (currentMode == ThemeMode.dark)
          ? ThemeMode.light
          : ThemeMode.dark;
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);

  if (themeMode == ThemeMode.system) {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  return themeMode == ThemeMode.dark;
});
