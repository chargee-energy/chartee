import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

class Labels with EquatableMixin {
  final String Function(int index, double value)? getLabelText;
  final TextAlign textAlign;
  final EdgeInsets padding;
  final double offset;
  final TextStyle? style;

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
