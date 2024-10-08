import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/selection_overlay.dart';
import '../models/selection_overlay_builder.dart';
import '../models/selection_overlay_item.dart';

class ChartSelection extends StatefulWidget {
  final EdgeInsets padding;
  final BoundingBox bounds;
  final double? selectedX;
  final double? initialSelectedX;
  final SelectionOverlayBuilder builder;
  final bool isSticky;
  final double translation;
  final bool isStatic;

  const ChartSelection({
    super.key,
    required this.padding,
    required this.bounds,
    required this.selectedX,
    required this.initialSelectedX,
    required this.builder,
    required this.isSticky,
    required this.translation,
    required this.isStatic,
  });

  @override
  State<ChartSelection> createState() => _ChartSelectionState();
}

class _ChartSelectionState extends State<ChartSelection> {
  double? _selectedX;

  @override
  void initState() {
    super.initState();
    if (widget.isSticky) {
      _selectedX = widget.initialSelectedX;
    } else {
      _selectedX = widget.selectedX;
    }
  }

  @override
  void didUpdateWidget(covariant ChartSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedX != null) {
      _selectedX = widget.selectedX;
    } else if (!widget.isSticky) {
      _selectedX = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedX case final x?) {
      final overlay = widget.builder(x);
      final fraction = widget.bounds.getFractionX(x);

      return RepaintBoundary(
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.padding.top,
            bottom: widget.padding.bottom,
          ),
          child: switch (overlay) {
            SingleChildSelectionOverlay(:final child) =>
              CustomSingleChildLayout(
                delegate: _SingleChildLayoutDelegate(
                  padding: widget.padding,
                  fraction: fraction,
                  translation: widget.translation,
                  containWithinParent: child.containWithinParent,
                  fullWidth: child.fullWidth,
                  isStatic: widget.isStatic,
                ),
                child: child.widget,
              ),
            ColumnSelectionOverlay(:final children) => CustomMultiChildLayout(
                delegate: _ColumnLayoutDelegate(
                  padding: widget.padding,
                  fraction: fraction,
                  translation: widget.translation,
                  isStatic: widget.isStatic,
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
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _SingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  final EdgeInsets padding;
  final double fraction;
  final double translation;
  final bool containWithinParent;
  final bool fullWidth;
  final bool isStatic;

  const _SingleChildLayoutDelegate({
    required this.padding,
    required this.fraction,
    required this.translation,
    required this.containWithinParent,
    required this.fullWidth,
    required this.isStatic,
  });

  @override
  bool shouldRelayout(covariant _SingleChildLayoutDelegate oldDelegate) =>
      padding != oldDelegate.padding ||
      fraction != oldDelegate.fraction ||
      translation != oldDelegate.translation ||
      containWithinParent != oldDelegate.containWithinParent;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      _getConstraints(constraints.smallest, fullWidth);

  @override
  Offset getPositionForChild(Size size, Size childSize) =>
      _getOffset(
        size,
        childSize,
        fraction,
        containWithinParent,
        fullWidth,
        padding,
        isStatic,
      ) +
      Offset(0, childSize.height * translation);
}

class _ColumnLayoutDelegate extends MultiChildLayoutDelegate {
  final EdgeInsets padding;
  final double fraction;
  final double translation;
  final bool isStatic;
  final List<SelectionOverlayItem> children;

  _ColumnLayoutDelegate({
    required this.padding,
    required this.fraction,
    required this.translation,
    required this.isStatic,
    required this.children,
  });

  @override
  bool shouldRelayout(covariant _ColumnLayoutDelegate oldDelegate) =>
      padding != oldDelegate.padding ||
      fraction != oldDelegate.fraction ||
      translation != oldDelegate.translation ||
      !listEquals(children, oldDelegate.children);

  @override
  void performLayout(Size size) {
    final offsets = <Offset>[];
    var top = 0.0;

    for (var index = 0; index < children.length; index++) {
      final fullWidth = children[index].fullWidth;
      final containWithinParent = children[index].containWithinParent;
      final childSize = layoutChild(index, _getConstraints(size, fullWidth));
      offsets.add(
        _getOffset(
              size,
              childSize,
              fraction,
              containWithinParent,
              fullWidth,
              padding,
              isStatic,
            ) +
            Offset(0, top),
      );
      top += childSize.height;
    }

    for (var index = 0; index < offsets.length; index++) {
      positionChild(index, offsets[index] + Offset(0, top * translation));
    }
  }
}

BoxConstraints _getConstraints(Size size, bool fullWidth) => fullWidth
    ? BoxConstraints(
        minWidth: size.width,
        maxWidth: size.width,
        minHeight: 0,
        maxHeight: size.height,
      )
    : BoxConstraints.loose(size);

Offset _getOffset(
  Size size,
  Size childSize,
  double fraction,
  bool containWithinParent,
  bool fullWidth,
  EdgeInsets padding,
  bool isStatic,
) {
  if (fullWidth || isStatic) {
    return Offset.zero;
  }

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
