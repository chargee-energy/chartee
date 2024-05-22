import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/point.dart';
import '../utils/paint.dart';
import '../utils/path.dart';

class ChartLine extends StatelessWidget {
  final BoundingBox bounds;
  final List<Point> points;
  final Color positiveColor;
  final Color negativeColor;
  final double lineWidth;
  final List<double>? dashArray;

  const ChartLine({
    super.key,
    required this.bounds,
    required this.points,
    required this.positiveColor,
    required this.negativeColor,
    required this.lineWidth,
    required this.dashArray,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _LinePainter(
          bounds: bounds,
          points: points,
          positiveColor: positiveColor,
          negativeColor: negativeColor,
          lineWidth: lineWidth,
          dashArray: dashArray,
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final BoundingBox bounds;
  final List<Point> points;
  final Color positiveColor;
  final Color negativeColor;
  final double lineWidth;
  final List<double>? dashArray;

  late final _positivePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = lineWidth
    ..color = positiveColor;

  late final _negativePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = lineWidth
    ..color = negativeColor;

  _LinePainter({
    required this.bounds,
    required this.points,
    required this.positiveColor,
    required this.negativeColor,
    required this.lineWidth,
    required this.dashArray,
  });

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      bounds != oldDelegate.bounds ||
      !listEquals(points, oldDelegate.points) ||
      positiveColor != oldDelegate.positiveColor ||
      negativeColor != oldDelegate.negativeColor ||
      lineWidth != oldDelegate.lineWidth ||
      !listEquals(dashArray, oldDelegate.dashArray);

  @override
  void paint(Canvas canvas, Size size) {
    var path = createPathFromChartPoints(size, bounds, points);

    if (path != null) {
      if (dashArray case final dashArray?) {
        path = createDashedPath(path, dashArray);
      }

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
