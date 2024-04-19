import 'chart_bounds.dart';
import 'chart_item.dart';
import 'chart_layer.dart';

abstract class ChartItemLayer<Item extends ChartItem> implements ChartLayer {
  final List<Item> items;

  @override
  ChartBounds get bounds => ChartBounds.merge(items.map((item) => item.bounds));

  const ChartItemLayer({required this.items});
}
