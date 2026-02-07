import 'package:flutter/material.dart';

class AppTypography extends ThemeExtension<AppTypography> {
  final TextStyle codeStyle;
  final TextStyle codeStyleLarge;
  final TextStyle numberStyle;
  final TextStyle numberStyleLarge;

  AppTypography({
    required this.codeStyle,
    required this.codeStyleLarge,
    required this.numberStyle,
    required this.numberStyleLarge,
  });

  @override
  AppTypography copyWith({
    TextStyle? codeStyle,
    TextStyle? codeStyleLarge,
    TextStyle? numberStyle,
    TextStyle? numberStyleLarge,
  }) {
    return AppTypography(
      codeStyle: codeStyle ?? this.codeStyle,
      codeStyleLarge: codeStyleLarge ?? this.codeStyleLarge,
      numberStyle: numberStyle ?? this.numberStyle,
      numberStyleLarge: numberStyleLarge ?? this.numberStyleLarge,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      codeStyle: TextStyle.lerp(codeStyle, other.codeStyle, t)!,
      codeStyleLarge: TextStyle.lerp(codeStyleLarge, other.codeStyleLarge, t)!,
      numberStyle: TextStyle.lerp(numberStyle, other.numberStyle, t)!,
      numberStyleLarge: TextStyle.lerp(
        numberStyleLarge,
        other.numberStyleLarge,
        t,
      )!,
    );
  }
}

extension AppTypographyTheme on BuildContext {
  AppTypography get typography => Theme.of(this).extension<AppTypography>()!;
}
