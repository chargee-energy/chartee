import 'chart_bounds.dart';
import 'chart_item.dart';
import 'chart_point.dart';

sealed class ChartLayer {
  ChartBounds get bounds;
}

class ChartGridLayer implements ChartLayer {
  final bool showHorizontal;
  final bool showVertical;

  @override
  ChartBounds get bounds => const ChartBounds.flexible();

  const ChartGridLayer.all()
      : showHorizontal = true,
        showVertical = true;

  const ChartGridLayer.horizontal()
      : showHorizontal = true,
        showVertical = false;

  const ChartGridLayer.vertical()
      : showHorizontal = false,
        showVertical = true;
}

sealed class ChartItemLayer<Item extends ChartItem> implements ChartLayer {
  final List<Item> items;

  @override
  ChartBounds get bounds => ChartBounds.merge(items.map((item) => item.bounds));

  const ChartItemLayer({required this.items});
}

class ChartBarLayer extends ChartItemLayer<ChartItem> {
  const ChartBarLayer({required super.items});
}

class ChartLineLayer extends ChartItemLayer<ChartPoint> {
  const ChartLineLayer({required super.items});
}
