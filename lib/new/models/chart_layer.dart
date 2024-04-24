import 'package:equatable/equatable.dart';

import 'chart_bounds.dart';
import 'chart_item.dart';
import 'chart_point.dart';
import 'grid_line.dart';

sealed class ChartLayer with EquatableMixin {
  final bool extendBehindLeadingLabels;
  final bool extendBehindTrailingLabels;
  final bool extendBehindTopLabels;
  final bool extendBehindBottomLabels;

  ChartBounds get bounds;

  const ChartLayer({
    this.extendBehindLeadingLabels = false,
    this.extendBehindTrailingLabels = false,
    this.extendBehindTopLabels = false,
    this.extendBehindBottomLabels = false,
  });

  @override
  List<Object?> get props => [
        extendBehindLeadingLabels,
        extendBehindTrailingLabels,
        extendBehindTopLabels,
        extendBehindBottomLabels,
      ];
}

class ChartGridLayer extends ChartLayer {
  final GridLineBuilder? horizontalLineBuilder;
  final GridLineBuilder? verticalLineBuilder;

  @override
  ChartBounds get bounds => const ChartBounds.flexible();

  const ChartGridLayer.all({
    required this.horizontalLineBuilder,
    required this.verticalLineBuilder,
    super.extendBehindLeadingLabels,
    super.extendBehindTrailingLabels,
    super.extendBehindTopLabels,
    super.extendBehindBottomLabels,
  });

  const ChartGridLayer.horizontal(
    this.horizontalLineBuilder, {
    super.extendBehindLeadingLabels,
    super.extendBehindTrailingLabels,
    super.extendBehindTopLabels,
    super.extendBehindBottomLabels,
  }) : verticalLineBuilder = null;

  const ChartGridLayer.vertical(
    this.verticalLineBuilder, {
    super.extendBehindLeadingLabels,
    super.extendBehindTrailingLabels,
    super.extendBehindTopLabels,
    super.extendBehindBottomLabels,
  }) : horizontalLineBuilder = null;

  @override
  List<Object?> get props => [
        ...super.props,
        horizontalLineBuilder,
        verticalLineBuilder,
      ];
}

sealed class ChartItemLayer<Item extends ChartItem> extends ChartLayer {
  final List<Item> items;

  @override
  ChartBounds get bounds => ChartBounds.merge(items.map((item) => item.bounds));

  const ChartItemLayer({
    required this.items,
    super.extendBehindLeadingLabels,
    super.extendBehindTrailingLabels,
    super.extendBehindTopLabels,
    super.extendBehindBottomLabels,
  });

  @override
  List<Object?> get props => [...super.props, items];
}

class ChartBarLayer extends ChartItemLayer<ChartItem> {
  const ChartBarLayer({
    required super.items,
    super.extendBehindLeadingLabels,
    super.extendBehindTrailingLabels,
    super.extendBehindTopLabels,
    super.extendBehindBottomLabels,
  });
}

class ChartLineLayer extends ChartItemLayer<ChartPoint> {
  const ChartLineLayer({
    required super.items,
    super.extendBehindLeadingLabels,
    super.extendBehindTrailingLabels,
    super.extendBehindTopLabels,
    super.extendBehindBottomLabels,
  });
}
