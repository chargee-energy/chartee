import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';

class ChartGestureHandler extends StatefulWidget {
  final EdgeInsets padding;
  final BoundingBox bounds;
  final List<ChartItem> items;
  final ValueChanged<List<ChartItem>>? onSelectionChanged;
  final Widget Function(BuildContext context, List<ChartItem> selectedItems)
      builder;

  const ChartGestureHandler({
    super.key,
    required this.padding,
    required this.bounds,
    required this.items,
    required this.onSelectionChanged,
    required this.builder,
  });

  @override
  State<ChartGestureHandler> createState() => _ChartGestureHandlerState();
}

class _ChartGestureHandlerState extends State<ChartGestureHandler> {
  List<ChartItem> _selectedItems = [];

  List<ChartItem> _findItemsForOffset(Offset localPosition) {
    if (widget.items.isEmpty) {
      return [];
    }

    final renderBox = context.findRenderObject() as RenderBox;
    final width = renderBox.size.width - widget.padding.horizontal;
    final x = localPosition.dx - widget.padding.left;
    final fractionX = x / width;

    final distances = widget.items
        .map(
          (item) => (
            item: item,
            distance: (fractionX - widget.bounds.getFractionX(item.x)).abs(),
          ),
        )
        .sorted((a, b) => ((a.distance - b.distance) * 100).toInt());

    return distances
        .map((distance) => distance.item)
        .where((item) => item.x == distances.first.item.x)
        .toSet()
        .toList();
  }

  void _setSelectedItems(List<ChartItem> items) {
    if (!listEquals(_selectedItems, items)) {
      widget.onSelectionChanged?.call(items);
      setState(() {
        _selectedItems = items;
      });
    }
  }

  void _resetSelectedItems() {
    if (_selectedItems.isNotEmpty) {
      widget.onSelectionChanged?.call([]);
      setState(() {
        _selectedItems = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        final items = _findItemsForOffset(details.localPosition);
        _setSelectedItems(items);
      },
      onTapUp: (_) => _resetSelectedItems(),
      onHorizontalDragUpdate: (details) {
        final items = _findItemsForOffset(details.localPosition);
        _setSelectedItems(items);
      },
      onHorizontalDragEnd: (_) => _resetSelectedItems(),
      onHorizontalDragCancel: () => _resetSelectedItems(),
      child: widget.builder(context, _selectedItems),
    );
  }
}
