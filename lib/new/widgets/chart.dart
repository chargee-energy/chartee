import 'package:flutter/material.dart';

import '../models/chart_bounds.dart';
import '../models/chart_layer.dart';
import 'chart_area.dart';
import 'chart_bars.dart';
import 'chart_grid.dart';
import 'chart_line.dart';

class Chart extends StatelessWidget {
  final List<ChartLayer> layers;
  final ChartBounds Function(ChartBounds bounds)? adjustBounds;

  const Chart({super.key, required this.layers, this.adjustBounds});

  @override
  Widget build(BuildContext context) {
    var bounds = ChartBounds.merge(layers.map((layer) => layer.bounds));

    if (adjustBounds case final adjustBounds?) {
      bounds = adjustBounds(bounds);
    }

    return Stack(
      fit: StackFit.expand,
      children: layers
          .map(
            (layer) => Padding(
              padding: EdgeInsets.fromLTRB(
                layer.extendBehindLeadingLabels ? 0 : 16,
                layer.extendBehindTopLabels ? 0 : 16,
                layer.extendBehindTrailingLabels ? 0 : 16,
                layer.extendBehindBottomLabels ? 0 : 16,
              ),
              child: switch (layer) {
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
                  :final dashArray,
                ) =>
                  ChartLine(
                    bounds: bounds,
                    points: items,
                    positiveColor: positiveColor,
                    negativeColor: negativeColor,
                    lineWidth: lineWidth,
                    dashArray: dashArray,
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
            ),
          )
          .toList(),
    );
  }
}
