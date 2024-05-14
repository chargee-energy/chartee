import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'bar_stack.dart';
import 'bounding_box.dart';
import 'chart_item.dart';
import 'cursor_builder.dart';
import 'point.dart';
import 'grid_line.dart';
import 'selection_builder.dart';

sealed class ChartLayer with EquatableMixin {
  BoundingBox get bounds;

  const ChartLayer();

  @override
  List<Object?> get props => [];
}

class ChartGridLayer extends ChartLayer {
  final GridLineBuilder? horizontalLineBuilder;
  final GridLineBuilder? verticalLineBuilder;

  @override
  BoundingBox get bounds => const BoundingBox.flexible();

  const ChartGridLayer.all({
    required this.horizontalLineBuilder,
    required this.verticalLineBuilder,
  });

  const ChartGridLayer.horizontal(this.horizontalLineBuilder)
      : verticalLineBuilder = null;

  const ChartGridLayer.vertical(this.verticalLineBuilder)
      : horizontalLineBuilder = null;

  @override
  List<Object?> get props => [
        ...super.props,
        horizontalLineBuilder,
        verticalLineBuilder,
      ];
}

class ChartSelectionLayer extends ChartLayer {
  final SelectionBuilder builder;
  final bool sticky;
  final List<ChartItem> initialItems;

  @override
  BoundingBox get bounds => const BoundingBox.flexible();

  const ChartSelectionLayer({
    required this.builder,
    this.sticky = false,
    this.initialItems = const [],
  });

  @override
  List<Object?> get props => [...super.props, builder, sticky, initialItems];
}

sealed class ChartItemLayer<Item extends ChartItem> extends ChartLayer {
  final List<Item> items;

  @override
  BoundingBox get bounds => BoundingBox.merge(items.map((item) => item.bounds));

  const ChartItemLayer({required this.items});

  @override
  List<Object?> get props => [...super.props, items];
}

class ChartBarLayer extends ChartItemLayer<BarStack> {
  const ChartBarLayer({required super.items});
}

class ChartLineLayer extends ChartItemLayer<Point> {
  final Color positiveColor;
  final Color negativeColor;
  final double lineWidth;
  final List<double>? dashArray;

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

class ChartAreaLayer extends ChartItemLayer<Point> {
  final Color positiveColor;
  final Color negativeColor;

  const ChartAreaLayer({
    required super.items,
    required this.positiveColor,
    required this.negativeColor,
  });

  @override
  List<Object?> get props => [...super.props, positiveColor, negativeColor];
}

class ChartCursorLayer extends ChartLayer {
  final CursorBuilder builder;
  final Point point;

  @override
  BoundingBox get bounds => const BoundingBox.flexible();

  const ChartCursorLayer({required this.builder, required this.point});

  @override
  List<Object?> get props => [...super.props, builder, point];
}
