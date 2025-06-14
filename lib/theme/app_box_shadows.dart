import 'package:flutter/material.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class AppBoxShadows {
  List<BoxShadow> primaryBoxShadow = [
    const BoxShadow(
      color: AppColors.primaryShadowColor,
      offset: Offset(0, 4),
      blurRadius: 4,
    ),
  ];
}
