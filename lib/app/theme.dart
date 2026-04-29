import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CraftUiTheme {
  const CraftUiTheme._();

  static ThemeData get dark {
    return _base(Brightness.dark).copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.text,
        secondary: AppColors.primarySoft,
      ),
      snackBarTheme: _snackBarTheme(Brightness.dark),
      cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBackground,
      ),
    );
  }

  static ThemeData get light {
    return _base(Brightness.light).copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.darkText,
        secondary: AppColors.primarySoft,
      ),
      snackBarTheme: _snackBarTheme(Brightness.light),
      cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.lightBackground,
      ),
    );
  }

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? AppColors.text : AppColors.darkText;
    final mutedColor = isDark ? AppColors.muted : AppColors.lightMuted;

    final textTheme = TextTheme(
      displayLarge: TextStyle(
        color: textColor,
        fontSize: 42,
        height: 0.96,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.6,
      ),
      headlineLarge: TextStyle(
        color: textColor,
        fontSize: 34,
        height: 1.02,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.1,
      ),
      headlineMedium: TextStyle(
        color: textColor,
        fontSize: 25,
        height: 1.12,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.7,
      ),
      titleLarge: TextStyle(
        color: textColor,
        fontSize: 19,
        height: 1.18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
      ),
      titleMedium: TextStyle(
        color: textColor,
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: textColor,
        fontSize: 16,
        height: 1.45,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: mutedColor,
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.1,
      ),
      labelMedium: TextStyle(
        color: mutedColor,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: '.SF Pro Text',
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      dividerColor: isDark ? AppColors.border : Colors.black.withOpacity(0.08),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.045) : Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(18),
        hintStyle: TextStyle(color: mutedColor.withOpacity(0.78)),
      ),
    );
  }

  static SnackBarThemeData _snackBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.darkText,
      contentTextStyle: TextStyle(
        color: isDark ? AppColors.text : AppColors.lightSurface,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
    );
  }
}
