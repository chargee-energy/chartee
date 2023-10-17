import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class _BarDistance with EquatableMixin {
  final int index;
  final double distance;

  const _BarDistance({required this.index, required this.distance});

  @override
  List<Object?> get props => [index, distance];
}

/// TODO: Docs
class BarChartGestureHandler extends StatefulWidget {
  final int numberOfBars;
  final Widget Function(BuildContext context, int selectedIndex) builder;
  final void Function(double centerX, int selectedIndex)? onChange;
  final VoidCallback? onReset;

  const BarChartGestureHandler({
    super.key,
    required this.numberOfBars,
    required this.builder,
    this.onChange,
    this.onReset,
  });

  @override
  State<BarChartGestureHandler> createState() => _BarChartGestureHandlerState();
}

class _BarChartGestureHandlerState extends State<BarChartGestureHandler> {
  int _selectedIndex = -1;

  double getBarCenterX({required int index, bool local = false}) {
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
        final barCenterX = getBarCenterX(index: index, local: true);
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
        onChange(getBarCenterX(index: index), index);
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
      onPanUpdate: (details) {
        final index = _findIndexForOffset(details.localPosition);
        if (index != -1) {
          _setSelectedIndex(index);
        }
      },
      onPanEnd: (_) => _resetSelectedIndex(),
      onPanCancel: () => _resetSelectedIndex(),
      child: widget.builder(context, _selectedIndex),
    );
  }
}
