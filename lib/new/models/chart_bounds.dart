import 'dart:math';

import 'package:equatable/equatable.dart';

import 'chart_intervals.dart';

// TODO: Use num over double, maybe also Iterable over List?
class ChartBounds with EquatableMixin {
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  // TODO: Exception if unbounded?
  List<num> get intervals {
    if (this case ChartBounds(:final minY?, :final maxY?)) {
      final intervals = ChartIntervals(minValue: minY, maxValue: maxY);
      return intervals.values
          .where((value) => value >= minY && value <= maxY)
          .toList();
    }

    // TODO: Custom exception. Can't get intervals of unbounded
    throw Error();
  }

  const ChartBounds({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  const ChartBounds.flexible()
      : minY = null,
        maxY = null,
        minX = null,
        maxX = null;

  const ChartBounds.point({double? x, double? y})
      : minY = y,
        maxY = y,
        minX = x,
        maxX = x;

  factory ChartBounds.merge(Iterable<ChartBounds> list) => list.fold(
        const ChartBounds.flexible(),
        (combined, bounds) => combined.mergeWith(bounds),
      );

  double getFractionX(num x) {
    if (this case ChartBounds(:final minX?, :final maxX?)) {
      return (x - minX) / (maxX - minX);
    }

    // TODO: Custom exception. Can't get fraction of unbounded
    throw Error();
  }

  double getFractionY(num y) {
    if (this case ChartBounds(:final minY?, :final maxY?)) {
      return 1 - (y - minY) / (maxY - minY);
    }

    // TODO: Custom exception. Can't get fraction of unbounded
    throw Error();
  }

  ChartBounds extendToNearestRounding() {
    if (this case ChartBounds(:final minY?, :final maxY?)) {
      final intervals = ChartIntervals(minValue: minY, maxValue: maxY);
      return ChartBounds(
        minY: intervals.values.first.toDouble(),
        maxY: intervals.values.last.toDouble(),
        minX: minX,
        maxX: maxX,
      );
    }

    // TODO: Custom exception. Can't get extend to nearest rounding of unbounded
    throw Error();
  }

  ChartBounds mergeWith(ChartBounds other) => ChartBounds(
        minY: _lowestValue(minY, other.minY),
        maxY: _highestValue(maxY, other.maxY),
        minX: _lowestValue(minX, other.minX),
        maxX: _highestValue(maxX, other.maxX),
      );

  double? _lowestValue(double? a, double? b) {
    if (a != null && b != null) return min(a, b);
    if (a != null && b == null) return a;
    if (a == null && b != null) return b;
    return null;
  }

  double? _highestValue(double? a, double? b) {
    if (a != null && b != null) return max(a, b);
    if (a != null && b == null) return a;
    if (a == null && b != null) return b;
    return null;
  }

  @override
  List<Object?> get props => [minY, maxY, minX, maxX];
}
