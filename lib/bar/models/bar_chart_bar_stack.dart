import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'bar_chart_bar.dart';

class BarChartBarStack with EquatableMixin {
  final double width;
  final BorderRadius borderRadius;
  final List<BarChartBar> bars;

  double get maxY => bars.map((bar) => bar.y).maxOrNull ?? 0;

  const BarChartBarStack({
    this.width = 8,
    this.borderRadius = BorderRadius.zero,
    required this.bars,
  });

  @override
  List<Object?> get props => [width, borderRadius, bars];
}
