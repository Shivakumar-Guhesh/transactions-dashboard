import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appThemeStateNotifier = ChangeNotifierProvider((ref) => AppThemeState());

class AppThemeState extends ChangeNotifier {
  static var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  bool isDarkModeEnabled = brightness == Brightness.dark;
  // static ThemeMode systemThemeMode = ThemeMode.system;

  // void setSystemThemeMode(ThemeMode themeMode) {
  //   systemThemeMode = themeMode;
  // }

  // var isDarkModeEnabled = false;

  // var isDarkModeEnabled = ThemeMode.system == ThemeMode.light ? true : false;

  void setLightTheme() {
    isDarkModeEnabled = false;
    notifyListeners();
  }

  void setDarkTheme() {
    isDarkModeEnabled = true;
    notifyListeners();
  }
}
