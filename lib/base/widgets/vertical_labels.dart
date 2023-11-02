import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../enums/chart_direction.dart';
import '../models/chart_data.dart';

/// A widget to render the vertical labels of a chart based on the information
/// provided by a [ChartLabels] object.
class VerticalLabels extends StatelessWidget {
  /// The data that will be rendered in the chart, this will be a specific
  /// implementation for the type of chart that should be rendered.
  final ChartData data;

  /// The vertical lines that the labels should be aligned with.
  final List<double> lines;

  const VerticalLabels({super.key, required this.data, required this.lines});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemHeight = constraints.maxHeight / (lines.length - 1);
        return Stack(
          alignment: switch (data.direction) {
            ChartDirection.ltr => Alignment.topLeft,
            ChartDirection.rtl => Alignment.topRight,
          },
          children: lines.reversed.mapIndexed((index, line) {
            final offset = index * itemHeight;
            final text = data.labels.vertical.getLabelText?.call(line) ??
                line.toString();
            return FractionalTranslation(
              translation: Offset(0, data.labels.vertical.offset - 0.5),
              child: Transform.translate(
                offset: Offset(0, offset),
                child: Text(text, style: data.labels.vertical.style),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
