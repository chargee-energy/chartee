import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base/utils/text.dart';
import '../../base/widgets/chart_base.dart';
import '../../base/widgets/tooltip_handler.dart';
import '../models/line_chart_data.dart';
import '../models/line_chart_item.dart';
import 'line_chart_gesture_handler.dart';

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
        builder: (context, lines) => LineChartGestureHandler(
          items: data.items,
          onChange: (centerX, selectedIndex) {
            if (data.tooltip.shouldShow?.call(selectedIndex) ?? true) {
              HapticFeedback.selectionClick();
              showTooltip(centerX, selectedIndex);
            } else {
              hideTooltip();
            }
          },
          onReset: hideTooltip,
          builder: (context, selectedIndex) {
            final minY = lines.min.abs();
            final maxY = lines.max;
            final centerFraction = maxY / (minY + maxY);

            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _LineChartPainter(
                      data: data,
                      minY: minY,
                      maxY: maxY,
                      centerFraction: centerFraction,
                    ),
                  ),
                ),
                _LineChartCursor(
                  data: data,
                  minY: minY,
                  maxY: maxY,
                  centerFraction: centerFraction,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  /// The data that will be rendered in the chart.
  final LineChartData data;

  /// The lowest y value.
  final double minY;

  /// The highest y value.
  final double maxY;

  /// The center fraction between the lowest and highest y values.
  final double centerFraction;

  late final _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = data.lineWidth;

  final _areaPaint = Paint()..style = PaintingStyle.fill;

  _LineChartPainter({
    required this.data,
    required this.minY,
    required this.maxY,
    required this.centerFraction,
  });

  @override
  bool shouldRepaint(covariant _LineChartPainter oldPainter) {
    return oldPainter.data != data ||
        oldPainter.minY != minY ||
        oldPainter.maxY != maxY ||
        oldPainter.centerFraction != centerFraction;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.items.isEmpty || data.items.none((item) => item.y != 0)) {
      return;
    }

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

class _LineChartCursor extends StatelessWidget {
  /// The data that will be rendered in the chart.
  final LineChartData data;

  /// The lowest y value.
  final double minY;

  /// The highest y value.
  final double maxY;

  /// The center fraction between the lowest and highest y values.
  final double centerFraction;

  const _LineChartCursor({
    required this.data,
    required this.minY,
    required this.maxY,
    required this.centerFraction,
  });

  @override
  Widget build(BuildContext context) {
    final cursorBuilder = data.cursor.getCursor;

    if (data.cursor.visible && cursorBuilder != null && data.items.isNotEmpty) {
      final cursorX = data.items.last.xPercentage;
      final cursorY =
          _getPointYFraction(data.items.last, maxY, minY, centerFraction);

      return AnimatedAlign(
        alignment: FractionalOffset(cursorX, cursorY),
        duration: data.cursor.animationDuration,
        child: FractionalTranslation(
          translation: Offset(0.5, cursorY - 0.5),
          child: cursorBuilder(data.items.last.y >= 0),
        ),
      );
    }

    return Container();
  }
}
