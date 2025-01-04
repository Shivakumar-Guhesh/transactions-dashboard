import 'package:flutter/material.dart';

TextTheme createTextTheme({
  required BuildContext context,
  required String bodyFontString,
  required String displayFontString,
}) {
  // TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  TextTheme bodyTextTheme = Theme.of(context).primaryTextTheme.copyWith(
        bodyLarge: TextStyle(
          fontFamily: bodyFontString,
        ),
        // bodyLarge: bodyTextTheme.bodyLarge,
        bodyMedium: TextStyle(
          fontFamily: bodyFontString,
        ),
        bodySmall: TextStyle(
          fontFamily: bodyFontString,
        ),
        labelLarge: TextStyle(
          fontFamily: bodyFontString,
        ),
        labelMedium: TextStyle(
          fontFamily: bodyFontString,
        ),
        labelSmall: TextStyle(
          fontFamily: bodyFontString,
        ),
      );

  // TextTheme(bodyFontString, baseTextTheme);
  TextTheme displayTextTheme = Theme.of(context).primaryTextTheme.copyWith(
        displayLarge: TextStyle(
          fontFamily: displayFontString,
        ),
        displayMedium: TextStyle(
          fontFamily: displayFontString,
        ),
        displaySmall: TextStyle(
          fontFamily: displayFontString,
        ),
        headlineSmall: TextStyle(
          fontFamily: displayFontString,
        ),
        headlineLarge: TextStyle(
          fontFamily: displayFontString,
        ),
        headlineMedium: TextStyle(
          fontFamily: displayFontString,
        ),
        titleLarge: TextStyle(
          fontFamily: displayFontString,
        ),
        titleMedium: TextStyle(
          fontFamily: displayFontString,
        ),
        titleSmall: TextStyle(
          fontFamily: displayFontString,
        ),
      );

  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}
