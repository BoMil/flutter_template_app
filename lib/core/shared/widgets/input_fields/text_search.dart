import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_template_app/core/shared/widgets/input_fields/primary_input_field.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class TextSearch extends StatefulWidget {
  final void Function(String text) onTypingComplete;
  final String hintText;
  final double fontSize;
  final double borderRadius;
  final Color? inputBackgroundCollor;
  final String placeholderText;
  final bool floatLabelToTop;
  final EdgeInsetsGeometry contentPadding;
  final double minContainerHeight;

  const TextSearch({
    super.key,
    required this.onTypingComplete,
    this.hintText = 'Search ...',
    this.fontSize = 14.0,
    this.borderRadius = 10.0,
    this.inputBackgroundCollor,
    this.placeholderText = '',
    this.contentPadding = const EdgeInsets.only(bottom: 19, left: 16, top: 19),
    this.floatLabelToTop = true,
    this.minContainerHeight = 83,
  });

  @override
  State createState() => _TextSearchState();
}

class _TextSearchState extends State<TextSearch> {
  final TextEditingController _controller = TextEditingController();
  Timer? debounceSearch;

  @override
  void dispose() {
    _controller.dispose();
    debounceSearch?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryInputField(
      minContainerHeight: widget.minContainerHeight,
      controller: _controller,
      placeholderText: widget.placeholderText,
      hintText: widget.hintText,
      inputBackgroundCollor: widget.inputBackgroundCollor ?? AppColors.secondaryBackground,
      sufixIcon: null,
      prefixIcon: const Icon(Icons.search_sharp),
      contentPadding: widget.contentPadding,
      floatLabelToTop: widget.floatLabelToTop,
      onChanged: (text) {
        debounceSearch?.cancel();

        debounceSearch = Timer(const Duration(milliseconds: 500), () {
          widget.onTypingComplete(text);
          debounceSearch = null;
        });
      },
    );
  }
}
