import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_animations.dart';
import 'app_typography.dart';

class AppTheme {
  static const String primaryFont = 'Cabin';
  static const String displayFont = 'Besley';
  static const String codeFont = 'Courier_Prime';
  static const String numberFont = 'Calculator_Script_Mt';
  static ThemeData build(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final Color textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final Color surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final Color borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final Color scaffoldColor = isDark ? AppColors.darkBg : AppColors.lightBg;

    final Color errorColor = isDark
        ? AppColors.darkError
        : AppColors.lightError;
    final Color onErrorColor = isDark
        ? AppColors.onErrorDark
        : AppColors.onErrorLight;
    final Color successColor = isDark
        ? AppColors.darkSuccess
        : AppColors.lightSuccess;
    final Color successContainer = isDark
        ? AppColors.darkSuccessContainer
        : AppColors.lightSuccessContainer;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: primaryFont,
      scaffoldBackgroundColor: scaffoldColor,

      extensions: [
        SemanticColors(
          success: successColor,
          successContainer: successContainer,
        ),
        AppTypography(
          codeStyle: TextStyle(
            fontFamily: codeFont,
            fontSize: AppSizes.fontSmall,
            color: textColor,
          ),
          codeStyleLarge: TextStyle(
            fontFamily: codeFont,
            fontSize: AppSizes.fontXXLarge,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          numberStyle: TextStyle(
            fontFamily: numberFont,
            fontSize: AppSizes.fontMedium,
            color: textColor,
          ),
          numberStyleLarge: TextStyle(
            fontFamily: numberFont,
            fontSize: AppSizes.fontXXXLarge,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        error: errorColor,
        onError: onErrorColor,
        surface: surfaceColor,
        onSurface: textColor,
        outline: borderColor,
        onSurfaceVariant: AppColors.textSecondary,

        primaryContainer: isDark
            ? AppColors.darkPrimaryContainer
            : AppColors.lightPrimaryContainer,
        errorContainer: isDark
            ? AppColors.darkErrorContainer
            : AppColors.lightErrorContainer,
        onErrorContainer: isDark
            ? AppColors.onDarkErrorContainer
            : AppColors.onLightErrorContainer,
        surfaceContainerHighest: isDark
            ? AppColors.darkBorder
            : AppColors.lightBorder,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: isDark ? AppColors.splashDark : AppColors.splashLight,

      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          // Smooth fade for web/desktop
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),

      expansionTileTheme: ExpansionTileThemeData(
        expansionAnimationStyle: AnimationStyle(
          curve: AppAnimations.curveMain,
          duration: AppAnimations.durationMedium,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorAnimation: TabIndicatorAnimation.linear,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: AppSizes.elevationMin,
        scrolledUnderElevation: AppSizes.elevationMin,
        centerTitle: false,
        shape: Border(
          bottom: BorderSide(color: borderColor, width: AppSizes.borderSmall),
        ),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.w700,
          fontFamily: primaryFont,
        ),
        iconTheme: IconThemeData(color: textColor, size: AppSizes.iconSmall),
      ),

      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.primary,
        textColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXXSmall),
        alignment: Alignment.topRight,
      ),

      bannerTheme: MaterialBannerThemeData(
        backgroundColor: surfaceColor,
        contentTextStyle: TextStyle(color: textColor, fontFamily: primaryFont),
        elevation: AppSizes.elevationMin,
        dividerColor: borderColor,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSizes.elevationMedium,
        hoverElevation: AppSizes.elevationLarge,
        highlightElevation: AppSizes.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),

        largeSizeConstraints: const BoxConstraints.tightFor(
          width: 96,
          height: 96,
        ),
        iconSize: AppSizes.iconMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: AppSizes.elevationMin,
          minimumSize: const Size(0, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontSmall,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
              foregroundColor: textColor,
              side: BorderSide(color: borderColor, width: AppSizes.borderSmall),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              minimumSize: const Size(0, AppSizes.buttonHeight),
              backgroundColor: Colors.transparent,
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                isDark ? AppColors.splashDark : AppColors.splashLight,
              ),
            ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          // foregroundColor: infoColor,
          foregroundColor: textColor,
          elevation: AppSizes.elevationMin,
          minimumSize: const Size(0, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontSmall,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: textColor,
          hoverColor: isDark ? AppColors.splashDark : AppColors.splashLight,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return borderColor;
        }),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        elevation: AppSizes.elevationMin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          side: BorderSide(color: borderColor),
        ),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontLarge,
          fontWeight: FontWeight.bold,
          fontFamily: displayFont,
        ),
        contentTextStyle: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontMedium,
        ),
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: surfaceColor,
        headerBackgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.primary,
        headerForegroundColor: isDark ? AppColors.primary : AppColors.onPrimary,
        dividerColor: borderColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          side: BorderSide(color: borderColor),
        ),
        dayStyle: TextStyle(fontFamily: primaryFont),
        yearStyle: TextStyle(fontFamily: primaryFont),

        todayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.onPrimary;
          return textColor;
        }),

        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.onPrimary;
          return textColor;
        }),
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        yearForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.onPrimary;
          return textColor;
        }),
      ),

      carouselViewTheme: CarouselViewThemeData(
        backgroundColor: surfaceColor,
        elevation: AppSizes.elevationMin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          side: BorderSide(color: borderColor),
        ),
      ),

      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) =>
            const Icon(Icons.arrow_back_ios_new_rounded),
        closeButtonIconBuilder: (context) => const Icon(Icons.close_rounded),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMedium,
          vertical: AppSizes.spaceSmall,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: AppSizes.borderMedium,
          ),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppSizes.fontSmall,
        ),
        floatingLabelStyle: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontSmall,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(
            color: errorColor,
            width: AppSizes.borderSmall,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          borderSide: BorderSide(
            color: errorColor,
            width: AppSizes.borderMedium,
          ),
        ),
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceMedium,
          vertical: AppSizes.spaceXXSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        tileColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: AppSizes.fontMedium,
        ),
        subtitleTextStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppSizes.fontXSmall,
        ),
      ),

      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: AppSizes.elevationMin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          side: BorderSide(color: borderColor),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLarge),
          ),
        ),
        showDragHandle: true,
      ),

      // Selection (Chips, Checkboxes, Navigation)
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: AppColors.primary,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMax),
        ),
        labelStyle: TextStyle(color: textColor, fontSize: AppSizes.fontSmall),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.bold,
        ),
        showCheckmark: false,
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXSmall),
        ),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        side: BorderSide(color: borderColor, width: AppSizes.borderLarge),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: AppColors.primary,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.onPrimary);
          }
          return IconThemeData(color: textColor.withValues(alpha: 0.7));
        }),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: AppSizes.fontXSmall,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return textColor;
          return textColor;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return isDark ? Colors.white10 : Colors.black12;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: displayFont,
          color: textColor,
          fontSize: AppSizes.fontXXLarge,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontFamily: displayFont,
          color: textColor,
          fontSize: AppSizes.fontXLarge,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: displayFont,
          color: textColor,
          fontSize: AppSizes.fontLarge,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          fontFamily: primaryFont,
          color: textColor,
          fontSize: AppSizes.fontXLarge,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: primaryFont,
          color: textColor,
          fontSize: AppSizes.fontLarge,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontFamily: primaryFont,
          color: textColor,
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontLarge,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontSmall,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontFamily: primaryFont,
          color: textColor,
          fontSize: AppSizes.fontMedium,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: primaryFont,
          color: textColor,
          fontSize: AppSizes.fontSmall,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontFamily: primaryFont,
          color: AppColors.textSecondary,
          fontSize: AppSizes.fontXSmall,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontMedium,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppSizes.fontSmall,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppSizes.fontXSmall,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class SemanticColors extends ThemeExtension<SemanticColors> {
  final Color? success;
  final Color? successContainer;

  SemanticColors({this.success, this.successContainer});

  @override
  SemanticColors copyWith({Color? success, Color? onSuccess}) => SemanticColors(
    success: success ?? this.success,
    successContainer: onSuccess ?? this.successContainer,
  );

  @override
  SemanticColors lerp(ThemeExtension<SemanticColors>? other, double t) {
    if (other is! SemanticColors) return this;
    return SemanticColors(
      success: Color.lerp(success, other.success, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
    );
  }
}
