import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../utils/items.dart';

class ChartGestureHandler extends StatefulWidget {
  final EdgeInsets padding;
  final BoundingBox bounds;
  final List<ChartItem> items;
  final bool Function(double? value)? allowSelection;
  final ValueChanged<double?>? onSelectionChanged;
  final Widget Function(BuildContext context, ValueNotifier<double?> selectedX)
      builder;

  const ChartGestureHandler({
    super.key,
    required this.padding,
    required this.bounds,
    required this.items,
    required this.allowSelection,
    required this.onSelectionChanged,
    required this.builder,
  });

  @override
  State<ChartGestureHandler> createState() => _ChartGestureHandlerState();
}

class _ChartGestureHandlerState extends State<ChartGestureHandler> {
  final ValueNotifier<double?> _selectedX = ValueNotifier(null);
  Set<double> _xValues = {};

  @override
  void initState() {
    super.initState();
    _xValues = widget.items.map((item) => item.x).toSet();
  }

  @override
  void didUpdateWidget(covariant ChartGestureHandler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _xValues = widget.items.map((item) => item.x).toSet();
    }
  }

  double? _findNearestX(Offset localPosition) {
    if (widget.items.isEmpty) {
      return null;
    }

    final renderBox = context.findRenderObject() as RenderBox;
    final width = renderBox.size.width - widget.padding.horizontal;
    final x = localPosition.dx - widget.padding.left;

    return nearestXForOffset(widget.bounds, _xValues, x, width);
  }

  void _setSelectedX(double? x) {
    if (x != _selectedX.value && (widget.allowSelection?.call(x) ?? true)) {
      widget.onSelectionChanged?.call(x);
      _selectedX.value = x;
    }
  }

  void _resetSelectedItems() {
    if (_selectedX.value != null) {
      widget.onSelectionChanged?.call(null);
      _selectedX.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        final x = _findNearestX(details.localPosition);
        _setSelectedX(x);
      },
      onTapUp: (_) => _resetSelectedItems(),
      onHorizontalDragUpdate: (details) {
        final x = _findNearestX(details.localPosition);
        _setSelectedX(x);
      },
      onHorizontalDragEnd: (_) => _resetSelectedItems(),
      onHorizontalDragCancel: () => _resetSelectedItems(),
      child: widget.builder(context, _selectedX),
    );
  }
}
