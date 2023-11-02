import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class _BarDistance with EquatableMixin {
  final int index;
  final double distance;

  const _BarDistance({required this.index, required this.distance});

  @override
  List<Object?> get props => [index, distance];
}

/// A widget to handle the gestures within a bar chart.
///
/// See also:
///
/// * [BarChart] The chart that uses this handler to determine which item will be highlighted.
class BarChartGestureHandler extends StatefulWidget {
  /// The number of bars that the chart contains. Used to calculate which bar
  /// should capture the gesture.
  final int numberOfBars;

  /// Builder function to render the children of this widget. The builder
  /// supplies the currently selected bar index.
  final Widget Function(BuildContext context, int selectedIndex) builder;

  /// Side effect that will be called when the selected bar index changes.
  final void Function(double centerX, int selectedIndex)? onChange;

  /// Side effect that will be called when the gesture is ended.
  final VoidCallback? onReset;

  /// Initial index to highlight.
  final int? initialIndex;

  const BarChartGestureHandler({
    super.key,
    required this.numberOfBars,
    required this.builder,
    this.onChange,
    this.onReset,
    this.initialIndex,
  });

  @override
  State<BarChartGestureHandler> createState() => _BarChartGestureHandlerState();
}

class _BarChartGestureHandlerState extends State<BarChartGestureHandler> {
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

  double _getBarCenterX({required int index, bool local = false}) {
    final renderBox = context.findRenderObject() as RenderBox;
    final barWidth = renderBox.size.width / widget.numberOfBars;
    final localCenterX = barWidth * (index + 0.5);

    if (local) {
      return localCenterX;
    }

    return renderBox.localToGlobal(Offset(localCenterX, 0)).dx;
  }

  int _findIndexForOffset(Offset offset) {
    final nearestBar = List.generate(
      widget.numberOfBars,
      (index) => index,
    ).fold(
      const _BarDistance(index: -1, distance: double.infinity),
      (previousValue, index) {
        final barCenterX = _getBarCenterX(index: index, local: true);
        final distance = offset.dx - barCenterX;
        return distance.abs() < previousValue.distance
            ? _BarDistance(index: index, distance: distance.abs())
            : previousValue;
      },
    );

    return nearestBar.index;
  }

  void _setSelectedIndex(int index) {
    if (index != _selectedIndex) {
      final onChange = widget.onChange;
      if (onChange != null) {
        onChange(_getBarCenterX(index: index), index);
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
