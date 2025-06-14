import 'package:flutter/material.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class SelectableItem extends StatelessWidget {
  final double borderRadius;
  final String title;
  final Widget? rightContent;
  final Widget leftIcon;
  final Function()? itemPressed;
  final Color? backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsets padding;

  const SelectableItem({
    super.key,
    required this.title,
    required this.leftIcon,
    this.itemPressed,
    this.borderRadius = 12,
    this.rightContent,
    this.backgroundColor,
    required this.textColor,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: AppColors.primaryGray,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: Material(
        color: backgroundColor ?? AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: itemPressed != null ? () => itemPressed?.call() : null,
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left content
                SizedBox(
                  child: Row(
                    children: [
                      // Left icon
                      leftIcon,

                      const SizedBox(width: 6),

                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right content
                if (rightContent != null) ...[
                  rightContent!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
