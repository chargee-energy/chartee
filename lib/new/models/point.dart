import 'bounding_box.dart';
import 'chart_item.dart';

class Point extends ChartItem {
  final double y;

  @override
  BoundingBox get bounds => BoundingBox.point(x: x, y: y);

  const Point({required super.x, required this.y});

  @override
  List<Object?> get props => [...super.props, y];
}
