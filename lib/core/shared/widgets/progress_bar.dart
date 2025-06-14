import 'package:flutter/material.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class ProgressBar extends StatelessWidget {
  final double progressValue;
  final double height;
  final double width;

  final Color? barColor;
  const ProgressBar({
    super.key,
    required this.progressValue,
    this.height = 4,
    this.width = 56,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.white30,
            valueColor: AlwaysStoppedAnimation<Color>(barColor ?? AppColors.baseYellow),
          ),
        ),
      ),
    );
  }
}
