import '../visitors/chart_layer_visitor.dart';
import 'chart_bounds.dart';
import 'chart_layer.dart';

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

  @override
  void accept(ChartLayerVisitor visitor) {
    visitor.visitChartGridLayer(this);
  }
}
