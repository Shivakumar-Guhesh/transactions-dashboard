import "package:flutter/material.dart";

var lightBackground = const Color(0xFFFAFDFC);
var lightOnBackground = const Color(0xFF191C1C);

var background = const Color(0xFF191C1C);
var onBackground = const Color(0xFFE0E3E3);

class MaterialTheme {
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006d3a),
      surfaceTint: Color(0xff006d3a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2ebe70),
      onPrimaryContainer: Color(0xff00220e),
      secondary: Color(0xff396848),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffbdf1c8),
      onSecondaryContainer: Color(0xff235234),
      tertiary: Color(0xff2659bd),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff80a4ff),
      onTertiaryContainer: Color(0xff001947),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff4fcf2),
      onSurface: Color(0xff161d17),
      onSurfaceVariant: Color(0xff3d4a3f),
      outline: Color(0xff6d7b6e),
      outlineVariant: Color(0xffbccabc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b322c),
      inversePrimary: Color(0xff57df8c),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004e28),
      surfaceTint: Color(0xff006d3a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff008649),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1c4c2e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4f7f5d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003d97),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4270d5),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fcf2),
      onSurface: Color(0xff161d17),
      onSurfaceVariant: Color(0xff39463b),
      outline: Color(0xff556257),
      outlineVariant: Color(0xff707e72),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b322c),
      inversePrimary: Color(0xff57df8c),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002912),
      surfaceTint: Color(0xff006d3a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004e28),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002912),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff1c4c2e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff001f54),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff003d97),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fcf2),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1b271d),
      outline: Color(0xff39463b),
      outlineVariant: Color(0xff39463b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b322c),
      inversePrimary: Color(0xffa9ffc1),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff57df8c),
      surfaceTint: Color(0xff57df8c),
      onPrimary: Color(0xff00391c),
      primaryContainer: Color(0xff00a85d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff9fd3ab),
      onSecondary: Color(0xff04381d),
      secondaryContainer: Color(0xff164629),
      onSecondaryContainer: Color(0xffaaddb5),
      tertiary: Color(0xffb1c5ff),
      onTertiary: Color(0xff002c72),
      tertiaryContainer: Color(0xff648ff7),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e150f),
      onSurface: Color(0xffdde5db),
      onSurfaceVariant: Color(0xffbccabc),
      outline: Color(0xff869487),
      outlineVariant: Color(0xff3d4a3f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde5db),
      inversePrimary: Color(0xff006d3a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff5be390),
      surfaceTint: Color(0xff57df8c),
      onPrimary: Color(0xff001b0a),
      primaryContainer: Color(0xff00a85d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffa3d7af),
      onSecondary: Color(0xff001b0a),
      secondaryContainer: Color(0xff6b9c77),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb8caff),
      onTertiary: Color(0xff00143c),
      tertiaryContainer: Color(0xff648ff7),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e150f),
      onSurface: Color(0xfff5fdf3),
      onSurfaceVariant: Color(0xffc0cfc0),
      outline: Color(0xff98a799),
      outlineVariant: Color(0xff79877a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde5db),
      inversePrimary: Color(0xff00542b),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffefffef),
      surfaceTint: Color(0xff57df8c),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff5be390),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffefffef),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffa3d7af),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffcfaff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffb8caff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e150f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff0ffef),
      outline: Color(0xffc0cfc0),
      outlineVariant: Color(0xffc0cfc0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde5db),
      inversePrimary: Color(0xff003217),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        fontFamily: 'Courier Prime',
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
