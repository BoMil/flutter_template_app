import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template_app/core/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

/// Usage example:
///```
/// final GlobalKey<ButtonWithLoadingStateState> saveButton = GlobalKey();
///
/// _startLoadingSaveButton() {
///   if (saveButton.currentState != null) {
///     saveButton.currentState!.setLoadingIndicator(true);
///   }
/// }

/// _stopLoadingSaveButton() {
///   if (saveButton.currentState != null) {
///     saveButton.currentState!.setLoadingIndicator(false);
///   }
/// }
///
/// ButtonWithLoadingState(
///   key: saveButton,
///   buttonText: 'Save',
///  ....
/// )
/// ```
class ButtonWithLoadingState extends StatefulWidget {
  final String buttonText;
  final bool? loading;
  final void Function()? buttonPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? loaderColor;
  final double? radius;
  final Size? size;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final double height;
  final Widget? child;

  const ButtonWithLoadingState({
    super.key,
    required this.buttonText,
    this.loading,
    this.buttonPressed,
    this.backgroundColor,
    this.textColor,
    this.loaderColor,
    this.radius = 100,
    this.size,
    this.borderColor = Colors.transparent,
    this.padding,
    this.height = 50,
    this.child,
  });

  @override
  State<ButtonWithLoadingState> createState() => ButtonWithLoadingStateState();
}

class ButtonWithLoadingStateState extends State<ButtonWithLoadingState> {
  bool isLoading = false;

  setLoadingIndicator(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomOutlinedButton(
      /// size: widget.size,
      padding: widget.padding,
      height: widget.height,
      borderColor: widget.borderColor,
      backgroundColor: widget.backgroundColor ?? AppColors.textBlue,
      color: widget.textColor ?? AppColors.baseWhite,
      title: widget.buttonText,
      size: widget.size ?? Size(MediaQuery.sizeOf(context).width, 50),
      radius: widget.radius,
      onClick: widget.buttonPressed == null
          ? null
          : () {
              if (widget.loading ?? isLoading) {
                return;
              }
              widget.buttonPressed!();
            },
      child: (widget.loading ?? isLoading)
          ? CupertinoActivityIndicator(color: widget.loaderColor ?? Colors.white)
          : widget.child,
    );
  }
}
