import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../base/models/chart_data.dart';
import 'line_chart_item.dart';

/// An implementation of [ChartData] specifically used for a line chart.
class LineChartData extends ChartData<LineChartItem> {
  /// The color of the line when it is above `0`.
  final Color colorPositiveLine;

  /// The color of the area when it is above `0`.
  final Color colorPositiveArea;

  /// The color of the line when it is below `0`.
  final Color colorNegativeLine;

  /// The color of the area when it is below `0`.
  final Color colorNegativeArea;

  /// The width of the line.
  final double lineWidth;

  @override
  double get minY =>
      min(items.map((item) => item.y).minOrNull ?? 0, 0).abs().toDouble();

  @override
  double get maxY => max(items.map((item) => item.y).maxOrNull ?? 0, 0);

  const LineChartData({
    required this.colorPositiveLine,
    required this.colorPositiveArea,
    required this.colorNegativeLine,
    required this.colorNegativeArea,
    this.lineWidth = 1,
    required super.direction,
    required super.grid,
    required super.labels,
    required super.tooltip,
    required super.items,
    super.padding,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        colorPositiveLine,
        colorPositiveArea,
        colorNegativeLine,
        colorNegativeArea,
        lineWidth,
      ];
}
