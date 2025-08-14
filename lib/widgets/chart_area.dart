import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/point.dart';
import '../utils/paint.dart';
import '../utils/path.dart';

class ChartArea extends StatelessWidget {
  final BoundingBox bounds;
  final List<Point> points;
  final Color positiveColor;
  final Color negativeColor;
  final double? smoothness;

  const ChartArea({
    super.key,
    required this.bounds,
    required this.points,
    required this.positiveColor,
    required this.negativeColor,
    required this.smoothness,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        painter: _AreaPainter(
          bounds: bounds,
          points: points,
          positiveColor: positiveColor,
          negativeColor: negativeColor,
          smoothness: smoothness,
        ),
      ),
    );
  }
}

class _AreaPainter extends CustomPainter {
  final BoundingBox bounds;
  final List<Point> points;
  final Color positiveColor;
  final Color negativeColor;
  final double? smoothness;

  late final _positivePaint = Paint()..color = positiveColor;
  late final _negativePaint = Paint()..color = negativeColor;

  _AreaPainter({
    required this.bounds,
    required this.points,
    required this.positiveColor,
    required this.negativeColor,
    required this.smoothness,
  });

  @override
  bool shouldRepaint(covariant _AreaPainter oldDelegate) =>
      bounds != oldDelegate.bounds ||
      !listEquals(points, oldDelegate.points) ||
      positiveColor != oldDelegate.positiveColor ||
      negativeColor != oldDelegate.negativeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = createPathFromChartPoints(
      size,
      bounds,
      points,
      closePath: true,
      smoothness: smoothness,
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
