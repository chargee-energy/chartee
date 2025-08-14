import 'dart:ui';

import '../models/bounding_box.dart';
import '../models/point.dart';

// TODO: Separate package together with dashed border
Path createDashedPath(Path source, List<num> dashArray) {
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
  BoundingBox bounds,
  List<Point> points, {
  bool closePath = false,
  double? smoothness,
}) {
  if (points.length < 2) {
    return null;
  }

  final path = Path();
  final zeroFraction = bounds.getFractionY(0);
  final scaledPoints =
      points.map((point) => _getScaledPoint(bounds, point, size)).toList();

  if (closePath) {
    path
      ..moveTo(scaledPoints.first.x, size.height * zeroFraction.clamp(0, 1))
      ..lineTo(scaledPoints.first.x, scaledPoints.first.y);
  } else {
    path.moveTo(scaledPoints.first.x, scaledPoints.first.y);
  }

  if (smoothness == null) {
    _createSimplePath(path, scaledPoints);
  } else {
    _createSmoothPath(path, scaledPoints, smoothness);
  }

  if (closePath) {
    path.lineTo(scaledPoints.last.x, size.height * zeroFraction.clamp(0, 1));
  }

  return path;
}

void _createSimplePath(Path path, List<Point> points) {
  for (var i = 1; i < points.length; i++) {
    path.lineTo(points[i].x, points[i].y);
  }
}

void _createSmoothPath(Path path, List<Point> points, double tension) {
  for (var i = 0; i < points.length - 1; i++) {
    // Catmull-Rom needs P0 and P3 for tangent calculation
    final p0 = i > 0 ? points[i - 1] : points[i];
    final p1 = points[i];
    final p2 = points[i + 1];
    final p3 = (i + 2 < points.length) ? points[i + 2] : p2;

    // Control points
    final cp1 = p1 + (p2 - p0) * (tension / 6);
    final cp2 = p2 - (p3 - p1) * (tension / 6);

    path.cubicTo(cp1.x, cp1.y, cp2.x, cp2.y, p2.x, p2.y);
  }
}

Point _getScaledPoint(BoundingBox bounds, Point point, Size size) => Point(
      x: bounds.getFractionX(point.x) * size.width,
      y: bounds.getFractionY(point.y) * size.height,
    );
