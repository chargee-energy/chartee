import 'package:flutter/material.dart';

import '../models/chart_bounds.dart';
import '../models/chart_layer.dart';
import 'chart_area.dart';
import 'chart_bars.dart';
import 'chart_grid.dart';
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
              ChartGridLayer(
                :final horizontalLineBuilder,
                :final verticalLineBuilder,
              ) =>
                ChartGrid(
                  bounds: bounds,
                  horizontalLineBuilder: horizontalLineBuilder,
                  verticalLineBuilder: verticalLineBuilder,
                ),
              ChartLineLayer(
                :final items,
                :final positiveColor,
                :final negativeColor,
                :final lineWidth,
              ) =>
                ChartLine(
                  bounds: bounds,
                  points: items,
                  positiveColor: positiveColor,
                  negativeColor: negativeColor,
                  lineWidth: lineWidth,
                ),
              ChartAreaLayer(
                :final items,
                :final positiveColor,
                :final negativeColor,
              ) =>
                ChartArea(
                  bounds: bounds,
                  points: items,
                  positiveColor: positiveColor,
                  negativeColor: negativeColor,
                ),
              ChartBarLayer(:final items) =>
                ChartBars(bounds: bounds, barStacks: items),
            },
          )
          .toList(),
    );
  }
}
