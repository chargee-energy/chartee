import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../base/models/chart_data.dart';
import 'line_chart_cursor.dart';
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

  /// The information that will be used to render the cursor.
  final LineChartCursor cursor;

  /// Whether to draw the area covered by the line or only the line itself.
  final bool drawArea;

  @override
  double get minY {
    final minY = items.map((item) => item.y).minOrNull ?? 0;
    return useZeroBase ? min(minY, 0.0) : minY;
  }

  @override
  double get maxY {
    final maxY = items.map((item) => item.y).maxOrNull ?? 0;
    return useZeroBase ? max(maxY, 0.0) : maxY;
  }

  const LineChartData({
    required this.colorPositiveLine,
    required this.colorPositiveArea,
    required this.colorNegativeLine,
    required this.colorNegativeArea,
    this.lineWidth = 1,
    this.cursor = const LineChartCursor(),
    this.drawArea = true,
    required super.direction,
    required super.grid,
    required super.labels,
    required super.tooltip,
    required super.items,
    super.useZeroBase = true,
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
