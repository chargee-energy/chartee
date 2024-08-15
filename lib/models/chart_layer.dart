import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'bar_stack.dart';
import 'bounding_box.dart';
import 'chart_item.dart';
import 'cursor_builder.dart';
import 'point.dart';
import 'grid_line.dart';
import 'selection_overlay_builder.dart';
import 'widget_builder.dart';

/// Represents a layer in a chart.
///
/// This class serves as a base class for different types of chart layers.
/// Subclasses should override the `bounds` getter to define the bounding box of the layer.
sealed class ChartLayer with EquatableMixin {
  /// Returns the bounding box of the chart layer.
  BoundingBox get bounds;

  /// Whether the layer should remain static in a scrollable chart
  bool get isStatic;

  /// Creates a new instance of ChartLayer.
  const ChartLayer();

  @override
  List<Object?> get props => [bounds, isStatic];
}

/// Helper class to create grid layers
abstract final class ChartGridLayer {
  /// Creates a list with new instances of ChartHorizontalGridLineLayer and ChartVerticalGridLineLayer.
  static List<ChartLayer> all({
    required GridLineBuilder horizontalLineBuilder,
    required GridLineBuilder verticalLineBuilder,
  }) =>
      [
        ChartHorizontalGridLineLayer(horizontalLineBuilder),
        ChartVerticalGridLineLayer(verticalLineBuilder),
      ];

  /// Creates a new instance of ChartHorizontalGridLineLayer.
  static ChartLayer horizontal(GridLineBuilder lineBuilder) =>
      ChartHorizontalGridLineLayer(lineBuilder);

  /// Creates a new instance of ChartVerticalGridLineLayer.
  static ChartLayer vertical(GridLineBuilder lineBuilder) =>
      ChartVerticalGridLineLayer(lineBuilder);
}

/// Represents a layer in a chart that displays horizontal grid lines.
///
/// This class extends [ChartLayer] and provides a property for horizontal grid line builder.
class ChartHorizontalGridLineLayer extends ChartLayer {
  /// The builder for grid lines.
  final GridLineBuilder lineBuilder;

  @override
  BoundingBox get bounds => const BoundingBox.flexible();

  @override
  bool get isStatic => true;

  /// Creates a new instance of ChartHorizontalGridLineLayer with the provided line builder
  const ChartHorizontalGridLineLayer(this.lineBuilder);

  @override
  List<Object?> get props => [...super.props, lineBuilder];
}

/// Represents a layer in a chart that displays vertical grid lines.
///
/// This class extends [ChartLayer] and provides a property for vertical grid line builder.
class ChartVerticalGridLineLayer extends ChartLayer {
  /// The builder for grid lines.
  final GridLineBuilder lineBuilder;

  @override
  BoundingBox get bounds => const BoundingBox.flexible();

  @override
  bool get isStatic => false;

  /// Creates a new instance of ChartVerticalGridLineLayer with the provided line builder
  const ChartVerticalGridLineLayer(this.lineBuilder);

  @override
  List<Object?> get props => [...super.props, lineBuilder];
}

/// Represents a layer in a chart that handles selection overlay.
///
/// This class extends [ChartLayer] and provides properties for the selection overlay builder, sticky behavior, translation, and initial items.
class ChartSelectionLayer extends ChartLayer {
  /// The builder for the selection overlay.
  final SelectionOverlayBuilder builder;

  /// A flag indicating if the selection is sticky.
  final bool isSticky;

  /// The translation value for the selection.
  final double translation;

  /// The initial x selected in the chart.
  final double? initialSelectedX;

  @override
  BoundingBox get bounds => const BoundingBox.flexible();

  @override
  final bool isStatic;

  /// Creates a new instance of ChartSelectionLayer.
  ///
  /// The [builder] is required, while [isSticky], [translation], and [initialSelectedX] have default values.
  const ChartSelectionLayer({
    required this.builder,
    this.isSticky = false,
    this.translation = 0.0,
    this.initialSelectedX,
    this.isStatic = false,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        builder,
        isSticky,
        translation,
        initialSelectedX,
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

  @override
  bool get isStatic => false;

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

  @override
  bool get isStatic => false;

  /// Creates a new instance of ChartCursorLayer with the specified cursor builder and position.
  ///
  /// The [builder] parameter is required and represents the builder for the cursor.
  /// The [point] parameter is required and defines the position of the cursor.
  const ChartCursorLayer({required this.builder, required this.point});

  @override
  List<Object?> get props => [...super.props, builder, point];
}

/// Represents a layer in a chart that displays a custom widget.
///
/// This class extends [ChartLayer] and provides properties for the widget builder.
class ChartCustomLayer extends ChartLayer {
  /// The builder for the custom widget.
  final WidgetBuilder builder;

  @override
  final BoundingBox bounds;

  @override
  final bool isStatic;

  /// Creates a new instance of ChartCustomLayer with the specified widget builder and bounds.
  ///
  /// The [builder] parameter is required and represents the builder for the widget.
  /// The [bounds] parameter is optional and defines the bounds of this layer.
  const ChartCustomLayer({
    required this.builder,
    this.bounds = const BoundingBox.flexible(),
    this.isStatic = false,
  });

  @override
  List<Object?> get props => [...super.props, builder];
}
