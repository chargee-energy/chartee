import 'package:flutter/material.dart';

import '../models/bar.dart';
import '../models/bar_stack.dart';
import '../models/chart_bounds.dart';

class ChartBars extends StatelessWidget {
  final ChartBounds bounds;
  final List<BarStack> barStacks;
  final List<BarStack> selectedBarStacks;

  const ChartBars({
    super.key,
    required this.bounds,
    required this.barStacks,
    required this.selectedBarStacks,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: barStacks
          .map(
            (barStack) => CustomPaint(
              painter: _BarStackPainter(
                bounds: bounds,
                barStack: barStack,
                children: barStack.bars
                    .map(
                      (bar) => _BarPainter(
                        bounds: barStack.bounds,
                        bar: bar,
                        highlight: selectedBarStacks.contains(barStack),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _BarStackPainter extends CustomPainter {
  final ChartBounds bounds;
  final BarStack barStack;
  final List<CustomPainter> children;

  const _BarStackPainter({
    required this.bounds,
    required this.barStack,
    required this.children,
  });

  @override
  bool shouldRepaint(covariant _BarStackPainter oldDelegate) =>
      bounds != oldDelegate.bounds ||
      barStack != oldDelegate.barStack ||
      children != oldDelegate.children;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = bounds.getFractionX(barStack.x) * size.width;
    final top = bounds.getFractionY(barStack.minY) * size.height;
    final bottom = bounds.getFractionY(barStack.maxY) * size.height;

    final clipRect = Rect.fromLTRB(
      centerX - barStack.width / 2,
      top,
      centerX + barStack.width / 2,
      bottom,
    );

    canvas.save();
    canvas.translate(clipRect.left, clipRect.top);
    canvas.clipRRect(
      RRect.fromRectAndCorners(
        Offset.zero & clipRect.size,
        topLeft: barStack.borderRadius.topLeft,
        topRight: barStack.borderRadius.topRight,
        bottomLeft: barStack.borderRadius.bottomLeft,
        bottomRight: barStack.borderRadius.bottomRight,
      ),
    );

    for (final child in children) {
      child.paint(canvas, clipRect.size);
    }

    canvas.restore();
  }
}

class _BarPainter extends CustomPainter {
  final ChartBounds bounds;
  final Bar bar;
  final bool highlight;

  late final _paint = Paint()
    ..color = highlight
        ? bar.highlightColor ??
            HSLColor.fromColor(bar.color).withLightness(0.7).toColor()
        : bar.color;

  _BarPainter({
    required this.bounds,
    required this.bar,
    required this.highlight,
  });

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) =>
      bounds != oldDelegate.bounds ||
      bar != oldDelegate.bar ||
      highlight != oldDelegate.highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final top = bounds.getFractionY(bar.minValue) * size.height;
    final bottom = bounds.getFractionY(bar.maxValue) * size.height;
    final width = bar.width ?? size.width;
    final left = (size.width - width) / 2;

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        left,
        top,
        left + width,
        bottom,
        topLeft: bar.borderRadius.topLeft,
        topRight: bar.borderRadius.topRight,
        bottomLeft: bar.borderRadius.bottomLeft,
        bottomRight: bar.borderRadius.bottomRight,
      ),
      _paint,
    );
  }
}
