import 'package:equatable/equatable.dart';

import 'chart_bounds.dart';

abstract class ChartItem with EquatableMixin {
  final double x;

  ChartBounds get bounds;

  const ChartItem({required this.x});

  @override
  List<Object?> get props => [x];
}
