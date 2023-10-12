import 'package:flutter/material.dart';

import '../models/chart_data.dart';
import '../utils/line.dart';
import 'chart_y_labels.dart';
import 'grid_lines.dart';

class ChartBase extends StatelessWidget {
  final ChartData data;
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
        ChartYLabels(lines: lines, labelFormatter: (value) => value.toString()),
        builder(context, lines),
      ],
    );
  }
}
