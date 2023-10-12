import 'package:flutter/material.dart';

import '../models/chart_line.dart';

class GridLines<Value extends num> extends StatelessWidget {
  final Axis axis;
  final List<Value> values;
  final ChartLine Function(Value value)? getLine;

  const GridLines({
    super.key,
    required this.axis,
    required this.values,
    required this.getLine,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: axis,
      mainAxisAlignment: axis == Axis.vertical
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: values.map(
        (value) {
          final line = getLine?.call(value) ?? const ChartLine();
          return SizedBox(
            width: axis == Axis.horizontal ? line.strokeWidth : null,
            height: axis == Axis.vertical ? line.strokeWidth : null,
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
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      return;
    }

    final dashTotalSize = dashArray[0] + dashArray[1];
    final numberOfDashes = axis == Axis.horizontal
        ? size.width / dashTotalSize
        : size.height / dashTotalSize;

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));

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
