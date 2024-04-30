import 'package:flutter/material.dart';

import '../models/chart_bounds.dart';
import '../models/grid_line.dart';
import '../utils/path.dart';

class ChartGrid extends StatelessWidget {
  final ChartBounds bounds;
  final GridLineBuilder? horizontalLineBuilder;
  final GridLineBuilder? verticalLineBuilder;

  const ChartGrid({
    super.key,
    required this.bounds,
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
          lineBuilder: horizontalLineBuilder,
        ),
      );
    }

    if (verticalLineBuilder case final verticalLineBuilder?) {
      painters.add(
        _GridLinesPainter(
          axis: Axis.vertical,
          bounds: bounds,
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
  final ChartBounds bounds;
  final GridLineBuilder lineBuilder;

  _GridLinesPainter({
    required this.axis,
    required this.bounds,
    required this.lineBuilder,
  });

  @override
  bool shouldRepaint(covariant _GridLinesPainter oldDelegate) =>
      axis != oldDelegate.axis ||
      bounds != oldDelegate.bounds ||
      lineBuilder != oldDelegate.lineBuilder;

  @override
  void paint(Canvas canvas, Size size) {
    final intervals = bounds.intervals;
    // TODO: Axis etc.
    for (var i = 0; i < intervals.length; i++) {
      final line = lineBuilder(i, intervals[i].toDouble());
      if (line != null) {
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = line.width
          ..color = line.color;

        final y = size.height * bounds.getFractionY(intervals[i]);
        var path = Path()
          ..moveTo(0, y)
          ..lineTo(size.width, y);

        if (line.dashArray case final dashArray?) {
          path = createDashedPath(path, dashArray);
        }

        canvas.drawPath(path, paint);
      }
    }
  }
}
