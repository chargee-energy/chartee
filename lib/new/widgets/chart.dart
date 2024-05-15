import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/chart_layer.dart';
import '../models/labels.dart';
import '../utils/chart.dart';
import 'chart_gesture_handler.dart';
import 'chart_grid.dart';
import 'chart_layer_stack.dart';
import 'chart_x_labels.dart';
import 'chart_y_labels.dart';

class Chart extends StatelessWidget {
  final List<ChartLayer> layers;
  final Labels? leftLabels;
  final Labels? rightLabels;
  final Labels? topLabels;
  final Labels? bottomLabels;
  final BoundsAdjuster adjustBounds;
  final IntervalsBuilder intervalsX;
  final IntervalsBuilder intervalsY;

  const Chart({
    super.key,
    required this.layers,
    this.leftLabels,
    this.rightLabels,
    this.topLabels,
    this.bottomLabels,
    this.adjustBounds = AdjustBounds.noAdjustment,
    this.intervalsX = IntervalsX.outline,
    this.intervalsY = IntervalsY.outline,
  });

  @override
  Widget build(BuildContext context) {
    final bounds = BoundingBox.merge(layers.map((layer) => layer.bounds));

    final items = layers
        .whereType<ChartItemLayer>()
        .fold(<ChartItem>[], (result, layer) => [...result, ...layer.items]);

    final intervalsX = this.intervalsX(bounds, items);
    final intervalsY = this.intervalsY(bounds, items);
    final adjustedBounds = adjustBounds(bounds);

    // TODO: Remove intervals outside of bounds

    final topLabelValues =
        _getLabelValues(topLabels, intervalsX, adjustedBounds.getFractionX);
    final bottomLabelValues =
        _getLabelValues(bottomLabels, intervalsX, adjustedBounds.getFractionX);
    final leftLabelValues =
        _getLabelValues(leftLabels, intervalsY, adjustedBounds.getFractionY);
    final rightLabelValues =
        _getLabelValues(rightLabels, intervalsY, adjustedBounds.getFractionY);

    // TODO: Don't add padding if there are no values
    final topLabelsHeight =
        (topLabelValues?.map((value) => value.painter.height).maxOrNull ?? 0) +
            (topLabels?.padding.vertical ?? 0);
    final bottomLabelsHeight =
        (bottomLabelValues?.map((value) => value.painter.height).maxOrNull ??
                0) +
            (bottomLabels?.padding.vertical ?? 0);
    final leftLabelsWidth =
        (leftLabelValues?.map((value) => value.painter.width).maxOrNull ?? 0) +
            (leftLabels?.padding.horizontal ?? 0);
    final rightLabelsWidth =
        (rightLabelValues?.map((value) => value.painter.width).maxOrNull ?? 0) +
            (rightLabels?.padding.horizontal ?? 0);

    return Stack(
      fit: StackFit.expand,
      children: [
        ...layers.whereType<ChartGridLayer>().map(
              (layer) => ChartGrid(
                bounds: adjustedBounds,
                intervalsX: intervalsX,
                intervalsY: intervalsY,
                horizontalLineBuilder: layer.horizontalLineBuilder,
                verticalLineBuilder: layer.verticalLineBuilder,
                padding: EdgeInsets.only(
                  top: topLabelsHeight,
                  bottom: bottomLabelsHeight,
                  left: leftLabelsWidth,
                  right: rightLabelsWidth,
                ),
              ),
            ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (leftLabels case final leftLabels?
                when leftLabelValues != null && leftLabelValues.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  top: topLabelsHeight,
                  bottom: bottomLabelsHeight,
                ),
                child: ChartYLabels(
                  labels: leftLabels,
                  values: leftLabelValues,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (topLabels case final topLabels?
                      when topLabelValues != null && topLabelValues.isNotEmpty)
                    ChartXLabels(
                      labels: topLabels,
                      values: topLabelValues,
                    ),
                  Expanded(
                    child: ChartGestureHandler(
                      bounds: adjustedBounds,
                      items: items,
                      builder: (context, selectedItems) => ChartLayerStack(
                        bounds: adjustedBounds,
                        intervalsX: intervalsX,
                        intervalsY: intervalsY,
                        layers: layers,
                        selectedItems: selectedItems,
                      ),
                    ),
                  ),
                  if (bottomLabels case final bottomLabels?
                      when bottomLabelValues != null &&
                          bottomLabelValues.isNotEmpty)
                    ChartXLabels(
                      labels: bottomLabels,
                      values: bottomLabelValues,
                    ),
                ],
              ),
            ),
            if (rightLabels case final rightLabels?
                when rightLabelValues != null && rightLabelValues.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  top: topLabelsHeight,
                  bottom: bottomLabelsHeight,
                ),
                child: ChartYLabels(
                  labels: rightLabels,
                  values: rightLabelValues,
                ),
              ),
          ],
        ),
      ],
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
}
