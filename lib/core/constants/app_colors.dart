import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFFFD551D);
  static const Color primarySoft = Color(0xFFFF7A45);
  static const Color darkBackground = Color(0xFF080808);
  static const Color darkSurface = Color(0xFF141414);
  static const Color darkSurfaceElevated = Color(0xFF1B1B1B);
  static const Color lightBackground = Color(0xFFF7F4EF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFFF5F5F5);
  static const Color darkText = Color(0xFF101010);
  static const Color muted = Color(0xFFA3A3A3);
  static const Color lightMuted = Color(0xFF6D6D6D);
  static const Color success = Color(0xFF55D187);
  static const Color warning = Color(0xFFFFC46B);
  static const Color border = Color(0x14FFFFFF);

  static Color surfaceFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : lightSurface;
  }

  static Color textFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? text : darkText;
  }

  static Color mutedFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? muted : lightMuted;
  }
}
