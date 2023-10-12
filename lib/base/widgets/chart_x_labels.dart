import 'package:flutter/material.dart';

import '../models/chart_data.dart';

typedef ChartXLabelFormatter = String? Function(int index);
typedef GetPointCenterX = double Function(int index);

class ChartXLabels extends StatelessWidget {
  final ChartData data;
  final ChartXLabelFormatter labelFormatter;
  final GetPointCenterX getPointCenterX;
  final TextStyle? textStyle;

  const ChartXLabels({
    super.key,
    required this.data,
    required this.labelFormatter,
    required this.getPointCenterX,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChartXLabelsPainter(
        data: data,
        labelFormatter: labelFormatter,
        getPointCenterX: (index) {
          final renderBox = context.findRenderObject() as RenderBox;
          return renderBox.globalToLocal(Offset(getPointCenterX(index), 0)).dx;
        },
        textStyle: textStyle,
      ),
    );
  }
}

class _ChartXLabelsPainter extends CustomPainter {
  final ChartData data;
  final ChartXLabelFormatter labelFormatter;
  final GetPointCenterX getPointCenterX;
  final TextStyle? textStyle;

  _ChartXLabelsPainter({
    required this.data,
    required this.labelFormatter,
    required this.getPointCenterX,
    required this.textStyle,
  });

  @override
  bool shouldRepaint(covariant _ChartXLabelsPainter oldPainter) {
    return oldPainter.data != data ||
        oldPainter.labelFormatter != labelFormatter ||
        oldPainter.getPointCenterX != getPointCenterX ||
        oldPainter.textStyle != textStyle;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));

    for (var i = 0; i < data.items.length; i++) {
      final label = labelFormatter(i);

      if (label == null) {
        continue;
      }

      final centerX = getPointCenterX(i);
      final textPainter = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(centerX - textPainter.width / 2, 0));
    }

    canvas.restore();
  }
}
