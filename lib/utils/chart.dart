import 'dart:math' as math;

import 'package:collection/collection.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';

typedef BoundsAdjuster = BoundingBox Function(BoundingBox bounds);

class AdjustBounds {
  static BoundingBox noAdjustment(BoundingBox bounds) => bounds;
}

abstract interface class IntervalsProvider {
  BoundingBox get adjustedBounds;
  List<double> get intervals;
}

class AllXIntervals implements IntervalsProvider {
  final BoundingBox bounds;
  final List<ChartItem> items;

  @override
  BoundingBox get adjustedBounds => bounds;

  @override
  List<double> get intervals => items.map((item) => item.x).toList();

  const AllXIntervals({required this.bounds, required this.items});

  factory AllXIntervals.create(BoundingBox bounds, List<ChartItem> items) =>
      AllXIntervals(bounds: bounds, items: items);
}

class OutlineXIntervals implements IntervalsProvider {
  final BoundingBox bounds;

  @override
  BoundingBox get adjustedBounds => bounds;

  @override
  List<double> get intervals =>
      [bounds.minX, bounds.maxX].whereNotNull().toList();

  const OutlineXIntervals({required this.bounds});

  factory OutlineXIntervals.create(BoundingBox bounds, List<ChartItem> items) =>
      OutlineXIntervals(bounds: bounds);
}

class OutlineYIntervals implements IntervalsProvider {
  final BoundingBox bounds;

  @override
  BoundingBox get adjustedBounds => bounds;

  @override
  List<double> get intervals {
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

  const OutlineYIntervals({required this.bounds});

  factory OutlineYIntervals.create(BoundingBox bounds, List<ChartItem> items) =>
      OutlineYIntervals(bounds: bounds);
}

class RoundedYIntervals implements IntervalsProvider {
  final BoundingBox bounds;
  final int numberOfTicks;

  final _ticks = <double>[];

  @override
  BoundingBox get adjustedBounds => _ticks.isNotEmpty
      ? bounds.mergeWith(BoundingBox(minY: _ticks.first, maxY: _ticks.last))
      : bounds;

  @override
  List<double> get intervals => _ticks;

  RoundedYIntervals({required this.bounds, required this.numberOfTicks}) {
    _generateTicks();
  }

  void _generateTicks() {
    final min = bounds.minY;
    final max = bounds.maxY;

    if (min == null || max == null) {
      _ticks.addAll([0, 1]);
      return;
    }

    if (min == max) {
      if (min == 0) {
        _ticks.addAll([0, 1]);
        return;
      }

      final offset = min.abs() * 0.1;
      _ticks.addAll([min, min + offset]);
      return;
    }

    // Calculate initial interval
    final interval = (min - max) / numberOfTicks;

    // Determine exponent for rounding
    final exponent = (math.log(interval.abs()) / math.ln10).floor();
    final factor = (interval.abs() / math.pow(10, exponent));

    // Choose a "nice" base interval (1, 2, or 5)
    double niceInterval;
    if (factor < 1.5) {
      niceInterval = 1.0 * math.pow(10, exponent);
    } else if (factor < 3) {
      niceInterval = 2.0 * math.pow(10, exponent);
    } else {
      niceInterval = 5.0 * math.pow(10, exponent);
    }

    // Calculate new minimum and maximum values for the intervals
    final newMinValue = (min / niceInterval).floor() * niceInterval;
    final newMaxValue = (max / niceInterval).ceil() * niceInterval;

    // Generate tick values
    for (var tick = newMinValue; tick <= newMaxValue; tick += niceInterval) {
      _ticks.add(tick);
    }
  }
}

class CustomIntervals implements IntervalsProvider {
  @override
  final BoundingBox adjustedBounds;

  @override
  final List<double> intervals;

  const CustomIntervals({
    required BoundingBox bounds,
    required this.intervals,
  }) : adjustedBounds = bounds;
}
