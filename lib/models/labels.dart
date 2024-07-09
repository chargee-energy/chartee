import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

/// A class representing labels configuration for a chart.
///
/// Labels contain information about text, alignment, padding, offset, and style.
class Labels with EquatableMixin {
  /// A function that returns the label text based on the index and value.
  final String Function(int index, double value)? getLabelText;

  /// The alignment of the label text.
  final TextAlign textAlign;

  /// The padding around the label text.
  final EdgeInsets padding;

  /// The offset of the label.
  final double offset;

  /// The style of the label text.
  final TextStyle? style;

  /// Creates a new Labels instance.
  ///
  /// The [getLabelText] function is required, while [textAlign], [padding],
  /// [offset], and [style] are optional parameters.
  const Labels({
    required this.getLabelText,
    this.textAlign = TextAlign.start,
    this.padding = EdgeInsets.zero,
    this.offset = 0,
    this.style,
  });

  @override
  List<Object?> get props => [getLabelText, textAlign, padding, offset, style];
}
