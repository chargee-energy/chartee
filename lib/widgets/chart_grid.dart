import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/grid_line.dart';
import '../utils/path.dart';

class HorizontalChartGridLines extends StatelessWidget {
  final EdgeInsets padding;
  final BoundingBox bounds;
  final List<double> intervals;
  final GridLineBuilder lineBuilder;

  const HorizontalChartGridLines({
    super.key,
    required this.padding,
    required this.bounds,
    required this.intervals,
    required this.lineBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridLinesPainter(
        axis: Axis.horizontal,
        bounds: bounds,
        intervals: intervals,
        lineBuilder: lineBuilder,
        padding: padding,
      ),
    );
  }
}

class VerticalChartGridLines extends StatelessWidget {
  final EdgeInsets padding;
  final BoundingBox bounds;
  final List<double> intervals;
  final GridLineBuilder lineBuilder;

  const VerticalChartGridLines({
    super.key,
    required this.padding,
    required this.bounds,
    required this.intervals,
    required this.lineBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridLinesPainter(
        axis: Axis.vertical,
        bounds: bounds,
        intervals: intervals,
        lineBuilder: lineBuilder,
        padding: padding,
      ),
    );
  }
}

class _GridLinesPainter extends CustomPainter {
  final Axis axis;
  final BoundingBox bounds;
  final List<double> intervals;
  final GridLineBuilder lineBuilder;
  final EdgeInsets padding;

  _GridLinesPainter({
    required this.axis,
    required this.bounds,
    required this.intervals,
    required this.lineBuilder,
    required this.padding,
  });

  @override
  bool shouldRepaint(covariant _GridLinesPainter oldDelegate) =>
      axis != oldDelegate.axis ||
      bounds != oldDelegate.bounds ||
      listEquals(intervals, oldDelegate.intervals) ||
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
            final y = padding.top +
                (size.height - padding.vertical) *
                    bounds.getFractionY(intervals[i]);

            path.moveTo(line.extendBehindLabels ? 0 : padding.left, y);
            path.lineTo(
              line.extendBehindLabels ? size.width : size.width - padding.right,
              y,
            );
            break;
          case Axis.vertical:
            final x = padding.left +
                (size.width - padding.horizontal) *
                    bounds.getFractionX(intervals[i]);

            path.moveTo(x, line.extendBehindLabels ? 0 : padding.top);
            path.lineTo(
              x,
              line.extendBehindLabels
                  ? size.height
                  : size.height - padding.bottom,
            );
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
