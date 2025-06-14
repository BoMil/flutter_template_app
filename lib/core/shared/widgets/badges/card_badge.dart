import 'package:flutter/material.dart';

class CardBadge extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String label;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget? leftIcon;
  const CardBadge({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
    this.borderRadius = 12,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
    this.leftIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Left icon
          if (leftIcon != null) ...[
            leftIcon!,
            const SizedBox(width: 8),
          ],

          // Text
          Text(
            label,
            maxLines: 4,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
