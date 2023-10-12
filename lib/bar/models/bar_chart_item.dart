import '../../base/models/chart_item.dart';
import 'bar_chart_bar_stack.dart';

/// An implementation of [BarChartItem] specifically used for a bar chart.
class BarChartItem extends ChartItem {
  /// A stack of positive bars.
  final BarChartBarStack? positiveStack;

  /// A stack of negative bars.
  final BarChartBarStack? negativeStack;

  /// The maximum value of all negative bars. This is an absolute value and
  /// should be converted to a negative value when needed.
  double get minY => negativeStack?.maxY ?? 0;

  /// The maximum value of all positive bars.
  double get maxY => positiveStack?.maxY ?? 0;

  const BarChartItem({
    required super.x,
    this.positiveStack,
    this.negativeStack,
  });

  @override
  List<Object?> get props => [...super.props, positiveStack, negativeStack];
}
