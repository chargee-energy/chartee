import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// The rendering information for a bar that will be shown in a bar chart.
class BarChartBar with EquatableMixin {
  /// The value of this bar, this will be used to determine the height.
  final double value;

  /// The color of the bar that will be drawn
  final Color color;

  /// The width of the bar that will be drawn. The bar will be constraint by
  /// the stack that it is part of so higher values than it's stack won't make
  /// the bar wider.
  final double? width;

  /// The border radius of the bar that will be drawn. If this bar is the
  /// highest in the stack that it is part of it will inherit the border radius
  /// of the stack if that is more rounded.
  final BorderRadius borderRadius;

  const BarChartBar({
    required this.value,
    required this.color,
    this.width,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  List<Object?> get props => [value, color, width, borderRadius];
}
