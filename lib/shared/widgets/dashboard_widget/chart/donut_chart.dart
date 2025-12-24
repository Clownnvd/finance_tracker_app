import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'donut_segment.dart';

class DonutChart extends StatelessWidget {
  final List<DonutSegment> segments;
  final double strokeWidth;
  final double gapRadians;

  const DonutChart({
    super.key,
    required this.segments,
    required this.strokeWidth,
    required this.gapRadians,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DonutChartPainter(
        segments: segments,
        strokeWidth: strokeWidth,
        gapRadians: gapRadians,
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final double strokeWidth;
  final double gapRadians;

  const _DonutChartPainter({
    required this.segments,
    required this.strokeWidth,
    required this.gapRadians,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - strokeWidth / 2;

    final total = segments.fold<double>(0, (s, e) => s + e.value);
    if (total <= 0) return;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.neutral200;

    canvas.drawCircle(center, radius, bgPaint);

    var start = -1.5707963267948966;

    for (final seg in segments) {
      final sweep = (seg.value / total) * 6.283185307179586;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = seg.color;

      final trimmed = (sweep - gapRadians).clamp(0.0, 6.283185307179586);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        trimmed,
        false,
        paint,
      );

      start += sweep;
    }

    final holePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.white;

    canvas.drawCircle(center, radius - strokeWidth * 0.72, holePaint);
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter old) {
    return old.strokeWidth != strokeWidth ||
        old.gapRadians != gapRadians ||
        old.segments.length != segments.length;
  }
}
