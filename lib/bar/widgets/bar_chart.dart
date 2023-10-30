import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base/models/chart_line.dart';
import '../../base/utils/text.dart';
import '../../base/widgets/chart_base.dart';
import '../../base/widgets/tooltip_handler.dart';
import '../models/bar_chart_data.dart';
import '../models/bar_chart_item.dart';
import 'bar_chart_gesture_handler.dart';
import 'bar_stack.dart';

/// A widget to render a bar chart. Uses [ChartBase] to render the basic
/// elements of the chart and renders the bars on top of that.
class BarChart extends StatelessWidget {
  /// The data that will be rendered in the chart.
  final BarChartData data;

  /// Initial index to highlight.
  final int? initialIndex;

  const BarChart({super.key, required this.data, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final horizontalLabelsSize =
        calculateTextSize('0', data.labels.horizontal.style);
    return TooltipHandler(
      tooltip: data.tooltip.addPadding(
        EdgeInsets.only(
          bottom: horizontalLabelsSize.height +
              data.labels.horizontal.padding.vertical,
        ),
      ),
      builder: (context, showTooltip, hideTooltip) => ChartBase(
        data: data,
        builder: (context, lines) => BarChartGestureHandler(
          numberOfBars: data.items.length,
          onChange: (centerX, selectedIndex) {
            if (data.tooltip.shouldShow?.call(selectedIndex) ?? true) {
              HapticFeedback.selectionClick();
              showTooltip(centerX, selectedIndex);
            } else {
              hideTooltip();
            }
          },
          onReset: hideTooltip,
          initialIndex: initialIndex,
          builder: (context, selectedIndex) => Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: data.items
                .mapIndexed(
                  (index, item) => Expanded(
                    child: _buildItem(
                      item,
                      lines,
                      index == selectedIndex,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BarChartItem item, List<double> lines, bool selected) {
    final minY = lines.min.abs();
    final maxY = lines.max;
    final centerFraction = maxY / (minY + maxY);
    final positiveStack = item.positiveStack;
    final negativeStack = item.negativeStack;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (maxY > 0)
          Expanded(
            flex: (centerFraction * 100).toInt(),
            child: positiveStack != null
                ? BarStack(
                    stack: positiveStack,
                    alignment: Alignment.bottomCenter,
                    maxValue: maxY,
                    highlight: selected,
                  )
                : Container(),
          ),
        SizedBox(
          height:
              (data.grid.vertical.getLine?.call(0) ?? const ChartLine()).width,
        ),
        if (minY > 0)
          Expanded(
            flex: ((1 - centerFraction) * 100).toInt(),
            child: negativeStack != null
                ? BarStack(
                    stack: negativeStack,
                    alignment: Alignment.topCenter,
                    maxValue: minY,
                    highlight: selected,
                  )
                : Container(),
          ),
      ],
    );
  }
}
