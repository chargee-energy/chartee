import 'package:collection/collection.dart';

import '../../base/models/chart_data.dart';
import 'bar_chart_item.dart';

/// An implementation of [ChartData] specifically used for a bar chart.
class BarChartData extends ChartData<BarChartItem> {
  /// Whether the chart has positive bars
  bool get hasPositive => items.any((item) => item.positiveStack != null);

  /// Whether the chart has negative bars
  bool get hasNegative => items.any((item) => item.negativeStack != null);

  @override
  double get minY => items.map((item) => item.minY).maxOrNull ?? 0;

  @override
  double get maxY => items.map((item) => item.maxY).maxOrNull ?? 0;

  const BarChartData({
    required super.grid,
    required super.labels,
    required super.items,
    super.padding,
    super.tooltipPadding,
  });
}
