import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../models/line_chart_item.dart';

/// TODO: Refactor with bar handler

class _PointDistance with EquatableMixin {
  final int index;
  final double distance;

  const _PointDistance({required this.index, required this.distance});

  @override
  List<Object?> get props => [index, distance];
}

/// A widget to handle the gestures within a line chart.
///
/// See also:
///
/// * [LineChart] The chart that uses this handler to determine which item will be highlighted.
class LineChartGestureHandler extends StatefulWidget {
  /// TODO
  final List<LineChartItem> items;

  /// Builder function to render the children of this widget. The builder
  /// supplies the currently selected point index.
  final Widget Function(BuildContext context, int selectedIndex) builder;

  /// Side effect that will be called when the selected point index changes.
  final void Function(double centerX, int selectedIndex)? onChange;

  /// Side effect that will be called when the gesture is ended.
  final VoidCallback? onReset;

  /// Initial index to highlight.
  final int? initialIndex;

  const LineChartGestureHandler({
    super.key,
    required this.items,
    required this.builder,
    this.onChange,
    this.onReset,
    this.initialIndex,
  });

  @override
  State<LineChartGestureHandler> createState() =>
      _LineChartGestureHandlerState();
}

class _LineChartGestureHandlerState extends State<LineChartGestureHandler> {
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    final index = widget.initialIndex;
    if (index != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setSelectedIndex(index);
      });
    }
  }

  double _getPointX({required int index, bool local = false}) {
    final renderBox = context.findRenderObject() as RenderBox;
    final x = renderBox.size.width * widget.items[index].xPercentage;

    if (local) {
      return x;
    }

    return renderBox.localToGlobal(Offset(x, 0)).dx;
  }

  int _findIndexForOffset(Offset offset) {
    final nearestPoint = List.generate(
      widget.items.length,
      (index) => index,
    ).fold(
      const _PointDistance(index: -1, distance: double.infinity),
      (previousValue, index) {
        final pointX = _getPointX(index: index, local: true);
        final distance = offset.dx - pointX;
        return distance.abs() < previousValue.distance
            ? _PointDistance(index: index, distance: distance.abs())
            : previousValue;
      },
    );

    return nearestPoint.index;
  }

  void _setSelectedIndex(int index) {
    if (index != _selectedIndex) {
      final onChange = widget.onChange;
      if (onChange != null) {
        onChange(_getPointX(index: index), index);
      }
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _resetSelectedIndex() {
    widget.onReset?.call();
    setState(() {
      _selectedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) {
        final index = _findIndexForOffset(details.localPosition);
        if (index != -1) {
          _setSelectedIndex(index);
        }
      },
      onTapUp: (_) => _resetSelectedIndex(),
      onHorizontalDragUpdate: (details) {
        final index = _findIndexForOffset(details.localPosition);
        if (index != -1) {
          _setSelectedIndex(index);
        }
      },
      onHorizontalDragEnd: (_) => _resetSelectedIndex(),
      onHorizontalDragCancel: () => _resetSelectedIndex(),
      child: widget.builder(context, _selectedIndex),
    );
  }
}
