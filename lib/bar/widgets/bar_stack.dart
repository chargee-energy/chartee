import 'package:flutter/material.dart';

import '../models/bar_chart_bar_stack.dart';
import 'bar.dart';

/// A widget that renders a stack of bars based on the information provided by
/// a [BarChartBarStack].
class BarStack extends StatelessWidget {
  /// The rendering information for this stack.
  final BarChartBarStack stack;

  /// The alignment of the bars in the stack, should be [Alignment.bottomCenter]
  /// for positive bars and [Alignment.topCenter] for negative bars.
  final Alignment alignment;

  /// The max value used for scaling the bars.
  final double maxValue;

  const BarStack({
    super.key,
    required this.stack,
    required this.alignment,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        heightFactor: stack.maxY / maxValue,
        child: SizedBox(
          width: stack.width,
          child: ClipRRect(
            borderRadius: stack.borderRadius,
            child: Stack(
              alignment: alignment,
              children: stack.bars
                  .map(
                    (bar) => Bar(
                      bar: bar,
                      alignment: alignment,
                      maxValue: stack.maxY,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
