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

  /// Whether this stack should be highlighted.
  final bool highlight;

  const Bar({
    super.key,
    required this.bar,
    required this.alignment,
    required this.maxValue,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final heightFactor = bar.value / maxValue;

    if (heightFactor == 0) {
      return Container();
    }

    return FractionallySizedBox(
      heightFactor: bar.value / maxValue,
      child: SizedBox(
        width: bar.width,
        child: Container(
          decoration: BoxDecoration(
            color: highlight
                ? bar.highlightColor ??
                    HSLColor.fromColor(bar.color).withLightness(0.7).toColor()
                : bar.color,
            borderRadius: bar.borderRadius,
          ),
        ),
      ),
    );
  }
}
