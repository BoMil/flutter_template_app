import 'package:flutter/material.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class CountBadge extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final Color? backgroundColor;
  const CountBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 6.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryRed,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: padding,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            height: 1,
            color: AppColors.baseWhite,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
