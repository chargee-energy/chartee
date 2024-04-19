import '../models/chart_bar_layer.dart';
import '../models/chart_grid_layer.dart';
import '../models/chart_line_layer.dart';

abstract interface class ChartLayerVisitor {
  void visitChartGridLayer(ChartGridLayer layer);
  void visitChartLineLayer(ChartLineLayer layer);
  void visitChartBarLayer(ChartBarLayer layer);
}
