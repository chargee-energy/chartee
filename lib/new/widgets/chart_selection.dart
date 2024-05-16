import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/selection_builder.dart';

class ChartSelection extends StatefulWidget {
  final EdgeInsets padding;
  final BoundingBox bounds;
  final List<ChartItem> items;
  final SelectionBuilder builder;
  final bool sticky;
  final List<ChartItem> initialItems;

  const ChartSelection({
    super.key,
    required this.padding,
    required this.bounds,
    required this.items,
    required this.builder,
    required this.sticky,
    required this.initialItems,
  });

  @override
  State<ChartSelection> createState() => _ChartSelectionState();
}

class _ChartSelectionState extends State<ChartSelection> {
  final _key = GlobalKey();
  List<ChartItem> _items = [];

  bool _offstage = true;
  double _offsetLeft = 0;
  double _arrowOffset = 0;

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

    if (_items.isEmpty) {
      setState(() {
        _offstage = true;
      });
    } else if (!listEquals(_items, oldWidget.items)) {
      _updatePosition();
    }
  }

  void _updatePosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parentBox = context.findRenderObject()?.parent as RenderBox;
      final selectionBox = _key.currentContext?.findRenderObject() as RenderBox;

      final width = parentBox.size.width - widget.padding.horizontal;
      final centerX = widget.bounds.getFractionX(_items.first.x) * width;

      final left = (centerX - selectionBox.size.width / 2)
          .clamp(
            -widget.padding.left,
            parentBox.size.width - selectionBox.size.width,
          )
          .toDouble();

      final selectionCenterX = left + selectionBox.size.width / 2;
      final arrowOffsetX = centerX - selectionCenterX;

      setState(() {
        _offstage = false;
        _offsetLeft = left;
        _arrowOffset = arrowOffsetX;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isNotEmpty) {
      return Positioned(
        top: widget.padding.top,
        bottom: widget.padding.bottom,
        left: widget.padding.left + _offsetLeft,
        child: Offstage(
          offstage: _offstage,
          child: Container(
            key: _key,
            child: widget.builder(context, widget.items, _arrowOffset),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
