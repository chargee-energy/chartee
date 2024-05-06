import 'dart:math';

import 'package:equatable/equatable.dart';

import 'chart_intervals.dart';

// TODO: Use num over double, maybe also Iterable over List?
class ChartBounds with EquatableMixin {
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;

  List<num> get intervalsX {
    if (this case ChartBounds(:final minX?, :final maxX?)) {
      final intervals = ChartIntervals(minValue: minX, maxValue: maxX);
      return intervals.values
          .where((value) => value >= minX && value <= maxX)
          .toList();
    }

    // TODO: Custom exception. Can't get intervals of unbounded
    throw Error();
  }

  List<num> get intervalsY {
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
      : minX = null,
        maxX = null,
        minY = null,
        maxY = null;

  const ChartBounds.point({double? x, double? y})
      : minX = x,
        maxX = x,
        minY = y,
        maxY = y;

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

  ChartBounds extendToNextIntervalX() {
    if (this case ChartBounds(:final minX?, :final maxX?)) {
      final intervals = ChartIntervals(minValue: minX, maxValue: maxX);
      return ChartBounds(
        minX: intervals.values.first.toDouble(),
        maxX: intervals.values.last.toDouble(),
        minY: minX,
        maxY: maxX,
      );
    }

    // TODO: Custom exception. Can't get extend to nearest rounding of unbounded
    throw Error();
  }

  ChartBounds extendToNextIntervalY() {
    if (this case ChartBounds(:final minY?, :final maxY?)) {
      final intervals = ChartIntervals(minValue: minY, maxValue: maxY);
      return ChartBounds(
        minX: minX,
        maxX: maxX,
        minY: intervals.values.first.toDouble(),
        maxY: intervals.values.last.toDouble(),
      );
    }

    // TODO: Custom exception. Can't get extend to nearest rounding of unbounded
    throw Error();
  }

  ChartBounds mergeWith(ChartBounds other) => ChartBounds(
        minX: _lowestValue(minX, other.minX),
        maxX: _highestValue(maxX, other.maxX),
        minY: _lowestValue(minY, other.minY),
        maxY: _highestValue(maxY, other.maxY),
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
