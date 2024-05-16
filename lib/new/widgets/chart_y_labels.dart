import 'package:flutter/material.dart';

import '../models/labels.dart';

class ChartYLabels extends StatelessWidget {
  final Labels labels;
  final List<({double fraction, TextPainter painter})> values;

  const ChartYLabels({super.key, required this.labels, required this.values});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LabelsPainter(
        values: values,
        textAlign: labels.textAlign,
        offset: labels.offset - 0.5,
      ),
    );
  }
}

class _LabelsPainter extends CustomPainter {
  final List<({double fraction, TextPainter painter})> values;
  final TextAlign textAlign;
  final double offset;

  const _LabelsPainter({
    required this.values,
    required this.textAlign,
    required this.offset,
  });

  @override
  bool shouldRepaint(covariant _LabelsPainter oldDelegate) =>
      values != oldDelegate.values ||
      textAlign != oldDelegate.textAlign ||
      offset != oldDelegate.offset;

  @override
  void paint(Canvas canvas, Size size) {
    for (final (:fraction, :painter) in values) {
      final top = fraction * size.height + (painter.height * offset);
      // TODO: Support RTL?
      final left = switch (textAlign) {
        TextAlign.left || TextAlign.start => 0.0,
        TextAlign.right || TextAlign.end => size.width - painter.width,
        TextAlign.center ||
        TextAlign.justify =>
          (size.width - painter.width) / 2,
      };
      painter.paint(canvas, Offset(left, top));
    }
  }
}