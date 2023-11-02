import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/chart_axis_labels.dart';

/// A widget to render the vertical labels of a chart based on the information
/// provided by a [ChartLabels] object.
class VerticalLabels extends StatelessWidget {
  /// The vertical lines that the labels should be aligned with.
  final List<double> lines;

  /// The rendering information for the labels.
  final ChartAxisLabels<double> labels;

  const VerticalLabels({super.key, required this.lines, required this.labels});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemHeight = constraints.maxHeight / (lines.length - 1);
        return Stack(
          children: lines.reversed.mapIndexed((index, line) {
            final offset = index * itemHeight;
            final text = labels.getLabelText?.call(line) ?? line.toString();
            return FractionalTranslation(
              translation: Offset(0, labels.offset - 0.5),
              child: Transform.translate(
                offset: Offset(0, offset),
                child: Text(text, style: labels.style),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
