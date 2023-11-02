import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../base/utils/text.dart';
import '../../base/widgets/chart_base.dart';
import '../../base/widgets/tooltip_handler.dart';
import '../models/line_chart_data.dart';
import '../models/line_chart_item.dart';

/// A widget to render a line chart. Uses [ChartBase] to render the basic
/// elements of the chart and renders the line on top of that.
class LineChart extends StatelessWidget {
  /// The data that will be rendered in the chart.
  final LineChartData data;

  const LineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final horizontalLabelsSize =
        calculateTextSize('0', data.labels.horizontal.style);
    return TooltipHandler(
      tooltip: data.tooltip.addPadding(
        EdgeInsets.only(
          bottom: horizontalLabelsSize.height +
              data.labels.horizontal.padding.vertical,
        ),
      ),
      builder: (context, showTooltip, hideTooltip) => ChartBase(
        data: data,
        xAxisAlignment: XAxisAlignment.spaceBetween,
        builder: (context, lines) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CustomPaint(
                painter: _LineChartPainter(data: data, lines: lines),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  /// The data that will be rendered in the chart.
  final LineChartData data;

  /// The vertical lines of the chart.
  final List<double> lines;

  late final _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = data.lineWidth;

  final _areaPaint = Paint()..style = PaintingStyle.fill;

  _LineChartPainter({required this.data, required this.lines});

  @override
  bool shouldRepaint(covariant _LineChartPainter oldPainter) {
    return oldPainter.data != data || oldPainter.lines != lines;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.items.isEmpty || data.items.none((item) => item.y != 0)) {
      return;
    }

    final minY = lines.min.abs();
    final maxY = lines.max;
    final centerFraction = maxY / (minY + maxY);

    final topHeight = centerFraction * size.height - 1;
    final firstItem = data.items.first;
    final firstY =
        _getPointYFraction(firstItem, maxY, minY, centerFraction) * size.height;

    final linePath = Path()..moveTo(firstItem.xPercentage * size.width, firstY);
    final areaPath = Path()
      ..moveTo(data.items.first.xPercentage * size.width, topHeight)
      ..lineTo(data.items.first.xPercentage * size.width, firstY);

    for (var index = 1; index < data.items.length; index++) {
      final item = data.items[index];
      final y =
          _getPointYFraction(item, maxY, minY, centerFraction) * size.height;
      linePath.lineTo(item.xPercentage * size.width, y);
      areaPath.lineTo(item.xPercentage * size.width, y);
    }

    areaPath.lineTo(data.items.last.xPercentage * size.width, topHeight);

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, topHeight));
    canvas.drawPath(linePath, _linePaint..color = data.colorPositiveLine);
    canvas.drawPath(areaPath, _areaPaint..color = data.colorPositiveArea);
    canvas.restore();

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, topHeight, size.width, size.height));
    canvas.drawPath(linePath, _linePaint..color = data.colorNegativeLine);
    canvas.drawPath(areaPath, _areaPaint..color = data.colorNegativeArea);
    canvas.restore();
  }

  double _getPointYFraction(
    LineChartItem item,
    double maxY,
    double minY,
    double centerFraction,
  ) {
    if (item.y > 0) {
      return (maxY - item.y) / (maxY + minY);
    } else if (item.y < 0) {
      return (maxY - item.y) / (maxY + minY);
    }

    return centerFraction;
  }
}
