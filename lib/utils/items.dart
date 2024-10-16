import '../models/bounding_box.dart';

double? nearestXForOffset(
  BoundingBox bounds,
  Set<double> xValues,
  double offset,
  double width,
) {
  if (xValues.isEmpty) {
    return null;
  }

  final fraction = offset / width;
  double minDistance = double.infinity;
  double nearestX = xValues.first;

  for (final value in xValues) {
    final distance = (fraction - bounds.getFractionX(value)).abs();
    if (distance < minDistance) {
      minDistance = distance;
      nearestX = value;
    }
  }

  return nearestX;
}
