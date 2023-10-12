import '../../base/models/chart_item.dart';
import 'bar_chart_bar_stack.dart';

class BarChartItem extends ChartItem {
  final BarChartBarStack? positiveStack;
  final BarChartBarStack? negativeStack;

  double get maxY => positiveStack?.maxY ?? 0;
  double get minY => negativeStack?.maxY ?? 0;

  const BarChartItem({
    required super.x,
    this.positiveStack,
    this.negativeStack,
  });

  @override
  List<Object?> get props => [...super.props, positiveStack, negativeStack];
}
