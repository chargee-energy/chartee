import 'package:collection/collection.dart';
import 'package:flutter/painting.dart';

import '../errors/empty_error.dart';
import 'bar.dart';
import 'bounding_box.dart';
import 'chart_item.dart';

/// Represents a stack of bars in a chart.
///
/// A [BarStack] is a collection of bars displayed in a chart.
/// It calculates the minimum and maximum values of the bars to determine its bounds.
class BarStack extends ChartItem {
  /// The list of bars in the stack.
  final List<Bar> bars;

  /// The width of the bar stack.
  final double width;

  /// The border radius of the bar stack.
  final BorderRadius borderRadius;

  /// Calculates the minimum Y value among the bars.
  double get minY {
    _checkIfEmpty();
    return bars.map((bar) => bar.minValue).min;
  }

  /// Calculates the maximum Y value among the bars.
  double get maxY {
    _checkIfEmpty();
    return bars.map((bar) => bar.maxValue).max;
  }

  @override
  BoundingBox get bounds {
    _checkIfEmpty();
    return BoundingBox(minX: x, maxX: x, minY: minY, maxY: maxY);
  }

  /// Creates a [BarStack] with the specified parameters.
  const BarStack({
    required super.x,
    required this.bars,
    this.width = 8,
    this.borderRadius = BorderRadius.zero,
  });

  /// Checks if the bar stack is empty and throws an [EmptyError] if it is.
  void _checkIfEmpty() {
    if (bars.isEmpty) {
      throw EmptyError(
        message:
            "BarStack instance is empty. It requires at least one 'Bar' object to calculate bounds and values.",
      );
    }
  }

  @override
  List<Object?> get props => [...super.props, bars, width, borderRadius];
}
