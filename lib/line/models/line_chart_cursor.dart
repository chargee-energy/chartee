import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A model to determine whether the cursor should be rendered and what it will
/// look like.
class LineChartCursor with EquatableMixin {
  /// Whether the cursor should be visible.
  final bool visible;

  /// The duration of the animation of the cursor position.
  final Duration animationDuration;

  /// A function to get the cursor widget.
  final Widget Function(bool isPositive)? getCursor;

  const LineChartCursor({
    this.visible = false,
    this.animationDuration = const Duration(seconds: 1),
    this.getCursor,
  });

  @override
  List<Object?> get props => [visible, animationDuration, getCursor];
}
