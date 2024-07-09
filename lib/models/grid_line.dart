import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Represents a grid line used for styling grid lines in a chart.
///
/// A [GridLine] can have a specific [color], [width], [dashArray], and [extendBehindLabels] property.
class GridLine with EquatableMixin {
  /// The color of the grid line.
  final Color color;

  /// The width of the grid line.
  final double width;

  /// The dash array for creating dashed lines.
  final List<double>? dashArray;

  /// Whether the grid line should extend behind labels.
  final bool extendBehindLabels;

  /// Creates a [GridLine] with the given properties.
  const GridLine({
    required this.color,
    this.width = 1,
    this.dashArray,
    this.extendBehindLabels = false,
  });

  @override
  List<Object?> get props => [color, width, dashArray, extendBehindLabels];
}

typedef GridLineBuilder = GridLine? Function(int index, double value);
