import 'package:flutter/material.dart';

import '../models/chart_bounds.dart';
import '../models/chart_point.dart';
import '../utils/paint.dart';
import '../utils/path.dart';

class ChartArea extends StatelessWidget {
  final ChartBounds bounds;
  final List<ChartPoint> points;
  final Color positiveColor;
  final Color negativeColor;

  const ChartArea({
    super.key,
    required this.bounds,
    required this.points,
    required this.positiveColor,
    required this.negativeColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AreaPainter(
        bounds: bounds,
        points: points,
        positiveColor: positiveColor,
        negativeColor: negativeColor,
      ),
    );
  }
}

class _AreaPainter extends CustomPainter {
  final ChartBounds bounds;
  final List<ChartPoint> points;
  final Color positiveColor;
  final Color negativeColor;

  late final _positivePaint = Paint()..color = positiveColor;
  late final _negativePaint = Paint()..color = negativeColor;

  _AreaPainter({
    required this.bounds,
    required this.points,
    required this.positiveColor,
    required this.negativeColor,
  });

  @override
  bool shouldRepaint(covariant _AreaPainter oldDelegate) =>
      bounds != oldDelegate.bounds ||
      points != oldDelegate.points ||
      positiveColor != oldDelegate.positiveColor ||
      negativeColor != oldDelegate.negativeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = createPathFromChartPoints(
      size,
      bounds,
      points,
      closePath: true,
    );

    if (path != null) {
      paintChartPath(
        canvas,
        size,
        bounds,
        path,
        _positivePaint,
        _negativePaint,
      );
    }
  }
}
