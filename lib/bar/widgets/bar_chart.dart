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

  /// Builder function to show a tooltip when a bar is highlighted.
  final TooltipBuilder tooltipBuilder;

  /// Whether the tooltip should be shown for a specific index.
  final bool Function(int index) shouldShowTooltip;

  const BarChart({
    super.key,
    required this.data,
    required this.tooltipBuilder,
    required this.shouldShowTooltip,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalLabelsSize =
        calculateTextSize('0', data.labels.horizontal.style);
    return TooltipHandler(
      padding: data.tooltipPadding +
          EdgeInsets.only(
              bottom: horizontalLabelsSize.height +
                  data.labels.horizontal.padding.vertical),
      tooltipBuilder: tooltipBuilder,
      builder: (context, showTooltip, hideTooltip) => ChartBase(
        data: data,
        builder: (context, lines) => BarChartGestureHandler(
          numberOfBars: data.items.length,
          onChange: (centerX, selectedIndex) {
            if (shouldShowTooltip(selectedIndex)) {
              HapticFeedback.selectionClick();
              showTooltip(centerX, selectedIndex);
            } else {
              hideTooltip();
            }
          },
          onReset: hideTooltip,
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
