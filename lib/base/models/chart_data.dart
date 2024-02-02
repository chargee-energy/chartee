import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../enums/chart_direction.dart';
import 'chart_grid.dart';
import 'chart_item.dart';
import 'chart_labels.dart';
import 'chart_tooltip.dart';

/// A base class for the data that will be passed to a chart widget. This class
/// has specific implementations for each kind of chart.
///
/// See also:
///
///  * [BarChartData], for an implementation used in a bar chart.
///  * [LineChartData], for an implementation used in a line chart.
abstract class ChartData<Item extends ChartItem> with EquatableMixin {
  /// The direction in which the chart should render. `ChartDirection.ltr` will
  /// render the labels on the left and the chart on the right,`ChartDirection.rtl`
  /// will render the labels on the right and the chart on the left.
  final ChartDirection direction;

  /// The information that will be used to render the chart grid.
  final ChartGrid grid;

  /// The information that will be used to render the chart labels.
  final ChartLabels labels;

  /// The information that will be used to render the chart tooltip.
  final ChartTooltip tooltip;

  /// The items that will be plotted to the chart.
  final List<Item> items;

  /// Whether the graph will show `0` as base or it will scale to it's values only.
  final bool useZeroBase;

  /// Padding to apply around the chart.
  final EdgeInsets padding;

  /// The minimum value on the y-axis of the chart. This is an absolute value
  /// and should be converted to a negative value when needed.
  double get minY;

  /// The maximum value on the y-axis of the chart.
  double get maxY;

  const ChartData({
    required this.direction,
    required this.grid,
    required this.labels,
    required this.tooltip,
    required this.items,
    this.useZeroBase = true,
    this.padding = EdgeInsets.zero,
  });

  @override
  List<Object?> get props => [direction, grid, labels, tooltip, items, padding];
}
