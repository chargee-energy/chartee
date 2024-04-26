import 'package:collection/collection.dart';
import 'package:flutter/painting.dart';

import 'bar.dart';
import 'chart_bounds.dart';
import 'chart_item.dart';

class BarStack extends ChartItem {
  final List<Bar> bars;
  final double width;
  final BorderRadius borderRadius;

  double get minY {
    if (bars.isEmpty) {
      // TODO: Custom exception
      throw Error();
    }

    return bars.map((bar) => bar.minValue).min;
  }

  double get maxY {
    if (bars.isEmpty) {
      // TODO: Custom exception
      throw Error();
    }

    return bars.map((bar) => bar.maxValue).max;
  }

  @override
  ChartBounds get bounds {
    if (bars.isEmpty) {
      // TODO: Custom exception
      throw Error();
    }

    return ChartBounds(minY: minY, maxY: maxY, minX: x, maxX: x);
  }

  const BarStack({
    required super.x,
    required this.bars,
    this.width = 8,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  List<Object?> get props => [width, borderRadius, bars];
}
