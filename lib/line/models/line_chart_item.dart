import '../../base/models/chart_item.dart';

/// An implementation of [BarChartItem] specifically used for a line chart.
class LineChartItem extends ChartItem {
  /// The percentage of this point within the x-axis of the chart.
  final double xPercentage;

  /// The value of this point, this will be used to determine the position on the y-axis.
  final double y;

  const LineChartItem({
    required super.x,
    required this.xPercentage,
    required this.y,
  });

  @override
  List<Object?> get props => [...super.props, xPercentage, y];
}
