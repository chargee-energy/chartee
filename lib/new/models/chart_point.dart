import 'chart_bounds.dart';
import 'chart_item.dart';

class ChartPoint extends ChartItem {
  final double y;

  @override
  ChartBounds get bounds => ChartBounds.point(x: x, y: y);

  const ChartPoint({required super.x, required this.y});

  @override
  List<Object?> get props => [...super.props, y];
}
