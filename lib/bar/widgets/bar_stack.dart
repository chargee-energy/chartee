import 'package:flutter/material.dart';

import '../models/bar_chart_bar_stack.dart';
import 'bar.dart';

class BarStack extends StatelessWidget {
  final BarChartBarStack? stack;
  final Alignment alignment;
  final double maxValue;

  const BarStack({
    super.key,
    required this.stack,
    required this.alignment,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final stack = this.stack;

    if (stack == null) {
      return Container();
    }

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
