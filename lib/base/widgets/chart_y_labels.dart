import 'package:flutter/material.dart';

typedef ChartYLabelFormatter = String Function(double lineValue);

class ChartYLabels extends StatelessWidget {
  final List<double> lines;
  final ChartYLabelFormatter labelFormatter;
  final TextStyle? textStyle;

  const ChartYLabels({
    super.key,
    required this.lines,
    required this.labelFormatter,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: lines.length > 1
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: lines.reversed
          .map(
            (line) => Text(
              labelFormatter(line),
              style: textStyle,
            ),
          )
          .toList(),
    );
  }
}
