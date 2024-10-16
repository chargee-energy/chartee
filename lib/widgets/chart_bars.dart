import 'package:flutter/material.dart';

import '../models/bar.dart';
import '../models/bar_stack.dart';
import '../models/bounding_box.dart';
import '../utils/items.dart';

class ChartBars extends StatelessWidget {
  final BoundingBox bounds;
  final List<BarStack> barStacks;
  final List<BarStack> selectedBarStacks;
  final ValueChanged<double>? onXPressed;

  const ChartBars({
    super.key,
    required this.bounds,
    required this.barStacks,
    required this.selectedBarStacks,
    this.onXPressed,
  });

  double? _findNearestBarStack(BuildContext context, Offset localPosition) {
    if (barStacks.isEmpty) {
      return null;
    }

    final renderBox = context.findRenderObject() as RenderBox;
    return nearestXForOffset(
      bounds,
      barStacks.map((item) => item.x).toSet(),
      localPosition.dx,
      renderBox.size.width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapUp: (details) {
        final x = _findNearestBarStack(context, details.localPosition);
        if (x != null) {
          onXPressed?.call(x);
        }
      },
      child: CustomPaint(
        painter: _BarStacksPainter(
          bounds: bounds,
          barStacks: barStacks,
          selectedBarStacks: selectedBarStacks,
        ),
      ),
    );
  }
}

class _BarStacksPainter extends CustomPainter {
  final BoundingBox bounds;
  final List<BarStack> barStacks;
  final List<BarStack> selectedBarStacks;

  const _BarStacksPainter({
    required this.bounds,
    required this.barStacks,
    required this.selectedBarStacks,
  });

  @override
  bool shouldRepaint(covariant _BarStacksPainter oldDelegate) =>
      bounds != oldDelegate.bounds ||
      barStacks != oldDelegate.barStacks ||
      selectedBarStacks != oldDelegate.selectedBarStacks;

  @override
  void paint(Canvas canvas, Size size) {
    for (final barStack in barStacks) {
      _paintBarStack(barStack, canvas, size);
    }
  }

  void _paintBarStack(BarStack barStack, Canvas canvas, Size size) {
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

    final children = barStack.bars
        .map(
          (bar) => _BarPainter(
            bounds: barStack.bounds,
            bar: bar,
            highlight: selectedBarStacks.contains(barStack),
          ),
        )
        .toList();

    for (final child in children) {
      child.paint(canvas, clipRect.size);
    }

    canvas.restore();
  }
}

class _BarPainter extends CustomPainter {
  final BoundingBox bounds;
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
    final top = (1 - bounds.getFractionY(bar.minValue)) * size.height;
    final bottom = (1 - bounds.getFractionY(bar.maxValue)) * size.height;
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
