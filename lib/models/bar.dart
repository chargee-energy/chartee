import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

/// Represents a bar with specific values and styling properties.
class Bar with EquatableMixin {
  /// The starting value of the bar.
  final double fromValue;

  /// The ending value of the bar.
  final double toValue;

  /// The color of the bar.
  final Color color;

  /// The highlight color of the bar (nullable).
  final Color? highlightColor;

  /// The width of the bar (nullable).
  final double? width;

  /// The border radius of the bar.
  final BorderRadius borderRadius;

  /// Calculates the minimum value between [fromValue] and [toValue].
  double get minValue => min(fromValue, toValue);

  /// Calculates the maximum value between [fromValue] and [toValue].
  double get maxValue => max(fromValue, toValue);

  /// Constructs a new Bar instance.
  const Bar({
    required this.fromValue,
    required this.toValue,
    required this.color,
    this.highlightColor,
    this.width,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  List<Object?> get props => [
        fromValue,
        toValue,
        color,
        highlightColor,
        width,
        borderRadius,
      ];
}
