import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template_app/theme/input_styles.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class PrimaryInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? errorMsg;
  final bool? readOnly;
  final Function(String)? onChanged;
  final Widget? sufixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final int? areaField;
  final bool passwordFieldVisible;
  final Color labelColor;
  final EdgeInsetsGeometry contentPadding;
  final String placeholderText;
  final String hintText;
  final Color? inputBackgroundCollor;
  final double minContainerHeight;
  final String? Function(String? value)? customValidator;
  final bool autoValidate;
  final bool floatLabelToTop;
  final bool enabled;
  final Function(bool)? onFocusChanged;
  final Color borderColor;
  final double borderRadius;
  final bool isCurrency;

  const PrimaryInputField({
    super.key,
    required this.controller,
    this.labelText = '',
    this.errorMsg,
    this.readOnly,
    this.onChanged,
    this.sufixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.areaField,
    this.labelColor = AppColors.baseBlack01,
    this.passwordFieldVisible = false,
    this.placeholderText = '',
    this.hintText = '',
    this.contentPadding = const EdgeInsets.only(bottom: 19, left: 16, top: 19),
    this.inputBackgroundCollor,
    this.minContainerHeight = 83,
    this.customValidator,
    this.autoValidate = false,
    this.floatLabelToTop = true,
    this.onFocusChanged,
    this.enabled = true,
    this.borderColor = Colors.transparent,
    this.borderRadius = 12,
    this.isCurrency = false,
  });

  @override
  State<PrimaryInputField> createState() => _PrimaryInputFieldState();
}

class _PrimaryInputFieldState extends State<PrimaryInputField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.onFocusChanged == null) {
      return;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
  }

  void _onFocusChange() {
    widget.onFocusChanged?.call(_focusNode.hasFocus);
    // debugPrint('Focus ${widget.placeholderText}: ${_focusNode.hasFocus.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: widget.minContainerHeight),
      child: Column(
        children: [
          TextFormField(
            enabled: widget.enabled,
            focusNode: _focusNode,
            autovalidateMode: widget.autoValidate ? AutovalidateMode.always : null,
            style: const TextStyle(color: AppColors.baseBlack01),
            cursorColor: AppColors.textBlue,
            obscureText: widget.passwordFieldVisible,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.keyboardType != null
                ? <TextInputFormatter>[
                    if (widget.keyboardType == TextInputType.number && widget.isCurrency) ...[
                      FilteringTextInputFormatter.allow(RegExp(r'^[0-9.,]+$')),
                    ] else if (widget.keyboardType == TextInputType.number) ...[
                      FilteringTextInputFormatter.allow(RegExp(r'^[^a-zA-Z]+$')),
                    ]
                  ]
                : null,
            onChanged: (value) => widget.onChanged?.call(value),
            readOnly: widget.readOnly ?? false,
            maxLines: widget.areaField ?? 1,
            controller: widget.controller,
            decoration: InputStyles.primaryInputDecoration(
              lableText: widget.placeholderText,
              hintText: widget.hintText,
              fillColor: widget.inputBackgroundCollor ?? AppColors.baseYellow,
              suffix: widget.sufixIcon,
              prefixIcon: widget.prefixIcon,
              contentPadding: widget.contentPadding,
              floatLabelToTop: widget.floatLabelToTop,
              borderColor: widget.borderColor,
              borderRadius: widget.borderRadius,
            ),
            validator: (value) {
              if (widget.customValidator != null) {
                return widget.customValidator!(value);
              }
              if (value == null || value.isEmpty) {
                return widget.errorMsg ?? 'Field is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
