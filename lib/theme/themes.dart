import 'package:flutter/material.dart';
import 'package:flutter_template_app/config/tenant/tenant_config.dart';

import 'theme_color.dart';

class Themes {
  static ThemeData light = ThemeData.light().copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      },
    ),
    colorScheme: ThemeData.light().colorScheme.copyWith(
      primary: TenantConfig().primaryColor,
      secondary: TenantConfig().accentColor,
      error: TenantConfig().errorColor,
    ),
    extensions: <ThemeExtension<dynamic>>[
      lightThemeColors,
    ],
  );

  static ThemeData dark = ThemeData.dark().copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      },
    ),
    colorScheme: ThemeData.dark().colorScheme.copyWith(
      primary: TenantConfig().primaryColor,
      secondary: TenantConfig().accentColor,
      error: TenantConfig().errorColor,
    ),
    extensions: <ThemeExtension<dynamic>>[darkThemeColors],
  );
}
