import 'dart:math';

import 'package:equatable/equatable.dart';

import '../errors/unbounded_error.dart';

/// A class representing a bounding box which can optionally have defined minimum and maximum X and Y coordinates.
///
/// This class can be used to represent a rectangular area in a coordinate system, where the bounds can be either fixed or flexible.
/// It includes methods for merging multiple bounding boxes and calculating fractional positions within the bounds.
class BoundingBox with EquatableMixin {
  /// The minimum X coordinate of the bounding box. Can be null for a flexible bounding box.
  final double? minX;

  /// The maximum X coordinate of the bounding box. Can be null for a flexible bounding box.
  final double? maxX;

  /// The minimum Y coordinate of the bounding box. Can be null for a flexible bounding box.
  final double? minY;

  /// The maximum Y coordinate of the bounding box. Can be null for a flexible bounding box.
  final double? maxY;

  /// Constructs a [BoundingBox] with specified minimum and maximum coordinates.
  ///
  /// This constructor initializes a bounding box with fixed bounds determined by the provided minimum and maximum coordinates for both the X and Y axes.
  /// If any of the parameters are set to null, the corresponding bound will be considered flexible or unbounded.
  ///
  /// Parameters:
  ///   - `minX`: The minimum X coordinate of the bounding box. Can be null for a flexible bounding box.
  ///   - `maxX`: The maximum X coordinate of the bounding box. Can be null for a flexible bounding box.
  ///   - `minY`: The minimum Y coordinate of the bounding box. Can be null for a flexible bounding box.
  ///   - `maxY`: The maximum Y coordinate of the bounding box. Can be null for a flexible bounding box.
  const BoundingBox({
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  });

  /// Creates a [BoundingBox] with no defined bounds.
  ///
  /// This constructor initializes a bounding box with all coordinates set to null,
  /// representing a completely flexible bounding box without any restrictions on its size or position.
  const BoundingBox.flexible()
      : minX = null,
        maxX = null,
        minY = null,
        maxY = null;

  /// Creates a [BoundingBox] representing a single point in the coordinate system.
  ///
  /// This constructor initializes a bounding box where both the minimum and maximum coordinates
  /// are set to the same point, effectively creating a bounding box that covers exactly one point.
  ///
  /// Parameters:
  ///   - `x`: The X coordinate of the point. If null, the X bounds remain undefined.
  ///   - `y`: The Y coordinate of the point. If null, the Y bounds remain undefined.
  const BoundingBox.point({double? x, double? y})
      : minX = x,
        maxX = x,
        minY = y,
        maxY = y;

  /// Constructs a [BoundingBox] that is only bounded on the X-axis.
  ///
  /// This constructor initializes a bounding box where only the X-axis has defined bounds,
  /// specified by the `min` and `max` parameters. The Y-axis remains unbounded, which means
  /// both `minY` and `maxY` are set to null.
  ///
  /// Parameters:
  ///   - `min`: The minimum X coordinate of the bounding box. Can be null if the lower bound is not defined.
  ///   - `max`: The maximum X coordinate of the bounding box. Can be null if the upper bound is not defined.
  const BoundingBox.x({double? min, double? max})
      : minX = min,
        maxX = max,
        minY = null,
        maxY = null;

  /// Constructs a [BoundingBox] that is only bounded on the Y-axis.
  ///
  /// This constructor initializes a bounding box where only the Y-axis has defined bounds,
  /// specified by the `min` and `max` parameters. The X-axis remains unbounded, which means
  /// both `minX` and `maxX` are set to null.
  ///
  /// Parameters:
  ///   - `min`: The minimum Y coordinate of the bounding box. Can be null if the lower bound is not defined.
  ///   - `max`: The maximum Y coordinate of the bounding box. Can be null if the upper bound is not defined.
  const BoundingBox.y({double? min, double? max})
      : minX = null,
        maxX = null,
        minY = min,
        maxY = max;

