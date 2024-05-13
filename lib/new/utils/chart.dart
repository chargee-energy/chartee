import 'dart:math' as math;

import 'package:collection/collection.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';

/// Have nice round numbers on the chart, this automatically works for small
/// and big numbers.
///
/// index 0 -> relative coordinate
/// index 1 -> scale
const _scale = <List<double>>[
  [1, 0.4],
  [2, 0.5],
  [3, 1.5],
  [4, 1],
  [5, 2],
  [7, 3],
  [8, 4],
  [9, 3],
  [10, 4],
];

List<double>? _findNearestScale(double relativeValue) =>
    _scale.firstWhereOrNull((value) => value[0] >= relativeValue.ceil());

/// Get a nice rounded value to base the chart line values on
double _getRoundedBaseValue(double max) {
  // Find the magnitude (order of magnitude) of maxY
  final magnitude = (math.log(max) / math.ln10).floor();

  // Scale maxY down to have only the first digit and the rest behind the comma
  final relativeY = max / math.pow(10, magnitude);

  // Find the nearest scale and multiply it by the magnitude to get the rounded value
  final nearestScale = _findNearestScale(relativeY)?[1] ?? 0.5;
  final roundedValue = nearestScale * math.pow(10, magnitude);

  return roundedValue;
}

typedef IntervalsBuilder = List<double> Function(
  BoundingBox bounds,
  List<ChartItem> values,
);

class IntervalsX {
  static List<double> outline(BoundingBox bounds, List<ChartItem> items) {
    final values = items.map((item) => item.x);
    return [values.min, values.max];
  }

  static List<double> all(BoundingBox bounds, List<ChartItem> items) =>
      items.map((item) => item.x).toList();
}

class IntervalsY {
  static List<double> outline(BoundingBox bounds, List<ChartItem> items) {
    final min = bounds.minY;
    final max = bounds.maxY;

    if (min == null || max == null) {
      return [];
    }

    if (min < 0 && max > 0) {
      return [min, 0, max];
    }

    return [min, max];
  }

  static List<double> rounded(BoundingBox bounds, List<ChartItem> items) {
    final min = bounds.minY;
    final max = bounds.maxY;

    if (min == null || max == null) {
      return [];
    }

    final value = math.max(min.abs(), max.abs());
    final baseValue = _getRoundedBaseValue(value.abs());
    final lines = <double>[];

    var start = min;
    var end = max;

    if (start % baseValue != 0) {
      start = baseValue * (start / baseValue).floor();
    }

    if (end % baseValue != 0) {
      end = baseValue * (end / baseValue).ceil();
    }

    for (var line = start; line <= end; line += baseValue) {
      lines.add(line);
    }

    return lines;
  }
}

typedef BoundsAdjuster = BoundingBox Function(BoundingBox bounds);

class AdjustBounds {
  static BoundingBox noAdjustment(BoundingBox bounds) => bounds;

  static BoundsAdjuster rounded({
    bool x = false,
    bool y = true,
  }) =>
      (BoundingBox bounds) {
        final xAxis = x
            ? _getRoundedValues(bounds.minX, bounds.maxX)
            : (bounds.minX, bounds.maxX);

        final yAxis = y
            ? _getRoundedValues(bounds.minY, bounds.maxY)
            : (bounds.minY, bounds.maxY);

        return BoundingBox(
          minX: xAxis.$1,
          maxX: xAxis.$2,
          minY: yAxis.$1,
          maxY: yAxis.$2,
        );
      };

  static (double? min, double? max) _getRoundedValues(
    double? min,
    double? max,
  ) {
    final value = switch ((min, max)) {
      (final min?, null) => min,
      (null, final max?) => max,
      (final min?, final max?) => math.max(min, max),
      (null, null) => null
    };

    if (value == null) {
      return (null, null);
    }

    final baseValue = _getRoundedBaseValue(value.abs());
    double? resultMin;
    double? resultMax;

    if (min != null) {
      final minCount =
          min < 0 ? (min / baseValue).floor() : (min / baseValue).ceil();
      resultMin = minCount * baseValue;
    }

    if (max != null) {
      final maxCount =
          max < 0 ? (max / baseValue).floor() : (max / baseValue).ceil();
      resultMax = maxCount * baseValue;
    }

    return (resultMin, resultMax);
  }
}
