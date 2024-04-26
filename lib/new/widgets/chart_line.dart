import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/chart_bounds.dart';
import '../models/chart_point.dart';

class ChartLine extends StatelessWidget {
  final ChartBounds bounds;
  final List<ChartPoint> points;
  final Color positiveColor;
  final Color negativeColor;
  final double lineWidth;

  const ChartLine({
    super.key,
    required this.bounds,
    required this.points,
    required this.positiveColor,
    required this.negativeColor,
    required this.lineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LinePainter(
        bounds: bounds,
        points: points,
        positiveColor: positiveColor,
        negativeColor: negativeColor,
        lineWidth: lineWidth,
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final ChartBounds bounds;
  final List<ChartPoint> points;
  final Color positiveColor;
  final Color negativeColor;
  final double lineWidth;

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
  });

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      bounds != oldDelegate.bounds ||
      points != oldDelegate.points ||
      positiveColor != oldDelegate.positiveColor ||
      negativeColor != oldDelegate.negativeColor ||
      lineWidth != oldDelegate.lineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || points.none((point) => point.y != 0)) {
      return;
    }

    final firstPoint = _getOffset(points[0], size);
    final path = Path()..moveTo(firstPoint.dx, firstPoint.dy);

    for (var i = 1; i < points.length; i++) {
      final point = _getOffset(points[i], size);
      path.lineTo(point.dx, point.dy);
    }

    final zeroFraction = bounds.getFractionY(0);

    if (zeroFraction >= 1) {
      canvas.drawPath(path, _positivePaint);
    } else if (zeroFraction <= 0) {
      canvas.drawPath(path, _negativePaint);
    } else {
      canvas.save();
      canvas.clipRect(
        Rect.fromLTRB(
          0,
          0,
          size.width,
          size.height * zeroFraction,
        ),
      );
      canvas.drawPath(path, _positivePaint);
      canvas.restore();

      canvas.save();
      canvas.clipRect(
        Rect.fromLTRB(
          0,
          size.height * zeroFraction,
          size.width,
          size.height,
        ),
      );
      canvas.drawPath(path, _negativePaint);
      canvas.restore();
    }
  }

  Offset _getOffset(ChartPoint point, Size size) => Offset(
        bounds.getFractionX(point.x) * size.width,
        bounds.getFractionY(point.y) * size.height,
      );
}