  /// Creates a new [BoundingBox] that encompasses all the bounding boxes in the provided iterable.
  ///
  /// This factory constructor takes an iterable of [BoundingBox] instances and merges them into a single
  /// [BoundingBox] that covers all the areas defined by the individual bounding boxes. If the iterable is empty,
  /// it returns a flexible [BoundingBox] with all coordinates set to null.
  ///
  /// The merging process involves calculating the minimum and maximum X and Y coordinates across all provided
  /// bounding boxes. If any bounding box in the iterable is unbounded (i.e., has null for any coordinate),
  /// the resulting bounding box will also be unbounded in that direction.
  ///
  /// Example:
  /// ```dart
  /// var box1 = BoundingBox(minX: 1, maxX: 3, minY: 1, maxY: 3);
  /// var box2 = BoundingBox(minX: 2, maxX: 5, minY: 2, maxY: 5);
  /// var mergedBox = BoundingBox.merge([box1, box2]);
  /// print(mergedBox.minX); // Output: 1
  /// print(mergedBox.maxX); // Output: 5
  /// print(mergedBox.minY); // Output: 1
  /// print(mergedBox.maxY); // Output: 5
  /// ```
  ///
  /// Parameters:
  ///   - `boxes`: An iterable of [BoundingBox] instances to be merged.
  ///
  /// Returns:
  ///   A new [BoundingBox] instance that is the union of all bounding boxes in the iterable.
  factory BoundingBox.merge(Iterable<BoundingBox> boxes) => boxes.fold(
        const BoundingBox.flexible(),
        (combined, bounds) => combined.mergeWith(bounds),
      );

  /// Returns the fractional X position of a given X coordinate within the bounds of this [BoundingBox].
  /// Throws [UnboundedError] if X bounds are not set.
  double getFractionX(double x) {
    if (this case BoundingBox(:final minX?, :final maxX?)) {
      if (minX == maxX) {
        return 0;
      }

      return (x - minX) / (maxX - minX);
    }

    throw UnboundedError(
      message:
          'Getting X-axis fraction is not possible without specific X-axis bounds. Please ensure minX and maxX are set. Current bounds: minX=$minX, maxX=$maxX',
    );
  }

  /// Returns the fractional Y position of a given Y coordinate within the bounds of this [BoundingBox].
  /// Throws [UnboundedError] if Y bounds are not set.
  double getFractionY(double y) {
    if (this case BoundingBox(:final minY?, :final maxY?)) {
      if (minY == maxY) {
        return 0;
      }

      return 1 - (y - minY) / (maxY - minY);
    }

    throw UnboundedError(
      message:
          'Getting Y-axis fraction is not possible without specific X-axis bounds. Please ensure minX and maxX are set. Current bounds: minY=$minY, maxY=$maxY',
    );
  }

  /// Merges this [BoundingBox] with another [BoundingBox], resulting in a new [BoundingBox] that encompasses both.
  BoundingBox mergeWith(BoundingBox other) => BoundingBox(
        minX: _lowestValue(minX, other.minX),
        maxX: _highestValue(maxX, other.maxX),
        minY: _lowestValue(minY, other.minY),
        maxY: _highestValue(maxY, other.maxY),
      );

  /// Helper method to determine the lowest value between two doubles, considering nulls as flexible/unbounded.
  double? _lowestValue(double? a, double? b) {
    if (a != null && b != null) return min(a, b);
    if (a != null && b == null) return a;
    if (a == null && b != null) return b;
    return null;
  }

  /// Helper method to determine the highest value between two doubles, considering nulls as flexible/unbounded.
  double? _highestValue(double? a, double? b) {
    if (a != null && b != null) return max(a, b);
    if (a != null && b == null) return a;
    if (a == null && b != null) return b;
    return null;
  }

  @override
  List<Object?> get props => [minY, maxY, minX, maxX];
}
