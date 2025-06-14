import 'package:flutter/material.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class ProgressCircle extends StatelessWidget {
  final double progress; // Progres u procentima (0.0 do 1.0)
  final int currentStep; // Trenutni korak
  final int totalSteps; // Ukupan broj koraka

  const ProgressCircle({
    super.key,
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: ProgressCirclePainter(progress: progress),
            size: const Size(40, 40),
          ),
          Text(
            '$currentStep/$totalSteps',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressCirclePainter extends CustomPainter {
  final double progress;

  ProgressCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Paint progressPaint = Paint()
      ..color = AppColors.baseYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;

    // Crtanje sive pozadine
    canvas.drawCircle(Offset(radius, radius), radius, backgroundPaint);

    // Crtanje napretka
    double sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
