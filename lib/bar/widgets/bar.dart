import 'package:flutter/material.dart';

import '../models/bar_chart_bar.dart';

class Bar extends StatelessWidget {
  final BarChartBar bar;
  final Alignment alignment;
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
      heightFactor: bar.y / maxValue,
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
