import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    this.onClick,
    this.size,
    this.title,
    this.onClickAsync,
    this.child,
    this.width,
    this.height = 50,
    this.radius,
    this.color = AppColors.baseWhite,
    this.borderColor = Colors.transparent,
    this.backgroundColor,
    this.padding,
    this.buttonTextStyle,
    this.borderWidth = 1,
  });

  final String? title;
  final VoidCallback? onClick;
  final AsyncCallback? onClickAsync;
  final Size? size;
  final Widget? child;
  final double? width;
  final double borderWidth;
  final double height;
  final double? radius;
  final Color color;
  final Color borderColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? buttonTextStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: onClickAsync ?? onClick,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 5),
          ),
          fixedSize: size,
          textStyle: TextStyle(
            color: color,
            fontSize: 14,
            letterSpacing: 0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
          backgroundColor:
              onClick == null && backgroundColor != null ? backgroundColor!.withOpacity(0.4) : backgroundColor,
          padding: padding,
        ),
        child: child ??
            Text(
              '$title',
              style: buttonTextStyle ??
                  TextStyle(
                    color: color,
                    fontSize: 14,
                    letterSpacing: 0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
            ),
      ),
    );
  }
}
