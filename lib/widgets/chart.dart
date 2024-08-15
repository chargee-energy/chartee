import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/chart_layer.dart';
import '../models/labels.dart';
import '../utils/chart.dart';
import '../utils/layers.dart';
import 'chart_base.dart';
import 'chart_gesture_handler.dart';

class Chart extends StatelessWidget {
  final List<ChartLayer> layers;
  final EdgeInsets padding;
  final Labels? leftLabels;
  final Labels? rightLabels;
  final Labels? topLabels;
  final Labels? bottomLabels;
  final ValueChanged<double?>? onSelectionChanged;
  final BoundsAdjuster adjustBounds;
  final IntervalsProvider Function(BoundingBox bounds, List<ChartItem> items)
      xIntervalsProvider;
  final IntervalsProvider Function(BoundingBox bounds, List<ChartItem> items)
      yIntervalsProvider;

  const Chart({
    super.key,
    required this.layers,
    this.padding = EdgeInsets.zero,
    this.leftLabels,
    this.rightLabels,
    this.topLabels,
    this.bottomLabels,
    this.onSelectionChanged,
    this.adjustBounds = AdjustBounds.noAdjustment,
    this.xIntervalsProvider = OutlineXIntervals.create,
    this.yIntervalsProvider = OutlineYIntervals.create,
  });

  @override
  Widget build(BuildContext context) {
    return ChartBase(
      layers: layers,
      padding: padding,
      leftLabels: leftLabels,
      rightLabels: rightLabels,
      topLabels: topLabels,
      bottomLabels: bottomLabels,
      adjustBounds: adjustBounds,
      xIntervalsProvider: xIntervalsProvider,
      yIntervalsProvider: yIntervalsProvider,
      builder: (
        context,
        bounds,
        items,
        contentPadding,
        xIntervals,
        yIntervals,
        leftLabels,
        rightLabels,
        topLabels,
        bottomLabels,
      ) =>
          ChartGestureHandler(
        padding: contentPadding,
        bounds: bounds,
        items: items,
        onSelectionChanged: onSelectionChanged,
        builder: (context, selectedX) => Stack(
          fit: StackFit.expand,
          children: layers
                  .map(
                    (layer) => getLayerWidget(
                      context,
                      layer,
                      bounds,
                      xIntervals.intervals,
                      yIntervals.intervals,
                      selectedX,
                      contentPadding,
                    ),
                  )
                  .toList() +
              [leftLabels, rightLabels, topLabels, bottomLabels]
                  .whereNotNull()
                  .toList(),
        ),
      ),
    );
  }
}
