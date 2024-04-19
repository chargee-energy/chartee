import '../visitors/chart_layer_visitor.dart';
import 'chart_bounds.dart';

abstract interface class ChartLayer {
  ChartBounds get bounds;
  void accept(ChartLayerVisitor visitor);
}
