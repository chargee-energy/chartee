import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../base/models/chart_line.dart';
import '../../base/widgets/chart_base.dart';
import '../models/bar_chart_data.dart';
import '../models/bar_chart_item.dart';
import 'bar_stack.dart';

/// A widget to render a bar chart. Uses [ChartBase] to render the basic
/// elements of the chart and renders the bars on top of that.
class BarChart extends StatelessWidget {
  /// The data that will be rendered in the chart.
  final BarChartData data;

  const BarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ChartBase(
      data: data,
      builder: (context, lines) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: data.items
            .map((item) => Expanded(child: _buildItem(item, lines)))
            .toList(),
      ),
    );
  }

  Widget _buildItem(BarChartItem item, List<double> lines) {
    final minY = lines.min.abs();
    final maxY = lines.max;
    final centerFraction = maxY / (minY + maxY);
    final positiveStack = item.positiveStack;
    final negativeStack = item.negativeStack;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (positiveStack != null && maxY > 0)
          Expanded(
            flex: (centerFraction * 100).toInt(),
            child: BarStack(
              stack: positiveStack,
              alignment: Alignment.bottomCenter,
              maxValue: maxY,
            ),
          ),
        SizedBox(
          height:
              (data.grid.getVerticalLine?.call(0) ?? const ChartLine()).width,
        ),
        if (negativeStack != null && minY > 0)
          Expanded(
            flex: ((1 - centerFraction) * 100).toInt(),
            child: BarStack(
              stack: negativeStack,
              alignment: Alignment.topCenter,
              maxValue: minY,
            ),
          ),
      ],
    );
  }
}
