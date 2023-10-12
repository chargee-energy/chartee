import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'bar_chart_bar.dart';

/// The rendering information for a stack of bars that will be shown in a bar
/// chart. The bars in this stack will be drawn on top of each other by the
/// order in which they appear in the array.
class BarChartBarStack with EquatableMixin {
  /// The width of the stack, used to contain the bars within the stack.
  final double width;

  /// The border radius of the stack, bars within the stack will be clipped so
  /// the highest bar in the stack will inherit this radius.
  final BorderRadius borderRadius;

  /// The bars that will be rendered in the stack.
  final List<BarChartBar> bars;

  /// The maximum value of all bars in the stack.
  double get maxY => bars.map((bar) => bar.value).maxOrNull ?? 0;

  const BarChartBarStack({
    this.width = 8,
    this.borderRadius = BorderRadius.zero,
    required this.bars,
  });

  @override
  List<Object?> get props => [width, borderRadius, bars];
}
