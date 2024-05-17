import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/selection_builder.dart';

class ChartSelection extends StatefulWidget {
  final EdgeInsets padding;
  final BoundingBox bounds;
  final List<ChartItem> items;
  final List<ChartItem> initialItems;
  final SelectionBuilder builder;
  final bool sticky;

  const ChartSelection({
    super.key,
    required this.padding,
    required this.bounds,
    required this.items,
    required this.initialItems,
    required this.builder,
    required this.sticky,
  });

  @override
  State<ChartSelection> createState() => _ChartSelectionState();
}

class _ChartSelectionState extends State<ChartSelection> {
  List<ChartItem> _items = [];

  @override
  void initState() {
    super.initState();
    if (widget.sticky) {
      _items = widget.initialItems;
    }
  }

  @override
  void didUpdateWidget(covariant ChartSelection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items.isNotEmpty) {
      _items = widget.items;
    } else if (!widget.sticky) {
      _items = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(
        top: widget.padding.top,
        bottom: widget.padding.bottom,
      ),
      child: CustomSingleChildLayout(
        delegate: _SelectionChildLayoutDelegate(
          padding: widget.padding,
          bounds: widget.bounds,
          items: _items,
        ),
        child: widget.builder(context, widget.items, 0),
      ),
    );
  }
}

class _SelectionChildLayoutDelegate extends SingleChildLayoutDelegate {
  final EdgeInsets padding;
  final BoundingBox bounds;
  final List<ChartItem> items;

  const _SelectionChildLayoutDelegate({
    required this.padding,
    required this.bounds,
    required this.items,
  });

  @override
  bool shouldRelayout(covariant _SelectionChildLayoutDelegate oldDelegate) =>
      padding != oldDelegate.padding ||
      bounds != oldDelegate.bounds ||
      items != oldDelegate.items;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(constraints.smallest);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final width = size.width - padding.horizontal;
    final center = bounds.getFractionX(items.first.x) * width;

    final left = (center - childSize.width / 2)
        .clamp(
          -padding.left,
          size.width - childSize.width - padding.left,
        )
        .toDouble();

    final selectionCenter = left + childSize.width / 2;
    final centerOffset = center - selectionCenter;

    return Offset(padding.left + left, 0);
  }
}
