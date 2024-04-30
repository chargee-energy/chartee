import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

num _log10(num x) => log(x) / ln10;

// TODO: Cleanup
class ChartIntervals with EquatableMixin {
  /// Have nice round numbers on the y-axis, this automatically works for small
  /// and big numbers.
  ///
  /// index 0 -> relative y coordinate
  /// index 1 -> scale
  static const _scale = [
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

  final num minValue;
  final num maxValue;

  List<num> get values {
    // TODO: What if minY and maxY are the same but not 0?
    if (minValue == 0 && maxValue == 0) {
      return [0, 1];
    }

    final baseValue = _getRoundedBaseValue(max(maxValue.abs(), minValue.abs()));
    final lines = <num>[];

    var start = minValue;
    var end = maxValue;

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

  const ChartIntervals({required this.minValue, required this.maxValue});

  List<num>? _findNearestScale(num relativeY) {
    return _scale.firstWhereOrNull((value) => value[0] >= relativeY.ceil());
  }

  /// Get a nice rounded value to base the chart line values on
  num _getRoundedBaseValue(num maxY) {
    // Find the magnitude (order of magnitude) of maxY
    final magnitude = _log10(maxY.abs()).floor();

    // Scale maxY down to have only the first digit and the rest behind the comma
    final relativeY = maxY / pow(10, magnitude);

    // Find the nearest scale and multiply it by the magnitude to get the rounded value
    final nearestScale = _findNearestScale(relativeY)?[1] ?? 0.5;
    final roundedValue = nearestScale * pow(10, magnitude);

    return roundedValue;
  }

  @override
  List<Object?> get props => [minValue, maxValue];
}
