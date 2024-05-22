import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/labels.dart';

class ChartXLabels extends StatelessWidget {
  final Labels labels;
  final List<({double fraction, TextPainter painter})> values;

  const ChartXLabels({super.key, required this.labels, required this.values});

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
      !listEquals(values, oldDelegate.values) ||
      textAlign != oldDelegate.textAlign ||
      offset != oldDelegate.offset;

  @override
  void paint(Canvas canvas, Size size) {
    for (final (:fraction, :painter) in values) {
      final left = fraction * size.width + (painter.width * offset);
      // TODO: Text align?
      painter.paint(canvas, Offset(left, 0));
    }
  }
}
