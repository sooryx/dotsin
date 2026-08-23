import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Font families mirror the Figma layer styles exactly:
/// Orbitron (tech headings/values), Exo 2 (titles/chips), Poppins (drawer),
/// Open Sans (risk tiles/about), Space Grotesk (callouts), Space Mono (labels),
/// Inter (gauge/axis numerals), Red Rose (recommendation body).
class T {
  static TextStyle orbitron(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.white,
    double? height,
    double? spacing,
  }) =>
      GoogleFonts.orbitron(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height == null ? null : height / size,
        letterSpacing: spacing,
      );

  static TextStyle exo(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.white,
    double? height,
    double? spacing,
  }) =>
      GoogleFonts.exo2(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height == null ? null : height / size,
        letterSpacing: spacing,
      );

  static TextStyle poppins(
    double size, {
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.white,
  }) =>
      GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);

  static TextStyle openSans(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.white,
    double? height,
    double? spacing,
  }) =>
      GoogleFonts.openSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height == null ? null : height / size,
        letterSpacing: spacing,
      );

  static TextStyle grotesk(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.gray100,
  }) =>
      GoogleFonts.spaceGrotesk(fontSize: size, fontWeight: weight, color: color);

  static TextStyle mono(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.white,
    double? spacing,
  }) =>
      GoogleFonts.spaceMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: spacing,
      );

  static TextStyle inter(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.white,
  }) =>
      GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);

  static TextStyle redRose(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.white,
    double? height,
  }) =>
      GoogleFonts.redRose(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height == null ? null : height / size,
      );
}

class AppTheme {
  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.black,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.neonGreen,
          secondary: AppColors.cyanSolid,
          surface: AppColors.black,
          error: AppColors.calloutRed,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          },
        ),
        useMaterial3: true,
      );
}
