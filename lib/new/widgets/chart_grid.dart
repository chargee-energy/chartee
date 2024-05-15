import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/grid_line.dart';
import '../utils/path.dart';

class ChartGrid extends StatelessWidget {
  final BoundingBox bounds;
  final List<double> xIntervals;
  final List<double> yIntervals;
  final GridLineBuilder? horizontalLineBuilder;
  final GridLineBuilder? verticalLineBuilder;
  final EdgeInsets padding;

  const ChartGrid({
    super.key,
    required this.bounds,
    required this.xIntervals,
    required this.yIntervals,
    this.horizontalLineBuilder,
    this.verticalLineBuilder,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final painters = <CustomPainter>[];

    if (horizontalLineBuilder case final horizontalLineBuilder?) {
      painters.add(
        _GridLinesPainter(
          axis: Axis.horizontal,
          bounds: bounds,
          intervals: yIntervals,
          lineBuilder: horizontalLineBuilder,
          padding: padding,
        ),
      );
    }

    if (verticalLineBuilder case final verticalLineBuilder?) {
      painters.add(
        _GridLinesPainter(
          axis: Axis.vertical,
          bounds: bounds,
          intervals: xIntervals,
          lineBuilder: verticalLineBuilder,
          padding: padding,
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
              line.extendBehindLabels ? size.height : size.height - padding.top,
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
