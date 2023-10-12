import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../base/widgets/chart_base.dart';
import '../models/bar_chart_data.dart';
import '../models/bar_chart_item.dart';
import 'bar_stack.dart';

class BarChart extends StatelessWidget {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (maxY > 0)
          Expanded(
            flex: (centerFraction * 100).toInt(),
            child: BarStack(
              stack: item.positiveStack,
              alignment: Alignment.bottomCenter,
              maxValue: maxY,
            ),
          ),
        SizedBox(height: data.grid.getVerticalLine?.call(0).strokeWidth ?? 1),
        if (minY > 0)
          Expanded(
            flex: ((1 - centerFraction) * 100).toInt(),
            child: BarStack(
              stack: item.negativeStack,
              alignment: Alignment.topCenter,
              maxValue: minY,
            ),
          ),
      ],
    );
  }
}
