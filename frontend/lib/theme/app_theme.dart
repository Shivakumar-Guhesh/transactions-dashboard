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
        ? AppColors.errorDark
        : AppColors.errorLight;
    final Color onErrorColor = isDark
        ? AppColors.onErrorDark
        : AppColors.onErrorLight;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: primaryFont,
      scaffoldBackgroundColor: scaffoldColor,

      extensions: [
        AppTypography(
          codeStyle: TextStyle(
            fontFamily: codeFont,
            fontSize: AppSizes.fontBody,
            color: textColor,
          ),
          codeStyleLarge: TextStyle(
            fontFamily: codeFont,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          numberStyle: TextStyle(
            fontFamily: numberFont,
            fontSize: AppSizes.fontBody,
            color: textColor,
          ),
          numberStyleLarge: TextStyle(
            fontFamily: numberFont,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],

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
        indicatorAnimation: TabIndicatorAnimation.linear, // Or custom
      ),
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

        // M3 specific containers
        primaryContainer: isDark
            ? const Color(0xFF3F3F46)
            : AppColors.primary.withValues(alpha: 0.2),
        errorContainer: isDark
            ? const Color(0xFF450a0a)
            : const Color(0xFFfee2e2),
        onErrorContainer: isDark
            ? const Color(0xFFfca5a5)
            : const Color(0xFF991b1b),
        surfaceContainerHighest: isDark
            ? AppColors.darkBorder
            : AppColors.lightBorder,
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return borderColor;
        }),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: textColor,
          hoverColor: isDark ? AppColors.splashDark : AppColors.splashLight,
        ),
      ),

      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.primary,
        textColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.topRight,
      ),

      bannerTheme: MaterialBannerThemeData(
        backgroundColor: surfaceColor,
        contentTextStyle: TextStyle(color: textColor, fontFamily: primaryFont),
        elevation: 0,
        dividerColor: borderColor,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius16),
          side: BorderSide(color: borderColor),
        ),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: displayFont,
        ),
        contentTextStyle: TextStyle(color: textColor, fontSize: 16),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        shape: Border(bottom: BorderSide(color: borderColor, width: 1)),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: primaryFont,
        ),
        iconTheme: IconThemeData(color: textColor, size: AppSizes.iconSm),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
          borderRadius: BorderRadius.circular(AppSizes.radius16),
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
        // Also applies to the year selector
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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius16),
          side: BorderSide(color: borderColor),
        ),
      ),

      actionIconTheme: ActionIconThemeData(
        // Makes the back button consistent across platforms if desired
        backButtonIconBuilder: (context) =>
            const Icon(Icons.arrow_back_ios_new_rounded),
        // Customizes the 'End of Scroll' or 'Close' icons for specific actions
        closeButtonIconBuilder: (context) => const Icon(Icons.close_rounded),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
              foregroundColor: textColor,
              side: BorderSide(color: borderColor, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius8),
              ),
              minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
              backgroundColor: Colors.transparent,
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                isDark ? AppColors.splashDark : AppColors.splashLight,
              ),
            ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4, // Slightly higher than buttons to denote floating
        hoverElevation: 6,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.radius12,
          ), // Or AppSizes.radius16 for a softer look
        ),
        // Ensures consistent sizing across the app
        largeSizeConstraints: const BoxConstraints.tightFor(
          width: 96,
          height: 96,
        ),
        iconSize: AppSizes.iconMd,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        floatingLabelStyle: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontBody,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius8),
          borderSide: BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius8),
          borderSide: BorderSide(color: errorColor, width: 1.5),
        ),
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius8),
        ),
        tileColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        subtitleTextStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),

      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius12),
          side: BorderSide(color: borderColor),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radius16),
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
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
        labelStyle: TextStyle(color: textColor, fontSize: AppSizes.fontBody),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.bold,
        ),
        showCheckmark: false,
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        side: BorderSide(color: borderColor, width: 2),
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
            fontSize: 12,
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
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontFamily: displayFont,
          color: textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: displayFont,
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          fontFamily: primaryFont,
          color: textColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: primaryFont,
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontFamily: primaryFont,
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textColor,
          fontSize: AppSizes.fontTitle,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontFamily: primaryFont,
          color: textColor,
          fontSize: AppSizes.fontLabel,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: primaryFont,
          color: textColor,
          fontSize: AppSizes.fontBody,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontFamily: primaryFont,
          color: AppColors.textSecondary,
          fontSize: 12,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppSizes.fontCaption,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
