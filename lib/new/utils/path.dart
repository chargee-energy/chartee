import 'dart:ui';

import '../models/chart_bounds.dart';
import '../models/chart_point.dart';

// TODO: Separate package together with dashed border
Path createDashedPath(Path source, List<double> dashArray) {
  final result = Path();

  for (final metric in source.computeMetrics()) {
    var dashIndex = 0;
    var distance = 0.0;
    var drawDash = true;

    while (distance < metric.length) {
      final currentDash = dashArray.elementAt(dashIndex);

      if (drawDash) {
        result.addPath(
          metric.extractPath(distance, distance + currentDash),
          Offset.zero,
        );
      }

      distance += currentDash;
      drawDash = !drawDash;
      dashIndex++;

      if (dashIndex >= dashArray.length) {
        dashIndex = 0;
      }
    }
  }

  return result;
}

Path? createPathFromChartPoints(
  Size size,
  ChartBounds bounds,
  List<ChartPoint> points, {
  bool closePath = false,
}) {
  if (points.length < 2) {
    return null;
  }

  final zeroFraction = bounds.getFractionY(0);
  final firstPoint = _getOffset(bounds, points.first, size);
  final path = Path();

  if (closePath) {
    path
      ..moveTo(firstPoint.dx, size.height * zeroFraction.clamp(0, 1))
      ..lineTo(firstPoint.dx, firstPoint.dy);
  } else {
    path.moveTo(firstPoint.dx, firstPoint.dy);
  }

  for (var i = 1; i < points.length; i++) {
    final point = _getOffset(bounds, points[i], size);
    path.lineTo(point.dx, point.dy);
  }

  if (closePath) {
    final lastPoint = _getOffset(bounds, points.last, size);
    path.lineTo(lastPoint.dx, size.height * zeroFraction.clamp(0, 1));
  }

  return path;
}

Offset _getOffset(ChartBounds bounds, ChartPoint point, Size size) => Offset(
      bounds.getFractionX(point.x) * size.width,
      bounds.getFractionY(point.y) * size.height,
    );
