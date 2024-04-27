import 'dart:ui';

import '../models/chart_bounds.dart';
import '../models/chart_point.dart';

class ChartPathPainter {
  static void paintChartPath(
    Canvas canvas,
    Size size,
    ChartBounds bounds,
    List<ChartPoint> points,
    Paint positivePaint,
    Paint negativePaint, {
    bool closePath = false,
  }) {
    if (points.length < 2) {
      return;
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

    if (zeroFraction >= 1) {
      canvas.drawPath(path, positivePaint);
    } else if (zeroFraction <= 0) {
      canvas.drawPath(path, negativePaint);
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
      canvas.drawPath(path, positivePaint);
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
      canvas.drawPath(path, negativePaint);
      canvas.restore();
    }
  }

  static Offset _getOffset(ChartBounds bounds, ChartPoint point, Size size) =>
      Offset(
        bounds.getFractionX(point.x) * size.width,
        bounds.getFractionY(point.y) * size.height,
      );
}
