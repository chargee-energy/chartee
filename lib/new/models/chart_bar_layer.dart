import '../visitors/chart_layer_visitor.dart';
import 'chart_item.dart';
import 'chart_item_layer.dart';

class ChartBarLayer extends ChartItemLayer<ChartItem> {
  const ChartBarLayer({required super.items});

  @override
  void accept(ChartLayerVisitor visitor) {
    visitor.visitChartBarLayer(this);
  }
}
