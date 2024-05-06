import 'package:flutter/material.dart';

import '../models/bar_stack.dart';
import '../models/chart_bounds.dart';
import '../models/chart_item.dart';
import '../models/chart_layer.dart';
import 'chart_area.dart';
import 'chart_bars.dart';
import 'chart_grid.dart';
import 'chart_line.dart';
import 'chart_selection.dart';

class ChartLayerStack extends StatelessWidget {
  final ChartBounds bounds;
  final List<ChartLayer> layers;
  final List<ChartItem> selectedItems;

  const ChartLayerStack({
    super.key,
    required this.bounds,
    required this.layers,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
