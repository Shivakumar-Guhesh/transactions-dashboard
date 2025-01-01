import "package:flutter/material.dart";

class MaterialTheme {
  static ColorScheme lightScheme() {
    return const ColorScheme(
      background: Color(0xFFFAFDFC),
      onBackground: Color(0xFF191C1C),
      brightness: Brightness.light,
      primary: Color(4287889543),
      surfaceTint: Color(4289462430),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4291633595),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4287904902),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294943465),
      onSecondaryContainer: Color(4284352086),
      tertiary: Color(4288872499),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4292749137),
      onTertiaryContainer: Color(4294967295),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294965241),
      onSurface: Color(4280555552),
      onSurfaceVariant: Color(4283777359),
      outline: Color(4287131776),
      outlineVariant: Color(4292526032),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282002486),
      inversePrimary: Color(4294946026),
      // primaryFixed: Color(4294957041),
      // onPrimaryFixed: Color(4281925684),
      // primaryFixedDim: Color(4294946026),
      // onPrimaryFixedVariant: Color(4286840952),
      // secondaryFixed: Color(4294957041),
      // onSecondaryFixed: Color(4281925684),
      // secondaryFixedDim: Color(4294946026),
      // onSecondaryFixedVariant: Color(4286063212),
      // tertiaryFixed: Color(4294957787),
      // onTertiaryFixed: Color(4282384399),
      // tertiaryFixedDim: Color(4294947512),
      // onTertiaryFixedVariant: Color(4287692845),
      // surfaceDim: Color(4293580000),
      // surfaceBright: Color(4294965241),
      // surfaceContainerLowest: Color(4294967295),
      // surfaceContainerLow: Color(4294963447),
      // surfaceContainer: Color(4294895860),
      // surfaceContainerHigh: Color(4294501103),
      // surfaceContainerHighest: Color(4294106601),
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
      primary: Color(4286382194),
      surfaceTint: Color(4289462430),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4291633595),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4285734504),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4289614750),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4287234090),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4292749137),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965241),
      onSurface: Color(4280555552),
      onSurfaceVariant: Color(4283514187),
      outline: Color(4285421927),
      outlineVariant: Color(4287329411),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282002486),
      inversePrimary: Color(4294946026),
      // primaryFixed: Color(4291633595),
      // onPrimaryFixed: Color(4294967295),
      // primaryFixedDim: Color(4289200282),
      // onPrimaryFixedVariant: Color(4294967295),
      // secondaryFixed: Color(4289614750),
      // onSecondaryFixed: Color(4294967295),
      // secondaryFixedDim: Color(4287707523),
      // onSecondaryFixedVariant: Color(4294967295),
      // tertiaryFixed: Color(4292749137),
      // onTertiaryFixed: Color(4294967295),
      // tertiaryFixedDim: Color(4290314300),
      // onTertiaryFixedVariant: Color(4294967295),
      // surfaceDim: Color(4293580000),
      // surfaceBright: Color(4294965241),
      // surfaceContainerLowest: Color(4294967295),
      // surfaceContainerLow: Color(4294963447),
      // surfaceContainer: Color(4294895860),
      // surfaceContainerHigh: Color(4294501103),
      // surfaceContainerHighest: Color(4294106601),
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
      primary: Color(4282712126),
      surfaceTint: Color(4289462430),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4286382194),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282712126),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285734504),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4283236371),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4287234090),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965241),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4281343787),
      outline: Color(4283514187),
      outlineVariant: Color(4283514187),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4282002486),
      inversePrimary: Color(4294960628),
      // primaryFixed: Color(4286382194),
      // onPrimaryFixed: Color(4294967295),
      // primaryFixedDim: Color(4283891791),
      // onPrimaryFixedVariant: Color(4294967295),
      // secondaryFixed: Color(4285734504),
      // onSecondaryFixed: Color(4294967295),
      // secondaryFixedDim: Color(4283891791),
      // onSecondaryFixedVariant: Color(4294967295),
      // tertiaryFixed: Color(4287234090),
      // onTertiaryFixed: Color(4294967295),
      // tertiaryFixedDim: Color(4284481563),
      // onTertiaryFixedVariant: Color(4294967295),
      // surfaceDim: Color(4293580000),
      // surfaceBright: Color(4294965241),
      // surfaceContainerLowest: Color(4294967295),
      // surfaceContainerLow: Color(4294963447),
      // surfaceContainer: Color(4294895860),
      // surfaceContainerHigh: Color(4294501103),
      // surfaceContainerHighest: Color(4294106601),
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
      primary: Color(4294946026),
      surfaceTint: Color(4294946026),
      onPrimary: Color(4284285013),
      primaryContainer: Color(4291633595),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4294946026),
      onSecondary: Color(4284220244),
      secondaryContainer: Color(4285339746),
      onSecondaryContainer: Color(4294950637),
      tertiary: Color(4294947512),
      onTertiary: Color(4284940317),
      tertiaryContainer: Color(4292749137),
      onTertiaryContainer: Color(4294967295),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279963672),
      onSurface: Color(4294106601),
      onSurfaceVariant: Color(4292526032),
      outline: Color(4288842394),
      outlineVariant: Color(4283777359),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294106601),
      inversePrimary: Color(4289462430),
      // primaryFixed: Color(4294957041),
      // onPrimaryFixed: Color(4281925684),
      // primaryFixedDim: Color(4294946026),
      // onPrimaryFixedVariant: Color(4286840952),
      // secondaryFixed: Color(4294957041),
      // onSecondaryFixed: Color(4281925684),
      // secondaryFixedDim: Color(4294946026),
      // onSecondaryFixedVariant: Color(4286063212),
      // tertiaryFixed: Color(4294957787),
      // onTertiaryFixed: Color(4282384399),
      // tertiaryFixedDim: Color(4294947512),
      // onTertiaryFixedVariant: Color(4287692845),
      // surfaceDim: Color(4279963672),
      // surfaceBright: Color(4282594622),
      // surfaceContainerLowest: Color(4279569171),
      // surfaceContainerLow: Color(4280555552),
      // surfaceContainer: Color(4280818724),
      // surfaceContainerHigh: Color(4281542191),
      // surfaceContainerHighest: Color(4282265914),
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
      primary: Color(4294947819),
      surfaceTint: Color(4294946026),
      onPrimary: Color(4281335851),
      primaryContainer: Color(4293937370),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294947819),
      onSecondary: Color(4281335851),
      secondaryContainer: Color(4291784636),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294949054),
      onTertiary: Color(4281729035),
      tertiaryContainer: Color(4294922350),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279963672),
      onSurface: Color(4294965754),
      onSurfaceVariant: Color(4292854740),
      outline: Color(4290092204),
      outlineVariant: Color(4287921292),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294106601),
      inversePrimary: Color(4286972026),
      // primaryFixed: Color(4294957041),
      // onPrimaryFixed: Color(4280746019),
      // primaryFixedDim: Color(4294946026),
      // onPrimaryFixedVariant: Color(4284940382),
      // secondaryFixed: Color(4294957041),
      // onSecondaryFixed: Color(4280746019),
      // secondaryFixedDim: Color(4294946026),
      // onSecondaryFixedVariant: Color(4284681562),
      // tertiaryFixed: Color(4294957787),
      // onTertiaryFixed: Color(4281073672),
      // tertiaryFixedDim: Color(4294947512),
      // onTertiaryFixedVariant: Color(4285661217),
      // surfaceDim: Color(4279963672),
      // surfaceBright: Color(4282594622),
      // surfaceContainerLowest: Color(4279569171),
      // surfaceContainerLow: Color(4280555552),
      // surfaceContainer: Color(4280818724),
      // surfaceContainerHigh: Color(4281542191),
      // surfaceContainerHighest: Color(4282265914),
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
      primary: Color(4294965754),
      surfaceTint: Color(4294946026),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294947819),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965754),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4294947819),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965753),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294949054),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279963672),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294965754),
      outline: Color(4292854740),
      outlineVariant: Color(4292854740),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294106601),
      inversePrimary: Color(4283564107),
      // primaryFixed: Color(4294958579),
      // onPrimaryFixed: Color(4278190080),
      // primaryFixedDim: Color(4294947819),
      // onPrimaryFixedVariant: Color(4281335851),
      // secondaryFixed: Color(4294958579),
      // onSecondaryFixed: Color(4278190080),
      // secondaryFixedDim: Color(4294947819),
      // onSecondaryFixedVariant: Color(4281335851),
      // tertiaryFixed: Color(4294959073),
      // onTertiaryFixed: Color(4278190080),
      // tertiaryFixedDim: Color(4294949054),
      // onTertiaryFixedVariant: Color(4281729035),
      // surfaceDim: Color(4279963672),
      // surfaceBright: Color(4282594622),
      // surfaceContainerLowest: Color(4279569171),
      // surfaceContainerLow: Color(4280555552),
      // surfaceContainer: Color(4280818724),
      // surfaceContainerHigh: Color(4281542191),
      // surfaceContainerHighest: Color(4282265914),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        // textTheme: textTheme.apply(
        //   bodyColor: colorScheme.onSurface,
        //   displayColor: colorScheme.onSurface,
        // ),
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
