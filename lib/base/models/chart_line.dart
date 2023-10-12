import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChartLine with EquatableMixin {
  final Color color;
  final double strokeWidth;
  final List<int>? dashArray;

  const ChartLine({
    this.color = Colors.grey,
    this.strokeWidth = 1,
    this.dashArray,
  });

  @override
  List<Object?> get props => [color, strokeWidth, dashArray];
}
