import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'bar_stack.dart';
import 'bounding_box.dart';
import 'chart_item.dart';
import 'cursor_builder.dart';
import 'point.dart';
import 'grid_line.dart';
import 'selection_overlay_builder.dart';

/// Represents a layer in a chart.
///
/// This class serves as a base class for different types of chart layers.
/// Subclasses should override the `bounds` getter to define the bounding box of the layer.
sealed class ChartLayer with EquatableMixin {
  /// Returns the bounding box of the chart layer.
  BoundingBox get bounds;

  /// Creates a new instance of ChartLayer.
  const ChartLayer();

  @override
  List<Object?> get props => [];
}

/// Represents a layer in a chart that displays grid lines.
///
/// This class extends [ChartLayer] and provides properties for horizontal and vertical grid line builders.
class ChartGridLayer extends ChartLayer {
  /// The builder for horizontal grid lines.
  final GridLineBuilder? horizontalLineBuilder;

  /// The builder for vertical grid lines.
  final GridLineBuilder? verticalLineBuilder;

  @override
  BoundingBox get bounds => const BoundingBox.flexible();

  /// Creates a new instance of ChartGridLayer with both horizontal and vertical line builders.
  ///
  /// Either [horizontalLineBuilder] or [verticalLineBuilder] can be null based on the type of grid layer.
  const ChartGridLayer.all({
    required this.horizontalLineBuilder,
    required this.verticalLineBuilder,
  });

  /// Creates a new instance of ChartGridLayer with only horizontal grid lines.
  const ChartGridLayer.horizontal(this.horizontalLineBuilder)
      : verticalLineBuilder = null;

  /// Creates a new instance of ChartGridLayer with only vertical grid lines.
  const ChartGridLayer.vertical(this.verticalLineBuilder)
      : horizontalLineBuilder = null;

  @override
  List<Object?> get props => [
        ...super.props,
        horizontalLineBuilder,
        verticalLineBuilder,
      ];
}

/// Represents a layer in a chart that handles selection overlay.
///
/// This class extends [ChartLayer] and provides properties for the selection overlay builder, sticky behavior, translation, and initial items.
class ChartSelectionLayer extends ChartLayer {
  /// The builder for the selection overlay.
  final SelectionOverlayBuilder builder;

  /// A flag indicating if the selection is sticky.
  final bool sticky;

  /// The translation value for the selection.
  final double translation;

  /// The initial items selected in the chart.
  final List<ChartItem> initialItems;

  @override
  BoundingBox get bounds => const BoundingBox.flexible();

  /// Creates a new instance of ChartSelectionLayer.
  ///
  /// The [builder] is required, while [sticky], [translation], and [initialItems] have default values.
  const ChartSelectionLayer({
    required this.builder,
    this.sticky = false,
    this.translation = 0.0,
    this.initialItems = const [],
  });

  @override
  List<Object?> get props => [
        ...super.props,
        builder,
        sticky,
        translation,
        initialItems,
      ];
}

/// Represents a layer in a chart that contains a list of items of type `Item`.
///
/// This class extends [ChartLayer] and calculates the bounding box based on the bounds of each item in the `items` list.
///
/// The generic type `Item` should extend [ChartItem].
sealed class ChartItemLayer<Item extends ChartItem> extends ChartLayer {
  /// The list of items contained in this layer.
  final List<Item> items;

  @override
  BoundingBox get bounds => BoundingBox.merge(items.map((item) => item.bounds));

  /// Creates a new instance of ChartItemLayer with the provided list of items.
  const ChartItemLayer({required this.items});

  @override
  List<Object?> get props => [...super.props, items];
}

/// Represents a layer in a chart that contains a list of bar stacks.
///
/// This class extends [ChartItemLayer] and specializes in handling bar stacks.
class ChartBarLayer extends ChartItemLayer<BarStack> {
  /// Creates a new instance of ChartBarLayer with the provided list of bar stacks.
  ///
  /// The [items] parameter is required and represents the list of bar stacks to be displayed in the layer.
  const ChartBarLayer({required super.items});
}

/// Represents a layer in a chart that displays lines connecting points.
///
/// This class extends [ChartItemLayer] and specializes in handling lines.
class ChartLineLayer extends ChartItemLayer<Point> {
  /// The color of the line when the value is positive.
  final Color positiveColor;

  /// The color of the line when the value is negative.
  final Color negativeColor;

  /// The width of the line.
  final double lineWidth;

  /// The dash pattern for the line, if any.
  final List<double>? dashArray;

  /// Creates a new instance of ChartLineLayer with the specified parameters.
  ///
  /// The [items] parameter is required and represents the list of points to connect with lines.
  /// The [positiveColor] and [negativeColor] define the colors for positive and negative values respectively.
  /// The [lineWidth] specifies the width of the line (default is 1).
  /// The [dashArray] is an optional list of values defining the dash pattern for the line.
  const ChartLineLayer({
    required super.items,
    required this.positiveColor,
    required this.negativeColor,
    this.lineWidth = 1,
    this.dashArray,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        positiveColor,
        negativeColor,
        lineWidth,
        dashArray,
      ];
}

/// Represents a layer in a chart that displays an area between points.
///
/// This class extends [ChartItemLayer] and specializes in handling areas.
class ChartAreaLayer extends ChartItemLayer<Point> {
  /// The color of the area when the value is positive.
  final Color positiveColor;

  /// The color of the area when the value is negative.
  final Color negativeColor;

  /// Creates a new instance of ChartAreaLayer with the specified parameters.
  ///
  /// The [items] parameter is required and represents the list of points defining the area.
  /// The [positiveColor] and [negativeColor] define the colors for positive and negative areas respectively.
  const ChartAreaLayer({
    required super.items,
    required this.positiveColor,
    required this.negativeColor,
  });

  @override
  List<Object?> get props => [...super.props, positiveColor, negativeColor];
}

/// Represents a layer in a chart that displays a cursor at a specific point.
///
/// This class extends [ChartLayer] and provides properties for the cursor builder and the cursor's position.
class ChartCursorLayer extends ChartLayer {
  /// The builder for the cursor.
  final CursorBuilder builder;

  /// The position of the cursor.
  final Point point;

  @override
  BoundingBox get bounds => const BoundingBox.flexible();

  /// Creates a new instance of ChartCursorLayer with the specified cursor builder and position.
  ///
  /// The [builder] parameter is required and represents the builder for the cursor.
  /// The [point] parameter is required and defines the position of the cursor.
  const ChartCursorLayer({required this.builder, required this.point});

  @override
  List<Object?> get props => [...super.props, builder, point];
}
