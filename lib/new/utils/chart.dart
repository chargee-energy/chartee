import 'dart:math' as math;

import 'package:collection/collection.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';

List<double> _niceIntervals(double min, double max, int numberOfTicks) {
  // Calculate initial interval
  final dataRange = max - min;
  final interval = dataRange / numberOfTicks;

  // Determine exponent for rounding
  final exponent = (math.log(interval) / math.ln10).floor();
  final factor = interval / math.pow(10, exponent);

  // Choose a "nice" base interval (1, 2, or 5)
  double niceInterval;
  if (factor < 1.5) {
    niceInterval = 1.0 * math.pow(10, exponent);
  } else if (factor < 3) {
    niceInterval = 2.0 * math.pow(10, exponent);
  } else {
    niceInterval = 5.0 * math.pow(10, exponent);
  }

  // Recalculate tick range
  final startTick = (min / niceInterval).floor() * niceInterval;
  final endTick = (max / niceInterval).ceil() * niceInterval;

  // Generate tick values
  final ticks = <double>[];
  for (var tick = startTick; tick <= endTick; tick += niceInterval) {
    ticks.add(tick);
  }

  return ticks;
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

  static IntervalsBuilder rounded({int numberOfTicks = 3}) => (bounds, items) {
        final min = bounds.minY;
        final max = bounds.maxY;

        if (min == null || max == null) {
          return [];
        }

        return _niceIntervals(min, max, numberOfTicks);
      };
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
    if (min == null || max == null) {
      // TODO: Can we calculate something if one of them is null?
      return (min, max);
    }

    final intervals = _niceIntervals(min, max, 3);

    if (intervals.isEmpty) {
      return (min, max);
    }

    return (intervals.first, intervals.last);
  }
}
