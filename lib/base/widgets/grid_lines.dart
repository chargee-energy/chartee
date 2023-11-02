import 'package:flutter/material.dart';

import '../models/chart_line.dart';

/// A widget to render the grid lines of a chart based on the information
/// provided by [ChartLine] objects. This widget is used for rendering the
/// lines of both the x-axis and the y-axis.
class GridLines<Value extends num> extends StatelessWidget {
  /// The axis of the lines (x-axis = horizontal, y-axis = vertical)
  final Axis axis;

  /// The alignment of the lines on the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// The values of the lines, these will be passed to the [getLine] function.
  final List<Value> values;

  /// A function to get the line for a specific value.
  final ChartLine Function(Value value)? getLine;

  const GridLines({
    super.key,
    required this.axis,
    required this.mainAxisAlignment,
    required this.values,
    required this.getLine,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: axis,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: values.map(
        (value) {
          final line = getLine?.call(value) ?? const ChartLine();
          return SizedBox(
            width: axis == Axis.horizontal ? line.width : null,
            height: axis == Axis.vertical ? line.width : null,
            child: CustomPaint(
              painter: _ChartLinePainter(
                line: line,
                axis: flipAxis(axis),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class _ChartLinePainter extends CustomPainter {
  final ChartLine line;
  final Axis axis;

  const _ChartLinePainter({required this.line, required this.axis});

  @override
  bool shouldRepaint(covariant _ChartLinePainter oldDelegate) =>
      oldDelegate.line != line;

  @override
  void paint(Canvas canvas, Size size) {
    final dashArray = line.dashArray;
    final paint = Paint()..color = line.color;

    if (dashArray == null || dashArray.length != 2) {
      canvas.drawRect(Offset.zero & size, paint);
      return;
    }

    final dashTotalSize = dashArray[0] + dashArray[1];
    final numberOfDashes = axis == Axis.horizontal
        ? size.width / dashTotalSize
        : size.height / dashTotalSize;

    canvas.save();
    canvas.clipRect(Offset.zero & size);

    for (var i = 0; i < numberOfDashes; i++) {
      final offset = i * dashTotalSize;
      canvas.drawRect(
        Rect.fromLTWH(
          axis == Axis.horizontal ? offset.toDouble() : 0,
          axis == Axis.vertical ? offset.toDouble() : 0,
          axis == Axis.horizontal ? dashArray[0].toDouble() : size.width,
          axis == Axis.vertical ? dashArray[0].toDouble() : size.height,
        ),
        paint,
      );
    }

    canvas.restore();
  }
}
