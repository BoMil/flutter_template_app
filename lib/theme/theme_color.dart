import 'package:flutter/material.dart';

class ThemeColor extends ThemeExtension<ThemeColor> {
  Color primaryBackground;
  Color secondaryBackground;

  ThemeColor({
    required this.primaryBackground,
    required this.secondaryBackground,
  });

  @override
  ThemeExtension<ThemeColor> copyWith({Color? primaryBackground, Color? secondaryBackground}) {
    return ThemeColor(
      primaryBackground: primaryBackground ?? this.primaryBackground,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
    );
  }

  @override
  ThemeExtension<ThemeColor> lerp(covariant ThemeExtension<ThemeColor>? other, double t) {
    if (other is! ThemeColor) {
      return this;
    }
    return ThemeColor(
      primaryBackground: Color.lerp(primaryBackground, other.primaryBackground, t)!,
      secondaryBackground: Color.lerp(secondaryBackground, other.secondaryBackground, t)!,
    );
  }
}

class AppColors {
  // Light theme
  static const Color primaryBackground = Color.fromRGBO(245, 245, 245, 1);
  static const Color secondaryBackground = Color.fromRGBO(255, 255, 255, 0.9);

  // Dark theme
  static const Color primaryBackgroundDark = Color.fromRGBO(15, 15, 15, 1);
  static const Color secondaryBackgroundDark = Color.fromRGBO(23, 23, 23, 1);

  // ****************** Other colors ******************
  static const Color baseYellow = Color.fromRGBO(239, 200, 75, 1.0);
  static const Color primaryRed = Color.fromRGBO(235, 46, 37, 1);
  static const Color primaryText = Color.fromRGBO(15, 15, 15, 0.7);
  static const Color textBlue = Color.fromRGBO(0, 122, 255, 1);
  static const Color baseBlack01 = Color.fromRGBO(23, 23, 23, 0.1);
  static const Color baseWhite = Color.fromRGBO(255, 255, 255, 1);

  // Shadows
  static const Color primaryShadowColor = Color.fromRGBO(0, 0, 0, 0.25);
}

ThemeColor lightThemeColors = ThemeColor(
  primaryBackground: AppColors.primaryBackground,
  secondaryBackground: AppColors.secondaryBackground,
);

ThemeColor darkThemeColors = ThemeColor(
  primaryBackground: AppColors.primaryBackgroundDark,
  secondaryBackground: AppColors.secondaryBackgroundDark,
);

String colorToHex(Color color, {bool includeAlpha = false}) {
  String alpha = color.alpha.toRadixString(16).padLeft(2, '0');
  String red = color.red.toRadixString(16).padLeft(2, '0');
  String green = color.green.toRadixString(16).padLeft(2, '0');
  String blue = color.blue.toRadixString(16).padLeft(2, '0');

  return '#${includeAlpha ? alpha : ''}$red$green$blue'.toUpperCase();
}
