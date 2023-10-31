import 'dart:math';

import 'package:flutter/material.dart';

import '../models/chart_data.dart';
import '../utils/line.dart';
import '../utils/text.dart';
import 'grid_lines.dart';
import 'horizontal_labels.dart';
import 'vertical_labels.dart';

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
    final horizontalLabelsSize =
        calculateTextSize('0', data.labels.horizontal.style);
    final verticalLabelsSize =
        calculateTextSize('0', data.labels.vertical.style);

    final chartPadding = data.padding +
        EdgeInsets.only(
          bottom: data.labels.horizontal.visible
              ? horizontalLabelsSize.height +
                  data.labels.horizontal.padding.vertical
              : 0,
        );

    final verticalLines = Padding(
      padding: chartPadding.copyWith(left: 0, right: 0),
      child: GridLines(
        axis: Axis.vertical,
        values: lines.reversed.toList(),
        getLine: data.grid.vertical.getLine,
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        top: max(
              0,
              verticalLabelsSize.height * -(data.labels.vertical.offset * 2),
            ) +
            data.tooltip.padding.bottom,
      ),
      child: Stack(
        children: [
          if (data.grid.vertical.visible &&
              data.grid.vertical.extendBehindLabels)
            verticalLines,
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (data.labels.vertical.visible)
                Padding(
                  padding: data.labels.vertical.padding +
                      EdgeInsets.only(
                        top: chartPadding.top,
                        bottom: chartPadding.bottom,
                      ),
                  child: VerticalLabels(
                    lines: lines,
                    labels: data.labels.vertical,
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    if (data.grid.vertical.visible &&
                        !data.grid.vertical.extendBehindLabels)
                      verticalLines,
                    if (data.grid.horizontal.visible)
                      Padding(
                        padding: chartPadding.copyWith(
                          bottom: data.grid.horizontal.extendBehindLabels
                              ? 0
                              : null,
                        ),
                        child: GridLines(
                          axis: Axis.horizontal,
                          values: data.items.map((item) => item.x).toList(),
                          getLine: data.grid.horizontal.getLine,
                        ),
                      ),
                    if (data.labels.horizontal.visible)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: data.labels.horizontal.padding +
                              data.padding.copyWith(top: 0, bottom: 0),
                          child: HorizontalLabels(data: data),
                        ),
                      ),
                    Padding(
                      padding: chartPadding,
                      child: builder(context, lines),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
