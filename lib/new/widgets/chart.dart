import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/chart_layer.dart';
import '../models/labels.dart';
import '../utils/chart.dart';
import 'chart_gesture_handler.dart';
import 'chart_layer_stack.dart';
import 'chart_x_labels.dart';
import 'chart_y_labels.dart';

class Chart extends StatelessWidget {
  final List<ChartLayer> layers;
  final EdgeInsets padding;
  final Labels? leftLabels;
  final Labels? rightLabels;
  final Labels? topLabels;
  final Labels? bottomLabels;
  final ValueChanged<List<ChartItem>>? onSelectionChanged;
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
    final bounds =
        adjustBounds(BoundingBox.merge(layers.map((layer) => layer.bounds)));

    final items = layers
        .whereType<ChartItemLayer>()
        .fold(<ChartItem>[], (result, layer) => [...result, ...layer.items]);

    final xIntervals = xIntervalsProvider(bounds, items);
    final yIntervals = yIntervalsProvider(bounds, items);

    final intervalsAdjustedBounds = BoundingBox.merge(
      [
        xIntervals.adjustedBounds,
        yIntervals.adjustedBounds,
      ],
    );

    final topLabelValues = _getLabelValues(
      topLabels,
      xIntervals.intervals,
      intervalsAdjustedBounds.getFractionX,
    );

    final bottomLabelValues = _getLabelValues(
      bottomLabels,
      xIntervals.intervals,
      intervalsAdjustedBounds.getFractionX,
    );

    final leftLabelValues = _getLabelValues(
      leftLabels,
      yIntervals.intervals,
      intervalsAdjustedBounds.getFractionY,
    );

    final rightLabelValues = _getLabelValues(
      rightLabels,
      yIntervals.intervals,
      intervalsAdjustedBounds.getFractionY,
    );

    final topLabelsSize = _getLargestLabelSize(topLabels, topLabelValues);
    final bottomLabelsSize =
        _getLargestLabelSize(bottomLabels, bottomLabelValues);
    final leftLabelsSize = _getLargestLabelSize(leftLabels, leftLabelValues);
    final rightLabelsSize = _getLargestLabelSize(rightLabels, rightLabelValues);

    final contentPadding = padding +
        EdgeInsets.fromLTRB(
          leftLabelsSize.width,
          topLabelsSize.height,
          rightLabelsSize.width,
          bottomLabelsSize.height,
        );

    return ChartGestureHandler(
      padding: contentPadding,
      bounds: intervalsAdjustedBounds,
      items: items,
      onSelectionChanged: onSelectionChanged,
      builder: (context, selectedItems) => ChartLayerStack(
        padding: contentPadding,
        bounds: intervalsAdjustedBounds,
        xIntervals: xIntervals.intervals,
        yIntervals: yIntervals.intervals,
        layers: layers,
        selectedItems: selectedItems,
        labels: [
          if (topLabels case final labels?
              when topLabelValues != null && topLabelValues.isNotEmpty)
            Positioned(
              left: padding.left + leftLabelsSize.width,
              right: padding.right + rightLabelsSize.width,
              top: labels.padding.top,
              height: topLabelsSize.height - labels.padding.vertical,
              child: ChartXLabels(
                labels: labels,
                values: topLabelValues,
              ),
            ),
          if (bottomLabels case final labels?
              when bottomLabelValues != null && bottomLabelValues.isNotEmpty)
            Positioned(
              left: padding.left + leftLabelsSize.width,
              right: padding.right + rightLabelsSize.width,
              bottom: labels.padding.bottom,
              height: bottomLabelsSize.height - labels.padding.vertical,
              child: ChartXLabels(
                labels: labels,
                values: bottomLabelValues,
              ),
            ),
          if (leftLabels case final labels?
              when leftLabelValues != null && leftLabelValues.isNotEmpty)
            Positioned(
              top: padding.top + topLabelsSize.height,
              bottom: padding.bottom + bottomLabelsSize.height,
              left: labels.padding.left,
              width: leftLabelsSize.width - labels.padding.horizontal,
              child: ChartYLabels(
                labels: labels,
                values: leftLabelValues,
              ),
            ),
          if (rightLabels case final labels?
              when rightLabelValues != null && rightLabelValues.isNotEmpty)
            Positioned(
              top: padding.top + topLabelsSize.height,
              bottom: padding.bottom + bottomLabelsSize.height,
              right: labels.padding.right,
              width: rightLabelsSize.width - labels.padding.horizontal,
              child: ChartYLabels(
                labels: labels,
                values: rightLabelValues,
              ),
            ),
        ],
      ),
    );
  }

  List<({double fraction, TextPainter painter})>? _getLabelValues(
    Labels? labels,
    List<double> intervals,
    double Function(double) getFraction,
  ) =>
      labels != null
          ? intervals
              .mapIndexed(
                (index, interval) {
                  final text =
                      labels.getLabelText?.call(index, interval.toDouble());

                  if (text == null) {
                    return null;
                  }

                  final painter = TextPainter(
                    text: TextSpan(text: text, style: labels.style),
                    textAlign: labels.textAlign,
                    textDirection: TextDirection.ltr,
                  )..layout();

                  return (
                    fraction: getFraction(interval),
                    painter: painter,
                  );
                },
              )
              .whereNotNull()
              .toList()
          : null;

  Size _getLargestLabelSize(
    Labels? labels,
    List<({double fraction, TextPainter painter})>? values,
  ) {
    if (values == null) {
      return Size.zero;
    }

    final horizontalPadding = labels?.padding.horizontal ?? 0;
    final verticalPadding = labels?.padding.vertical ?? 0;
    final largestLabelSize = values.map((value) => value.painter.size).fold(
          Size.zero,
          (result, size) => Size(
            max(result.width, size.width),
            max(result.height, size.height),
          ),
        );

    return Size(
      largestLabelSize.width + horizontalPadding,
      largestLabelSize.height + verticalPadding,
    );
  }
}
