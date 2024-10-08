import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/chart_layer.dart';
import '../models/labels.dart';
import '../utils/chart.dart';
import 'chart_x_labels.dart';
import 'chart_y_labels.dart';

class ChartBase extends StatelessWidget {
  final List<ChartLayer> layers;
  final EdgeInsets padding;
  final Labels? leftLabels;
  final Labels? rightLabels;
  final Labels? topLabels;
  final Labels? bottomLabels;
  final BoundsAdjuster adjustBounds;
  final IntervalsProvider Function(BoundingBox bounds, List<ChartItem> items)
      xIntervalsProvider;
  final IntervalsProvider Function(BoundingBox bounds, List<ChartItem> items)
      yIntervalsProvider;
  final Widget Function(
    BuildContext context,
    BoundingBox bounds,
    List<ChartItem> items,
    EdgeInsets contentPadding,
    IntervalsProvider xIntervals,
    IntervalsProvider yIntervals,
    Widget? leftLabels,
    Widget? rightLabels,
    Widget? topLabels,
    Widget? bottomLabels,
  ) builder;

  const ChartBase({
    super.key,
    required this.layers,
    this.padding = EdgeInsets.zero,
    this.leftLabels,
    this.rightLabels,
    this.topLabels,
    this.bottomLabels,
    this.adjustBounds = AdjustBounds.noAdjustment,
    this.xIntervalsProvider = OutlineXIntervals.create,
    this.yIntervalsProvider = OutlineYIntervals.create,
    required this.builder,
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

    final leftLabels = this.leftLabels;
    final rightLabels = this.rightLabels;
    final topLabels = this.topLabels;
    final bottomLabels = this.bottomLabels;

    final topLabelValues = _getLabelValues(
      context,
      topLabels,
      xIntervals.intervals,
      intervalsAdjustedBounds.getFractionX,
    );

    final bottomLabelValues = _getLabelValues(
      context,
      bottomLabels,
      xIntervals.intervals,
      intervalsAdjustedBounds.getFractionX,
    );

    final leftLabelValues = _getLabelValues(
      context,
      leftLabels,
      yIntervals.intervals,
      intervalsAdjustedBounds.getFractionY,
    );

    final rightLabelValues = _getLabelValues(
      context,
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

    return builder(
      context,
      intervalsAdjustedBounds,
      items,
      contentPadding,
      xIntervals,
      yIntervals,
      (leftLabels != null &&
              leftLabelValues != null &&
              leftLabelValues.isNotEmpty)
          ? Positioned(
              top: padding.top + topLabelsSize.height,
              bottom: padding.bottom + bottomLabelsSize.height,
              left: leftLabels.padding.left,
              width: leftLabelsSize.width - leftLabels.padding.horizontal,
              child: ChartYLabels(
                labels: leftLabels,
                values: leftLabelValues,
              ),
            )
          : null,
      (rightLabels != null &&
              rightLabelValues != null &&
              rightLabelValues.isNotEmpty)
          ? Positioned(
              top: padding.top + topLabelsSize.height,
              bottom: padding.bottom + bottomLabelsSize.height,
              right: rightLabels.padding.right,
              width: rightLabelsSize.width - rightLabels.padding.horizontal,
              child: ChartYLabels(
                labels: rightLabels,
                values: rightLabelValues,
              ),
            )
          : null,
      (topLabels != null && topLabelValues != null && topLabelValues.isNotEmpty)
          ? Positioned(
              left: padding.left + leftLabelsSize.width,
              right: padding.right + rightLabelsSize.width,
              top: topLabels.padding.top,
              height: topLabelsSize.height - topLabels.padding.vertical,
              child: ChartXLabels(
                labels: topLabels,
                values: topLabelValues,
              ),
            )
          : null,
      (bottomLabels != null &&
              bottomLabelValues != null &&
              bottomLabelValues.isNotEmpty)
          ? Positioned(
              left: padding.left + leftLabelsSize.width,
              right: padding.right + rightLabelsSize.width,
              bottom: bottomLabels.padding.bottom,
              height: bottomLabelsSize.height - bottomLabels.padding.vertical,
              child: ChartXLabels(
                labels: bottomLabels,
                values: bottomLabelValues,
              ),
            )
          : null,
    );
  }

  List<({double fraction, TextPainter painter})>? _getLabelValues(
    BuildContext context,
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
                    textScaler: MediaQuery.textScalerOf(context),
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
