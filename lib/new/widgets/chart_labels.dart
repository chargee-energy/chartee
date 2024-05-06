import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/chart_bounds.dart';
import '../models/labels.dart';

class ChartLabels extends StatelessWidget {
  final ChartBounds bounds;
  final Labels labels;
  final List<num> intervals;

  const ChartLabels({
    super.key,
    required this.bounds,
    required this.labels,
    required this.intervals,
  });

  @override
  Widget build(BuildContext context) {
    final values = intervals
        .mapIndexed(
          (index, interval) {
            final text = labels.getLabelText?.call(index, interval.toDouble());

            if (text == null) {
              return null;
            }

            final painter = TextPainter(
              text: TextSpan(text: text, style: labels.style),
              textAlign: labels.textAlign,
              textDirection: TextDirection.ltr,
            );
            painter.layout();

            return (
              fraction: bounds.getFractionY(interval),
              painter: painter,
            );
          },
        )
        .whereNotNull()
        .toList();

    final width = values.map((value) => value.painter.width).max;

    return SizedBox(
      width: width,
      child: CustomPaint(
        painter: _LabelsPainter(
          values: values,
          textAlign: labels.textAlign,
          offset: labels.offset - 0.5,
        ),
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
