import 'bounding_box.dart';
import 'chart_item.dart';

/// Represents a point on a chart.
///
/// Extends [ChartItem] to provide additional functionality for points.
class Point extends ChartItem {
  /// The y-coordinate of the point.
  final double y;

  @override
  BoundingBox get bounds => BoundingBox.point(x: x, y: y);

  /// Creates a new Point instance.
  ///
  /// The [x] parameter is inherited from [ChartItem].
  /// The [y] parameter is the y-coordinate of the point.
  const Point({required super.x, required this.y});

  @override
  List<Object?> get props => [...super.props, y];
}
