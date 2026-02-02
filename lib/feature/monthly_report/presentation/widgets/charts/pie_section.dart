import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/category_total.dart';

class PieSection extends StatelessWidget {
  final List<CategoryTotal> items;
  final List<Color> palette;

  const PieSection({
    super.key,
    required this.items,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: _PiePainter(items, palette),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.take(5).map((e) {
              final color = palette[items.indexOf(e) % palette.length];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.name, style: AppTextStyles.body)),
                    Text('${e.percent.toStringAsFixed(0)}%', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<CategoryTotal> items;
  final List<Color> palette;

  _PiePainter(this.items, this.palette);

  @override
  void paint(Canvas canvas, Size size) {
    final total = items.fold<double>(0, (s, e) => s + e.total.value);
    final t = total <= 0 ? 1.0 : total;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    double start = -math.pi / 2;

    for (var i = 0; i < items.length; i++) {
      final sweep = (items[i].total.value / t) * math.pi * 2;
      final paint = Paint()
        ..color = palette[i % palette.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, start, sweep, true, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) =>
      oldDelegate.items != items;
}
