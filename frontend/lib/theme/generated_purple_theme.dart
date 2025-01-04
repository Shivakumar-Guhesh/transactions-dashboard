import "package:flutter/material.dart";

class MaterialTheme {
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff940087),
      surfaceTint: Color(0xffac009e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffcd21bb),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff943c86),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffa2e9),
      onSecondaryContainer: Color(0xff5e0656),
      tertiary: Color(0xffa30033),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffde2751),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff7f9),
      onSurface: Color(0xff241820),
      onSurfaceVariant: Color(0xff55414f),
      outline: Color(0xff887080),
      outlineVariant: Color(0xffdabfd0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3a2c36),
      inversePrimary: Color(0xffffacea),
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
      brightness: Brightness.light,
      primary: Color(0xff7d0072),
      surfaceTint: Color(0xffac009e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffcd21bb),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff731e68),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffae539e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff8a002a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffde2751),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff7f9),
      onSurface: Color(0xff241820),
      onSurfaceVariant: Color(0xff513d4b),
      outline: Color(0xff6e5967),
      outlineVariant: Color(0xff8b7483),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3a2c36),
      inversePrimary: Color(0xffffacea),
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
      brightness: Brightness.light,
      primary: Color(0xff45003e),
      surfaceTint: Color(0xffac009e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7d0072),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff45003e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff731e68),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4d0013),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8a002a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff7f9),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff301f2b),
      outline: Color(0xff513d4b),
      outlineVariant: Color(0xff513d4b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3a2c36),
      inversePrimary: Color(0xffffe5f4),
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
      brightness: Brightness.dark,
      primary: Color(0xffffacea),
      surfaceTint: Color(0xffffacea),
      onPrimary: Color(0xff5d0055),
      primaryContainer: Color(0xffcd21bb),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffffacea),
      onSecondary: Color(0xff5c0354),
      secondaryContainer: Color(0xff6d1862),
      onSecondaryContainer: Color(0xffffbeed),
      tertiary: Color(0xffffb2b8),
      onTertiary: Color(0xff67001d),
      tertiaryContainer: Color(0xffde2751),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1b1018),
      onSurface: Color(0xfff2dde9),
      onSurfaceVariant: Color(0xffdabfd0),
      outline: Color(0xffa28a9a),
      outlineVariant: Color(0xff55414f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff2dde9),
      inversePrimary: Color(0xffac009e),
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
      brightness: Brightness.dark,
      primary: Color(0xffffb3eb),
      surfaceTint: Color(0xffffacea),
      onPrimary: Color(0xff30002b),
      primaryContainer: Color(0xfff048da),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffb3eb),
      onSecondary: Color(0xff30002b),
      secondaryContainer: Color(0xffcf6fbc),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffb8be),
      onTertiary: Color(0xff36000b),
      tertiaryContainer: Color(0xffff506e),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1b1018),
      onSurface: Color(0xfffff9fa),
      onSurfaceVariant: Color(0xffdfc3d4),
      outline: Color(0xffb59cac),
      outlineVariant: Color(0xff947c8c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff2dde9),
      inversePrimary: Color(0xff86007a),
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
      brightness: Brightness.dark,
      primary: Color(0xfffff9fa),
      surfaceTint: Color(0xffffacea),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb3eb),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9fa),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffb3eb),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffb8be),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1b1018),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9fa),
      outline: Color(0xffdfc3d4),
      outlineVariant: Color(0xffdfc3d4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff2dde9),
      inversePrimary: Color(0xff52004b),
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
        scaffoldBackgroundColor: colorScheme.surface,
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
