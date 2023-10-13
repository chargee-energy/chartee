import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// The rendering information for a line that will be shown in the chart grid.
class ChartLine with EquatableMixin {
  /// The color of the line that will be drawn.
  final Color color;

  /// The width of the line that will be drawn.
  final double width;

  /// An array of values used to render a dashed line. This array should always
  /// contain 2 elements, the first element is the length of the dash and the
  /// second element is the space between the dashes. If the value doesn't meet
  /// these requirements a solid line will be rendered instead.
  ///
  /// Example: `[5, 10]` will draw a line of 5 pixels long followed by a blank
  /// space of 10 pixels.
  final List<int>? dashArray;

  const ChartLine({this.color = Colors.grey, this.width = 1, this.dashArray});

  @override
  List<Object?> get props => [color, width, dashArray];
}
