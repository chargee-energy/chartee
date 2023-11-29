import 'dart:math';

import 'package:collection/collection.dart';

double _log10(num x) => log(x) / ln10;

/// Have nice round numbers on the y-axis, this automatically works for small
/// and big numbers.
///
/// index 0 -> relative y coordinate
/// index 1 -> scale
const _scale = [
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

List<num>? _findNearestScale(double relativeY) {
  return _scale.firstWhereOrNull((value) => value[0] >= relativeY.ceil());
}

/// Get a nice rounded value to base the chart line values on
double _getRoundedBaseValue(double maxY) {
  // Find the magnitude (order of magnitude) of maxY
  final magnitude = _log10(maxY.abs()).floorToDouble();

  // Scale maxY down to have only the first digit and the rest behind the comma
  final relativeY = maxY / pow(10, magnitude);

  // Find the nearest scale and multiply it by the magnitude to get the rounded value
  final nearestScale = _findNearestScale(relativeY)?[1] ?? 0.5;
  final roundedValue = nearestScale * pow(10, magnitude);

  return roundedValue.toDouble();
}

/// Get rounded values to show the lines in the chart
List<double> getLineValues(double minY, double maxY) {
  if (minY == 0 && maxY == 0) {
    return [0, 1];
  }

  final baseValue = _getRoundedBaseValue(max(maxY, minY));

  final positiveLineCount = (maxY / baseValue).ceil();
  final positiveLines = List.generate(
    positiveLineCount,
    (index) => baseValue * (index + 1),
  );

  final negativeLineCount = (minY / baseValue).ceil();
  final negativeLines = List.generate(
    negativeLineCount,
    (index) => -baseValue * (index + 1),
  );

  return [...negativeLines.reversed, 0, ...positiveLines];
}
