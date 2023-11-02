import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A model to determine which labels should be rendered and what they will look
/// like for a specific axis.
class ChartAxisLabels<Value extends num> with EquatableMixin {
  /// Whether the labels on this axis should be visible.
  final bool visible;

  /// Padding to apply around the labels.
  final EdgeInsets padding;

  /// Offset to apply to the label. `0` means it will be centered with the
  /// line, `-0.5` will be before the line and `0.5` after the line.
  final double offset;

  /// Text style to apply to the labels.
  final TextStyle? style;

  /// A function to get the text that should be rendered in a label.
  final String? Function(Value value)? getLabelText;

  /// A way to override the default labels with a custom widget. If this is
  /// supplied `offset`, `style` and `getLabelText` will be ignored.
  final Widget? customLabels;

  const ChartAxisLabels({
    this.visible = false,
    this.padding = EdgeInsets.zero,
    this.offset = 0,
    this.style,
    this.getLabelText,
    this.customLabels,
  });

  @override
  List<Object?> get props => [
        visible,
        padding,
        offset,
        style,
        getLabelText,
        customLabels,
      ];
}
