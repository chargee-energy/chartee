import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/point.dart';
import '../utils/paint.dart';
import '../utils/path.dart';

class ChartLine extends StatelessWidget {
  final BoundingBox bounds;
  final List<Point> points;
  final Color? positiveColor;
  final Color? negativeColor;
  final Map<double, Color>? colors;
  final double lineWidth;
  final List<double>? dashArray;
  final double? smoothness;

  const ChartLine({
    super.key,
    required this.bounds,
    required this.points,
    required this.positiveColor,
    required this.negativeColor,
    required this.colors,
    required this.lineWidth,
    required this.dashArray,
    required this.smoothness,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        painter: _LinePainter(
          bounds: bounds,
          points: points,
          positiveColor: positiveColor,
          negativeColor: negativeColor,
          colors: colors,
          lineWidth: lineWidth,
          dashArray: dashArray,
          smoothness: smoothness,
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final BoundingBox bounds;
  final List<Point> points;
  final Color? positiveColor;
  final Color? negativeColor;
  final Map<double, Color>? colors;
  final double lineWidth;
  final List<double>? dashArray;
  final double? smoothness;

  late final _positivePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = lineWidth
    ..color = positiveColor ?? Colors.transparent;

  late final _negativePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = lineWidth
    ..color = negativeColor ?? Colors.transparent;

  _LinePainter({
    required this.bounds,
    required this.points,
    required this.positiveColor,
    required this.negativeColor,
    required this.colors,
    required this.lineWidth,
    required this.dashArray,
    required this.smoothness,
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
    var path =
        createPathFromChartPoints(size, bounds, points, smoothness: smoothness);

    if (path != null) {
      if (dashArray case final dashArray?) {
        path = createDashedPath(path, dashArray);
      }

      if (colors case final colors?) {
        final yValues = colors.keys.sorted((a, b) => a.compareTo(b));
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = lineWidth
            ..shader = LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: yValues.map((y) => colors[y]!).toList(),
              stops: yValues.map((y) => 1 - bounds.getFractionY(y)).toList(),
            ).createShader(Offset.zero & size),
        );
      } else if (negativeColor != null) {
        paintChartPath(
          canvas,
          size,
          bounds,
          path,
          _positivePaint,
          _negativePaint,
        );
      } else {
        canvas.drawPath(path, _positivePaint);
      }
    }
  }
}
