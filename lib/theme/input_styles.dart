import 'package:flutter/material.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class InputStyles {
  static InputDecoration primaryInputDecoration({
    String lableText = '',
    String hintText = '',
    Color? fillColor,
    Widget? prefixIcon,
    Widget? suffix,
    required EdgeInsetsGeometry contentPadding,
    double borderWidth = 1,
    bool floatLabelToTop = true,
    Color borderColor = Colors.transparent,
    double borderRadius = 12,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      errorStyle: const TextStyle(
        color: AppColors.primaryRed,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      isDense: true,
      labelText: lableText,
      floatingLabelBehavior: floatLabelToTop ? FloatingLabelBehavior.auto : FloatingLabelBehavior.never,
      filled: true,
      fillColor: fillColor ?? Colors.transparent,
      labelStyle: const TextStyle(
        color: AppColors.baseBlack01,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: AppColors.baseBlack01,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      suffixIcon: suffix,
      contentPadding: contentPadding,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: AppColors.baseYellow, width: borderWidth),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: AppColors.primaryRed, width: borderWidth),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: AppColors.primaryRed, width: borderWidth),
      ),
      errorMaxLines: 3,
    );
  }

  static BoxDecoration roundedContainterBackground([Color? color]) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: const BorderRadius.all(
        Radius.circular(15.0),
      ),
    );
  }
}
