import 'package:equatable/equatable.dart';

import 'bounding_box.dart';

abstract class ChartItem with EquatableMixin {
  final double x;

  BoundingBox get bounds;

  const ChartItem({required this.x});

  @override
  List<Object?> get props => [x];
}
