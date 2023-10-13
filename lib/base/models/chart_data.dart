import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'chart_grid.dart';
import 'chart_item.dart';
import 'chart_labels.dart';

/// A base class for the data that will be passed to a chart widget. This class
/// has specific implementations for each kind of chart.
///
/// See also:
///
///  * [BarChartData], for an implementation used in a bar chart.
abstract class ChartData<Item extends ChartItem> with EquatableMixin {
  /// The information that will be used to render the chart grid
  final ChartGrid grid;

  /// The information that will be used to render the chart labels
  final ChartLabels labels;

  /// The items that will be plotted to the chart.
  final List<Item> items;

  /// Padding to apply around the chart
  final EdgeInsets padding;

  /// The minimum value on the y-axis of the chart. This is an absolute value
  /// and should be converted to a negative value when needed.
  double get minY;

  /// The maximum value on the y-axis of the chart.
  double get maxY;

  const ChartData({
    required this.grid,
    required this.labels,
    required this.items,
    this.padding = EdgeInsets.zero,
  });

  @override
  List<Object?> get props => [grid, labels, items, padding];
}
