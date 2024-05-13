import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/selection_builder.dart';

class ChartSelection extends StatefulWidget {
  final BoundingBox bounds;
  final List<ChartItem> items;
  final SelectionBuilder builder;
  final bool sticky;
  final List<ChartItem> initialItems;

  const ChartSelection({
    super.key,
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
      final ownBox = context.findRenderObject()?.parent as RenderBox;
      final tooltipBox = _key.currentContext?.findRenderObject() as RenderBox;

      final centerX =
          widget.bounds.getFractionX(_items.first.x) * ownBox.size.width;

      final left = (centerX - tooltipBox.size.width / 2)
          .clamp(0, ownBox.size.width - tooltipBox.size.width)
          .toDouble();

      final tooltipCenterX = left + tooltipBox.size.width / 2;
      final arrowOffsetX = centerX - tooltipCenterX;

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
        top: 0,
        bottom: 0,
        left: _offsetLeft,
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
