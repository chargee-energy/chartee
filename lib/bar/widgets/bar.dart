import 'package:flutter/material.dart';

import '../models/bar_chart_bar.dart';

/// A widget that renders a bar based on the information provided by
/// a [BarChartBar].
class Bar extends StatelessWidget {
  /// The rendering information for this bar.
  final BarChartBar bar;

  /// The alignment of the bar, should be [Alignment.bottomCenter] for positive
  /// bars and [Alignment.topCenter] for negative bars.
  final Alignment alignment;

  /// The max value used for scaling the bar.
  final double maxValue;

  const Bar({
    super.key,
    required this.bar,
    required this.alignment,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: bar.value / maxValue,
      child: SizedBox(
        width: bar.width,
        child: Container(
          decoration: BoxDecoration(
            color: bar.color,
            borderRadius: bar.borderRadius,
          ),
        ),
      ),
    );
  }
}
