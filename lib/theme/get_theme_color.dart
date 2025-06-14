import 'package:flutter/material.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

// 1. this is one approach to get the theme colors
ThemeColor getSelectedThemeColors(BuildContext context) {
  return Theme.of(context).extension<ThemeColor>()!;
}

// 2. this is another approach to get the theme colors
extension ThemeColorContext on BuildContext {
  ThemeColor get colors => Theme.of(this).extension<ThemeColor>()!;
}
