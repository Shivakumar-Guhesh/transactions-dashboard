import "package:flutter/material.dart";

var lightBackground = const Color(0xFFFAFDFC);
var lightOnBackground = const Color(0xFF191C1C);

var background = const Color(0xFF191C1C);
var onBackground = const Color(0xFFE0E3E3);

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      background: Color(0xFFFAFDFC),
      onBackground: Color(0xFF191C1C),
      brightness: Brightness.light,
      primary: Color(4278218042),
      surfaceTint: Color(4278218042),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4281253488),
      onPrimaryContainer: Color(4278198798),
      secondary: Color(4281952328),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4290638280),
      onSecondaryContainer: Color(4280504884),
      tertiary: Color(4280703421),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4286620927),
      onTertiaryContainer: Color(4278196551),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294245618),
      onSurface: Color(4279639319),
      onSurfaceVariant: Color(4282206783),
      outline: Color(4285365102),
      outlineVariant: Color(4290562748),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020972),
      inversePrimary: Color(4283948940),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      background: Color(0xFFFAFDFC),
      onBackground: Color(0xFF191C1C),
      brightness: Brightness.light,
      primary: Color(4278210088),
      surfaceTint: Color(4278218042),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278224457),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280044590),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4283400029),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278205847),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4282544341),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294245618),
      onSurface: Color(4279639319),
      onSurfaceVariant: Color(4281943611),
      outline: Color(4283785815),
      outlineVariant: Color(4285562482),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020972),
      inversePrimary: Color(4283948940),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      background: Color(0xFFFAFDFC),
      onBackground: Color(0xFF191C1C),
      brightness: Brightness.light,
      primary: Color(4278200594),
      surfaceTint: Color(4278218042),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278210088),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278200594),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4280044590),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278198100),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4278205847),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294245618),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4279969565),
      outline: Color(4281943611),
      outlineVariant: Color(4281943611),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020972),
      inversePrimary: Color(4289331137),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      background: Color(0xFF191C1C),
      onBackground: Color(0xFFE0E3E3),
      brightness: Brightness.dark,
      primary: Color(4283948940),
      surfaceTint: Color(4283948940),
      onPrimary: Color(4278204700),
      primaryContainer: Color(4278233181),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4288664491),
      onSecondary: Color(4278466589),
      secondaryContainer: Color(4279649833),
      onSecondaryContainer: Color(4289387957),
      tertiary: Color(4289840639),
      onTertiary: Color(4278201458),
      tertiaryContainer: Color(4284780535),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279112975),
      onSurface: Color(4292732379),
      onSurfaceVariant: Color(4290562748),
      outline: Color(4287009927),
      outlineVariant: Color(4282206783),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292732379),
      inversePrimary: Color(4278218042),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      background: Color(0xFF191C1C),
      onBackground: Color(0xFFE0E3E3),
      brightness: Brightness.dark,
      primary: Color(4284212112),
      surfaceTint: Color(4283948940),
      onPrimary: Color(4278197002),
      primaryContainer: Color(4278233181),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4288927663),
      onSecondary: Color(4278197002),
      secondaryContainer: Color(4285242487),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4290300671),
      onTertiary: Color(4278195260),
      tertiaryContainer: Color(4284780535),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279112975),
      onSurface: Color(4294311411),
      onSurfaceVariant: Color(4290826176),
      outline: Color(4288194457),
      outlineVariant: Color(4286154618),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292732379),
      inversePrimary: Color(4278211627),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      background: Color(0xFF191C1C),
      onBackground: Color(0xFFE0E3E3),
      brightness: Brightness.dark,
      primary: Color(4293918703),
      surfaceTint: Color(4283948940),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4284212112),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293918703),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4288927663),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294769407),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4290300671),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279112975),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4293984239),
      outline: Color(4290826176),
      outlineVariant: Color(4290826176),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292732379),
      inversePrimary: Color(4278202903),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
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
