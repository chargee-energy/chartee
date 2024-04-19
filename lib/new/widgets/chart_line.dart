import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/chart_bounds.dart';
import '../models/chart_line_layer.dart';
import '../models/chart_point.dart';

class ChartLine extends StatelessWidget {
  final ChartBounds bounds;
  final ChartLineLayer layer;

  const ChartLine({
    super.key,
    required this.bounds,
    required this.layer,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChartLinePainter(
        bounds: bounds,
        points: layer.items,
      ),
    );
  }
}

class _ChartLinePainter extends CustomPainter {
  final ChartBounds bounds;
  final List<ChartPoint> points;

  const _ChartLinePainter({required this.bounds, required this.points});

  @override
  bool shouldRepaint(covariant _ChartLinePainter oldDelegate) =>
      bounds != oldDelegate.bounds || points != oldDelegate.points;

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

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.black,
    );
  }

  Offset _getOffset(ChartPoint point, Size size) => Offset(
        bounds.getFractionX(point.x) * size.width,
        bounds.getFractionY(point.y) * size.height,
      );
}
