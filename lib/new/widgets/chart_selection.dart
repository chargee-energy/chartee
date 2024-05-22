import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/selection_overlay.dart';
import '../models/selection_overlay_builder.dart';
import '../models/selection_overlay_item.dart';

class ChartSelection extends StatefulWidget {
  final EdgeInsets padding;
  final BoundingBox bounds;
  final List<ChartItem> items;
  final List<ChartItem> initialItems;
  final SelectionOverlayBuilder builder;
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

    final overlay = widget.builder(_items);
    final fraction = widget.bounds.getFractionX(_items.first.x);

    return Padding(
      padding: EdgeInsets.only(
        top: widget.padding.top,
        bottom: widget.padding.bottom,
      ),
      child: switch (overlay) {
        SingleChildSelectionOverlay(:final child) => CustomSingleChildLayout(
            delegate: _SingleChildLayoutDelegate(
              padding: widget.padding,
              fraction: fraction,
              containWithinParent: child.containWithinParent,
            ),
            child: child.widget,
          ),
        ColumnSelectionOverlay(:final children) => CustomMultiChildLayout(
            delegate: _ColumnLayoutDelegate(
              padding: widget.padding,
              fraction: fraction,
              children: children,
            ),
            children: children
                .mapIndexed(
                  (index, child) => LayoutId(
                    id: index,
                    child: child.widget,
                  ),
                )
                .toList(),
          ),
      },
    );
  }
}

class _SingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  final EdgeInsets padding;
  final double fraction;
  final bool containWithinParent;

  const _SingleChildLayoutDelegate({
    required this.padding,
    required this.fraction,
    required this.containWithinParent,
  });

  @override
  bool shouldRelayout(covariant _SingleChildLayoutDelegate oldDelegate) =>
      padding != oldDelegate.padding ||
      fraction != oldDelegate.fraction ||
      containWithinParent != oldDelegate.containWithinParent;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(constraints.smallest);

  @override
  Offset getPositionForChild(Size size, Size childSize) =>
      _getOffset(size, childSize, fraction, containWithinParent, padding);
}

class _ColumnLayoutDelegate extends MultiChildLayoutDelegate {
  final EdgeInsets padding;
  final double fraction;
  final List<SelectionOverlayItem> children;

  _ColumnLayoutDelegate({
    required this.padding,
    required this.fraction,
    required this.children,
  });

  @override
  bool shouldRelayout(covariant _ColumnLayoutDelegate oldDelegate) =>
      padding != oldDelegate.padding ||
      fraction != oldDelegate.fraction ||
      !listEquals(children, oldDelegate.children);

  @override
  void performLayout(Size size) {
    var offsetTop = 0.0;

    for (var index = 0; index < children.length; index++) {
      final childSize = layoutChild(index, BoxConstraints.loose(size));
      final containWithinParent = children[index].containWithinParent;

      positionChild(
        index,
        _getOffset(size, childSize, fraction, containWithinParent, padding) +
            Offset(0, offsetTop),
      );

      offsetTop += childSize.height;
    }
  }
}

Offset _getOffset(
  Size size,
  Size childSize,
  double fraction,
  bool containWithinParent,
  EdgeInsets padding,
) {
  final width = size.width - padding.horizontal;
  final center = fraction * width;

  var left = (center - childSize.width / 2);

  if (containWithinParent) {
    left = left
        .clamp(
          -padding.left,
          size.width - childSize.width - padding.left,
        )
        .toDouble();
  }

  return Offset(padding.left + left, 0);
}
