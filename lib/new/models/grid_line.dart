import 'dart:ui';

import 'package:equatable/equatable.dart';

class GridLine with EquatableMixin {
  final Color color;
  final double width;
  final List<int>? dashArray;

  const GridLine({required this.color, this.width = 1, this.dashArray});

  @override
  List<Object?> get props => [color, width, dashArray];
}

typedef GridLineBuilder = GridLine? Function(int index);
