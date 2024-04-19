import 'chart_bounds.dart';
import 'chart_item.dart';

class ChartPoint extends ChartItem {
  final double y;

  @override
  ChartBounds get bounds => ChartBounds(minY: y, maxY: y, minX: x, maxX: x);

  const ChartPoint({required super.x, required this.y});
}
