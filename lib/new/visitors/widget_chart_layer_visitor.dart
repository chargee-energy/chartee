import 'package:flutter/material.dart';

import '../models/chart_bar_layer.dart';
import '../models/chart_bounds.dart';
import '../models/chart_grid_layer.dart';
import '../models/chart_layer.dart';
import '../models/chart_line_layer.dart';
import '../widgets/chart_line.dart';
import 'chart_layer_visitor.dart';

class WidgetChartLayerVisitor implements ChartLayerVisitor {
  late ChartBounds _bounds;
  late List<Widget> _children;

  Widget build(BuildContext context, List<ChartLayer> layers) {
    _bounds = ChartBounds.merge(layers.map((layer) => layer.bounds));
    _children = [];

    for (final layer in layers) {
      layer.accept(this);
    }

    return Stack(fit: StackFit.expand, children: _children);
  }

  @override
  void visitChartGridLayer(ChartGridLayer layer) {
    print('render grid');
  }

  @override
  void visitChartLineLayer(ChartLineLayer layer) {
    _children.add(ChartLine(bounds: _bounds, layer: layer));
  }

  @override
  void visitChartBarLayer(ChartBarLayer layer) {
    print('render bar');
  }
}
