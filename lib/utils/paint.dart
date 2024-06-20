import 'dart:ui';

import '../models/bounding_box.dart';

void paintChartPath(
  Canvas canvas,
  Size size,
  BoundingBox bounds,
  Path path,
  Paint positivePaint,
  Paint negativePaint,
) {
  final zeroFraction = bounds.getFractionY(0);
  if (zeroFraction >= 1) {
    canvas.drawPath(path, positivePaint);
  } else if (zeroFraction <= 0) {
    canvas.drawPath(path, negativePaint);
  } else {
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(
        0,
        0,
        size.width,
        size.height * zeroFraction,
      ),
    );
    canvas.drawPath(path, positivePaint);
    canvas.restore();

    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(
        0,
        size.height * zeroFraction,
        size.width,
        size.height,
      ),
    );
    canvas.drawPath(path, negativePaint);
    canvas.restore();
  }
}
