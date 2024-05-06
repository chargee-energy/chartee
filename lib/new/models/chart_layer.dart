import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'bar_stack.dart';
import 'chart_bounds.dart';
import 'chart_item.dart';
import 'chart_point.dart';
import 'grid_line.dart';
import 'selection_builder.dart';

sealed class ChartLayer with EquatableMixin {
  ChartBounds get bounds;

  const ChartLayer();

  @override
  List<Object?> get props => [];
}

class ChartGridLayer extends ChartLayer {
  final GridLineBuilder? horizontalLineBuilder;
  final GridLineBuilder? verticalLineBuilder;

  @override
  ChartBounds get bounds => const ChartBounds.flexible();

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
  ChartBounds get bounds => const ChartBounds.flexible();

  const ChartSelectionLayer({
    required this.builder,
    this.sticky = false,
    this.initialItems = const [],
  });

  @override
  List<Object?> get props => [...super.props, builder];
}

sealed class ChartItemLayer<Item extends ChartItem> extends ChartLayer {
  final List<Item> items;

  @override
  ChartBounds get bounds => ChartBounds.merge(items.map((item) => item.bounds));

  const ChartItemLayer({required this.items});

  @override
  List<Object?> get props => [...super.props, items];
}

class ChartBarLayer extends ChartItemLayer<BarStack> {
  const ChartBarLayer({required super.items});
}

class ChartLineLayer extends ChartItemLayer<ChartPoint> {
  final Color positiveColor;
  final Color negativeColor;
  final double lineWidth;
  final List<num>? dashArray;

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
      ];
}

class ChartAreaLayer extends ChartItemLayer<ChartPoint> {
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
