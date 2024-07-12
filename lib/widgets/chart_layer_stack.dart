import 'package:flutter/material.dart';

import '../models/bar_stack.dart';
import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/chart_layer.dart';
import 'chart_area.dart';
import 'chart_bars.dart';
import 'chart_cursor.dart';
import 'chart_grid.dart';
import 'chart_line.dart';
import 'chart_selection.dart';

class ChartLayerStack extends StatelessWidget {
  final EdgeInsets padding;
  final BoundingBox bounds;
  final List<double> xIntervals;
  final List<double> yIntervals;
  final List<ChartLayer> layers;
  final List<ChartItem> selectedItems;
  final List<Widget> labels;

  const ChartLayerStack({
    super.key,
    required this.padding,
    required this.bounds,
    required this.xIntervals,
    required this.yIntervals,
    required this.layers,
    required this.selectedItems,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ...labels,
        ...layers.map(
          (layer) => switch (layer) {
            ChartGridLayer(
              :final horizontalLineBuilder,
              :final verticalLineBuilder,
            ) =>
              ChartGrid(
                padding: padding,
                bounds: bounds,
                xIntervals: xIntervals,
                yIntervals: yIntervals,
                horizontalLineBuilder: horizontalLineBuilder,
                verticalLineBuilder: verticalLineBuilder,
              ),
            ChartSelectionLayer(
              :final builder,
              :final sticky,
              :final translation,
              :final initialItems,
            ) =>
              ChartSelection(
                padding: padding,
                bounds: bounds,
                items: selectedItems,
                initialItems: initialItems,
                builder: builder,
                sticky: sticky,
                translation: translation,
              ),
            ChartLineLayer(
              :final items,
              :final positiveColor,
              :final negativeColor,
              :final lineWidth,
              :final dashArray,
            ) =>
              Padding(
                padding: padding,
                child: ChartLine(
                  bounds: bounds,
                  points: items,
                  positiveColor: positiveColor,
                  negativeColor: negativeColor,
                  lineWidth: lineWidth,
                  dashArray: dashArray,
                ),
              ),
            ChartAreaLayer(
              :final items,
              :final positiveColor,
              :final negativeColor,
            ) =>
              Padding(
                padding: padding,
                child: ChartArea(
                  bounds: bounds,
                  points: items,
                  positiveColor: positiveColor,
                  negativeColor: negativeColor,
                ),
              ),
            ChartBarLayer(:final items) => Padding(
                padding: padding,
                child: ChartBars(
                  bounds: bounds,
                  barStacks: items,
                  selectedBarStacks:
                      selectedItems.whereType<BarStack>().toList(),
                ),
              ),
            ChartCursorLayer(:final builder, :final point) => Padding(
                padding: padding,
                child: ChartCursor(
                  bounds: bounds,
                  builder: builder,
                  point: point,
                ),
              ),
            ChartCustomLayer(:final builder) =>
              builder(context, bounds, padding),
          },
        ),
      ],
    );
  }
}
