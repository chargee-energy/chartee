import 'package:collection/collection.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';

List<ChartItem> nearestItemsForOffset(
  BoundingBox bounds,
  List<ChartItem> items,
  double offset,
  double width,
) {
  if (items.isEmpty) {
    return [];
  }

  final fraction = offset / width;
  final distances = items
      .map(
        (item) => (
          item: item,
          distance: (fraction - bounds.getFractionX(item.x)).abs(),
        ),
      )
      .sorted((a, b) => ((a.distance - b.distance) * 100).toInt());

  return distances
      .map((distance) => distance.item)
      .where((item) => item.x == distances.first.item.x)
      .toList();
}
