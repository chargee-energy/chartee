import 'package:flutter/material.dart';

import '../models/chart_bounds.dart';
import '../models/chart_layer.dart';
import 'chart_line.dart';

class Chart extends StatelessWidget {
  final List<ChartLayer> layers;

  const Chart({super.key, required this.layers});

  @override
  Widget build(BuildContext context) {
    final bounds = ChartBounds.merge(layers.map((layer) => layer.bounds));
    return Stack(
      fit: StackFit.expand,
      children: layers
          .map(
            (layer) => switch (layer) {
              ChartGridLayer() => Container(),
              ChartLineLayer() => ChartLine(bounds: bounds, layer: layer),
              ChartBarLayer() => Container(),
            },
          )
          .toList(),
    );
  }
}
