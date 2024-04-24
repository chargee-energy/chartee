import 'dart:math';

import 'package:equatable/equatable.dart';

class ChartBounds with EquatableMixin {
  final double? minY;
  final double? maxY;
  final double? minX;
  final double? maxX;

  const ChartBounds({
    required this.minY,
    required this.maxY,
    required this.minX,
    required this.maxX,
  });

  const ChartBounds.flexible()
      : minY = null,
        maxY = null,
        minX = null,
        maxX = null;

  factory ChartBounds.merge(Iterable<ChartBounds> list) => list.fold(
        const ChartBounds.flexible(),
        (combined, bounds) => combined.mergeWith(bounds),
      );

  double getFractionX(double x) {
    if (this case ChartBounds(:final minX?, :final maxX?)) {
      return (x - minX) / (maxX - minX);
    }
    return x;
  }

  double getFractionY(double y) {
    if (this case ChartBounds(:final minY?, :final maxY?)) {
      return (y - minY) / (maxY - minY);
    }
    return y;
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
