import 'package:flutter/material.dart';

import '../models/bar_stack.dart';
import '../models/chart_bounds.dart';
import '../models/chart_layer.dart';
import 'chart_area.dart';
import 'chart_bars.dart';
import 'chart_gesture_handler.dart';
import 'chart_grid.dart';
import 'chart_line.dart';
import 'chart_selection.dart';

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

    // TODO: Apply padding from labels to gesture handler
    return ChartGestureHandler(
      bounds: bounds,
      items: layers
          .whereType<ChartItemLayer>()
          .fold([], (result, layer) => [...result, ...layer.items]),
      builder: (context, selectedItems) => Stack(
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
                ChartSelectionLayer(
                  :final builder,
                  :final sticky,
                  :final initialItems,
                ) =>
                  ChartSelection(
                    bounds: bounds,
                    items: selectedItems,
                    builder: builder,
                    sticky: sticky,
                    initialItems: initialItems,
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
                ChartBarLayer(:final items) => ChartBars(
                    bounds: bounds,
                    barStacks: items,
                    selectedBarStacks:
                        selectedItems.whereType<BarStack>().toList(),
                  ),
              },
            )
            .toList(),
      ),
    );
  }
}
