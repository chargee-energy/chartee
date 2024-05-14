import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/cursor_builder.dart';
import '../models/point.dart';

class ChartCursor extends StatelessWidget {
  final BoundingBox bounds;
  final CursorBuilder builder;
  final Point point;

  const ChartCursor({
    super.key,
    required this.bounds,
    required this.builder,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    final x = bounds.getFractionX(point.x);
    final y = bounds.getFractionY(point.y);

    return Align(
      alignment: FractionalOffset(x, y),
      child: FractionalTranslation(
        translation: Offset(x - 0.5, y - 0.5),
        child: builder(context, point),
      ),
    );
  }
}
