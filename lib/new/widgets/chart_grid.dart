import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/grid_line.dart';
import '../utils/path.dart';

class ChartGrid extends StatelessWidget {
  final BoundingBox bounds;
  final List<double> intervalsX;
  final List<double> intervalsY;
  final GridLineBuilder? horizontalLineBuilder;
  final GridLineBuilder? verticalLineBuilder;

  const ChartGrid({
    super.key,
    required this.bounds,
    required this.intervalsX,
    required this.intervalsY,
    this.horizontalLineBuilder,
    this.verticalLineBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final painters = <CustomPainter>[];

    if (horizontalLineBuilder case final horizontalLineBuilder?) {
      painters.add(
        _GridLinesPainter(
          axis: Axis.horizontal,
          bounds: bounds,
          intervals: intervalsY,
          lineBuilder: horizontalLineBuilder,
        ),
      );
    }

    if (verticalLineBuilder case final verticalLineBuilder?) {
      painters.add(
        _GridLinesPainter(
          axis: Axis.vertical,
          bounds: bounds,
          intervals: intervalsX,
          lineBuilder: verticalLineBuilder,
        ),
      );
    }

    return CustomPaint(painter: _GridPainter(children: painters));
  }
}

class _GridPainter extends CustomPainter {
  final List<CustomPainter> children;

  const _GridPainter({required this.children});

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      children != oldDelegate.children;

  @override
  void paint(Canvas canvas, Size size) {
    for (final child in children) {
      child.paint(canvas, size);
    }
  }
}

class _GridLinesPainter extends CustomPainter {
  final Axis axis;
  final BoundingBox bounds;
  final List<double> intervals;
  final GridLineBuilder lineBuilder;

  _GridLinesPainter({
    required this.axis,
    required this.bounds,
    required this.intervals,
    required this.lineBuilder,
  });

  @override
  bool shouldRepaint(covariant _GridLinesPainter oldDelegate) =>
      axis != oldDelegate.axis ||
      bounds != oldDelegate.bounds ||
      intervals != oldDelegate.intervals ||
      lineBuilder != oldDelegate.lineBuilder;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < intervals.length; i++) {
      final line = lineBuilder(i, intervals[i].toDouble());
      if (line != null) {
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = line.width
          ..color = line.color;

        var path = Path();

        switch (axis) {
          case Axis.horizontal:
            final y = size.height * bounds.getFractionY(intervals[i]);
            path.moveTo(0, y);
            path.lineTo(size.width, y);
            break;
          case Axis.vertical:
            final x = size.width * bounds.getFractionX(intervals[i]);
            path.moveTo(x, 0);
            path.lineTo(x, size.height);
            break;
        }

        if (line.dashArray case final dashArray?) {
          path = createDashedPath(path, dashArray);
        }

        canvas.drawPath(path, paint);
      }
    }
  }
}
