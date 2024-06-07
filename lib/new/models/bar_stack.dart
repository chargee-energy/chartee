import 'package:collection/collection.dart';
import 'package:flutter/painting.dart';

import '../errors/empty_error.dart';
import 'bar.dart';
import 'bounding_box.dart';
import 'chart_item.dart';

class BarStack extends ChartItem {
  final List<Bar> bars;
  final double width;
  final BorderRadius borderRadius;

  double get minY {
    _checkIfEmpty();
    return bars.map((bar) => bar.minValue).min;
  }

  double get maxY {
    _checkIfEmpty();
    return bars.map((bar) => bar.maxValue).max;
  }

  @override
  BoundingBox get bounds {
    _checkIfEmpty();
    return BoundingBox(minX: x, maxX: x, minY: minY, maxY: maxY);
  }

  const BarStack({
    required super.x,
    required this.bars,
    this.width = 8,
    this.borderRadius = BorderRadius.zero,
  });

  void _checkIfEmpty() {
    if (bars.isEmpty) {
      throw EmptyError(
        message:
            "BarStack instance is empty. It requires at least one 'Bar' object to calculate bounds and values.",
      );
    }
  }

  @override
  List<Object?> get props => [...super.props, bars, width, borderRadius];
}
