import 'dart:ui';

import 'package:equatable/equatable.dart';

class GridLine with EquatableMixin {
  final Color color;
  final double width;
  final List<double>? dashArray;
  final bool extendBehindLabels;

  const GridLine({
    required this.color,
    this.width = 1,
    this.dashArray,
    this.extendBehindLabels = false,
  });

  @override
  List<Object?> get props => [color, width, dashArray, extendBehindLabels];
}

typedef GridLineBuilder = GridLine? Function(int index, double value);
