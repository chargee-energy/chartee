import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BarChartBar with EquatableMixin {
  final double y;
  final Color color;
  final double? width;
  final BorderRadius borderRadius;

  const BarChartBar({
    required this.y,
    required this.color,
    this.width,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  List<Object?> get props => [y, width, color, borderRadius];
}
