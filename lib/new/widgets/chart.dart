import 'package:flutter/material.dart';

import '../models/chart_layer.dart';
import '../visitors/widget_chart_layer_visitor.dart';

class Chart extends StatelessWidget {
  final List<ChartLayer> layers;

  const Chart({super.key, required this.layers});

  @override
  Widget build(BuildContext context) {
    return WidgetChartLayerVisitor().build(context, layers);
  }
}
