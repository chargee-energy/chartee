import 'package:equatable/equatable.dart';

import 'bounding_box.dart';

/// Represents an abstract chart item.
///
/// This class serves as a base class for chart items and provides common properties and methods.
abstract class ChartItem with EquatableMixin {
  /// The x-coordinate of the chart item.
  final double x;

  /// The bounding box of the chart item.
  BoundingBox get bounds;

  /// Creates a [ChartItem] with the specified x-coordinate.
  const ChartItem({required this.x});

  @override
  List<Object?> get props => [x];
}
