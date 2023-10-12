import 'package:flutter/material.dart';

import '../models/chart_data.dart';
import '../utils/line.dart';
import 'grid_lines.dart';

/// A widget to render all shared elements of a chart like the grid and labels.
///
/// See also:
///
///  * [BarChart], for a bar chart using this widget as a base.
class ChartBase extends StatelessWidget {
  /// The data that will be rendered in the chart, this will be a specific
  /// implementation for the type of chart that should be rendered.
  final ChartData data;

  /// A builder function to create the chart content, provides the y-axis lines
  /// to use for calculating the scaling.
  final Widget Function(BuildContext context, List<double> lines) builder;

  const ChartBase({super.key, required this.data, required this.builder});

  @override
  Widget build(BuildContext context) {
    final lines = getLineValues(data.minY, data.maxY);
    return Stack(
      children: [
        if (data.grid.showVertical)
          GridLines(
            axis: Axis.vertical,
            values: lines.reversed.toList(),
            getLine: data.grid.getVerticalLine,
          ),
        if (data.grid.showHorizontal)
          GridLines(
            axis: Axis.horizontal,
            values: data.items.map((item) => item.x).toList(),
            getLine: data.grid.getHorizontalLine,
          ),
        builder(context, lines),
      ],
    );
  }
}
