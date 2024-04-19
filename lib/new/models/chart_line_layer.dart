import '../visitors/chart_layer_visitor.dart';
import 'chart_item_layer.dart';
import 'chart_point.dart';

class ChartLineLayer extends ChartItemLayer<ChartPoint> {
  const ChartLineLayer({required super.items});

  @override
  void accept(ChartLayerVisitor visitor) {
    visitor.visitChartLineLayer(this);
  }
}
