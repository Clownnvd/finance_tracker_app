import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/monthly_trend.dart';
import '../../../domain/value_objects/report_month.dart';

class LineChart extends StatelessWidget {
  const LineChart({super.key, required this.trend});

  final MonthlyTrend trend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _LineChartPainter(trend),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Legend
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(color: AppColors.primary, label: 'Income'),
            SizedBox(width: AppSpacing.lg),
            _LegendItem(color: AppColors.secondary, label: 'Expense'),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter(this.t);

  final MonthlyTrend t;

  static const _monthLabels = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 40.0; // Space for Y-axis labels
    const rightPad = 8.0;
    const topPad = 8.0;
    const bottomPad = 20.0; // Space for X-axis labels

    final plot = Rect.fromLTWH(
      leftPad,
      topPad,
      (size.width - leftPad - rightPad).clamp(0, double.infinity),
      (size.height - topPad - bottomPad).clamp(0, double.infinity),
    );
    if (plot.width <= 0 || plot.height <= 0) return;

    // ===== Find max value =====
    double maxV = 0;
    for (var m = 1; m <= 12; m++) {
      final rm = ReportMonth(year: t.year, month: m);
      maxV = math.max(maxV, t.incomeOf(rm).value);
      maxV = math.max(maxV, t.expenseOf(rm).value);
    }
    // Round up to nice number for grid
    if (maxV <= 0) maxV = 1000;
    final gridMax = _niceMax(maxV);

    // ===== Draw grid lines and Y-axis labels =====
    _drawGrid(canvas, plot, gridMax);

    // ===== Draw X-axis labels =====
    _drawXLabels(canvas, plot);

    // ===== Draw data lines =====
    Offset pointFor(int month, double v) {
      final x = plot.left + (month - 1) * (plot.width / 11);
      final y = plot.bottom - (v / gridMax) * plot.height;
      return Offset(x, y);
    }

    void drawSeries(Color color, double Function(int m) valueOf) {
      final p = Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      for (var m = 1; m <= 12; m++) {
        final pt = pointFor(m, valueOf(m));
        if (m == 1) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      canvas.drawPath(path, p);
    }

    // Income line (primary/blue)
    drawSeries(
      AppColors.primary,
      (m) => t.incomeOf(ReportMonth(year: t.year, month: m)).value,
    );

    // Expense line (secondary/orange)
    drawSeries(
      AppColors.secondary,
      (m) => t.expenseOf(ReportMonth(year: t.year, month: m)).value,
    );
  }

  void _drawGrid(Canvas canvas, Rect plot, double gridMax) {
    final gridPaint = Paint()
      ..color = AppColors.neutral200
      ..strokeWidth = 1;

    const textStyle = TextStyle(
      color: AppColors.neutral400,
      fontSize: 10,
      fontFamily: 'Roboto',
    );

    // Draw 4 horizontal grid lines
    const gridCount = 4;
    for (var i = 0; i <= gridCount; i++) {
      final y = plot.bottom - (i / gridCount) * plot.height;
      final value = (gridMax * i / gridCount).round();

      // Grid line
      canvas.drawLine(
        Offset(plot.left, y),
        Offset(plot.right, y),
        gridPaint,
      );

      // Y-axis label
      final label = '\$${_formatNumber(value)}';
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(plot.left - tp.width - 6, y - tp.height / 2),
      );
    }
  }

  void _drawXLabels(Canvas canvas, Rect plot) {
    const textStyle = TextStyle(
      color: AppColors.neutral400,
      fontSize: 9,
      fontFamily: 'Roboto',
    );

    // Draw every other month to avoid crowding
    for (var m = 1; m <= 12; m += 2) {
      final x = plot.left + (m - 1) * (plot.width / 11);
      final label = _monthLabels[m - 1];

      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(x - tp.width / 2, plot.bottom + 4),
      );
    }
  }

  /// Round up to a nice max value for grid (1000, 2000, 5000, 10000, etc.)
  double _niceMax(double value) {
    if (value <= 0) return 1000;

    final magnitude = math.pow(10, (math.log(value) / math.ln10).floor());
    final normalized = value / magnitude;

    double nice;
    if (normalized <= 1) {
      nice = 1;
    } else if (normalized <= 2) {
      nice = 2;
    } else if (normalized <= 5) {
      nice = 5;
    } else {
      nice = 10;
    }

    return (nice * magnitude).toDouble();
  }

  String _formatNumber(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k';
    }
    return value.toString();
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.t != t;
}
