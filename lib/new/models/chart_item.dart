import 'chart_bounds.dart';

abstract class ChartItem {
  final double x;

  ChartBounds get bounds;

  const ChartItem({required this.x});
}
