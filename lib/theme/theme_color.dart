import 'package:flutter/material.dart';
import 'package:flutter_template_app/config/tenant/tenant_config.dart';

class ThemeColor extends ThemeExtension<ThemeColor> {
  Color primaryBackground;
  Color secondaryBackground;
  Color primaryText;
  Color brandPrimary;
  Color brandAccent;
  Color brandError;

  ThemeColor({
    required this.primaryBackground,
    required this.secondaryBackground,
    required this.primaryText,
    required this.brandPrimary,
    required this.brandAccent,
    required this.brandError,
  });

  @override
  ThemeExtension<ThemeColor> copyWith({
    Color? primaryBackground,
    Color? secondaryBackground,
    Color? primaryText,
    Color? brandPrimary,
    Color? brandAccent,
    Color? brandError,
  }) {
    return ThemeColor(
      primaryBackground: primaryBackground ?? this.primaryBackground,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      primaryText: primaryText ?? this.primaryText,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandAccent: brandAccent ?? this.brandAccent,
      brandError: brandError ?? this.brandError,
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
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      brandError: Color.lerp(brandError, other.brandError, t)!,
    );
  }
}

class AppColors {
  // Light theme
  static const Color primaryBackground = Color.fromRGBO(245, 245, 245, 1);
  static const Color secondaryBackground = Color.fromRGBO(255, 255, 255, 0.9);
  static const Color primaryText = Color.fromRGBO(15, 15, 15, 1);

  // Dark theme
  static const Color primaryBackgroundDark = Color.fromRGBO(15, 15, 15, 1);
  static const Color secondaryBackgroundDark = Color.fromRGBO(23, 23, 23, 1);
  static const Color primaryTextDark = Color.fromRGBO(255, 255, 255, 1);

  // Tenant brand colors (delegated to TenantConfig)
  static Color get baseYellow => TenantConfig().accentColor;
  static Color get primaryRed => TenantConfig().errorColor;
  static Color get secondaryText => const Color.fromRGBO(15, 15, 15, 0.5);
  static Color get textBlue => TenantConfig().primaryColor;

  // Neutral colors (constant across all tenants)
  static const Color baseBlack01 = Color.fromRGBO(23, 23, 23, 0.1);
  static const Color baseWhite = Color.fromRGBO(255, 255, 255, 1);

  // Shadows
  static const Color primaryShadowColor = Color.fromRGBO(0, 0, 0, 0.25);
}

ThemeColor lightThemeColors = ThemeColor(
  primaryBackground: AppColors.primaryBackground,
  secondaryBackground: AppColors.secondaryBackground,
  primaryText: AppColors.primaryText,
  brandPrimary: TenantConfig().primaryColor,
  brandAccent: TenantConfig().accentColor,
  brandError: TenantConfig().errorColor,
);

ThemeColor darkThemeColors = ThemeColor(
  primaryBackground: AppColors.primaryBackgroundDark,
  secondaryBackground: AppColors.secondaryBackgroundDark,
  primaryText: AppColors.primaryTextDark,
  brandPrimary: TenantConfig().primaryColor,
  brandAccent: TenantConfig().accentColor,
  brandError: TenantConfig().errorColor,
);

String colorToHex(Color color, {bool includeAlpha = false}) {
  String alpha = color.alpha.toRadixString(16).padLeft(2, '0');
  String red = color.red.toRadixString(16).padLeft(2, '0');
  String green = color.green.toRadixString(16).padLeft(2, '0');
  String blue = color.blue.toRadixString(16).padLeft(2, '0');

  return '#${includeAlpha ? alpha : ''}$red$green$blue'.toUpperCase();
}
