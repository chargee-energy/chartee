import 'package:flutter/material.dart';

import '../models/chart_bounds.dart';
import '../models/chart_layer.dart';
import '../models/labels.dart';
import 'chart_gesture_handler.dart';
import 'chart_labels.dart';
import 'chart_layer_stack.dart';

class Chart extends StatelessWidget {
  final List<ChartLayer> layers;
  final Labels? leftLabels;
  final Labels? rightLabels;
  final Labels? topLabels;
  final Labels? bottomLabels;
  final ChartBounds Function(ChartBounds bounds)? adjustBounds;

  const Chart({
    super.key,
    required this.layers,
    this.leftLabels,
    this.rightLabels,
    this.topLabels,
    this.bottomLabels,
    this.adjustBounds,
  });

  @override
  Widget build(BuildContext context) {
    var bounds = ChartBounds.merge(layers.map((layer) => layer.bounds));

    if (adjustBounds case final adjustBounds?) {
      bounds = adjustBounds(bounds);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (leftLabels case final leftLabels?)
          ChartLabels(
            bounds: bounds,
            labels: leftLabels,
            intervals: bounds.intervalsY,
          ),
        Expanded(
          child: ChartGestureHandler(
            bounds: bounds,
            items: layers
                .whereType<ChartItemLayer>()
                .fold([], (result, layer) => [...result, ...layer.items]),
            builder: (context, selectedItems) => ChartLayerStack(
              bounds: bounds,
              layers: layers,
              selectedItems: selectedItems,
            ),
          ),
        ),
        if (rightLabels case final rightLabels?)
          ChartLabels(
            bounds: bounds,
            labels: rightLabels,
            intervals: bounds.intervalsY,
          ),
      ],
    );
  }
}
