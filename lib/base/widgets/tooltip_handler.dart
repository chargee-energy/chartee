import 'dart:math';

import 'package:flutter/material.dart';

typedef TooltipBuilder = Widget Function(
  BuildContext context,
  Key key,
  int selectedIndex,
  double arrowOffsetX,
);

/// A widget to handle the positioning of a tooltip inside a chart.
class TooltipHandler extends StatefulWidget {
  /// Padding to apply to the tooltip, this means the tooltip will keep this
  /// distance from the sides of it's parent.
  final EdgeInsets padding;

  /// Builder function to render the children of this widget. The builder
  /// supplies functions to show and hide the tooltip.
  final Widget Function(
    BuildContext context,
    void Function(double centerX, int selectedIndex) showTooltip,
    VoidCallback hideTooltip,
  ) builder;

  /// Builder function for the tooltip itself. The builder supplies the selected
  /// index and an offset which can be applied to an arrow so this will stay
  /// centered above the selected item even when the tooltip position is bound
  /// by the size of it's parent.
  final TooltipBuilder tooltipBuilder;

  const TooltipHandler({
    super.key,
    this.padding = EdgeInsets.zero,
    required this.builder,
    required this.tooltipBuilder,
  });

  @override
  State<TooltipHandler> createState() => _TooltipHandlerState();
}

class _TooltipHandlerState extends State<TooltipHandler> {
  final _tooltipKey = GlobalKey();
  int _selectedIndex = -1;
  bool _offstage = true;
  double _tooltipLeft = 0;
  double _arrowOffsetX = 0;

  void _showTooltip(double centerX, int selectedIndex) {
    setState(() {
      _selectedIndex = selectedIndex;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ownBox = context.findRenderObject() as RenderBox;
      final tooltipBox =
          _tooltipKey.currentContext?.findRenderObject() as RenderBox;
      final localCenterX = ownBox.globalToLocal(Offset(centerX, 0)).dx;

      final left = min(
        (ownBox.size.width - widget.padding.right) - tooltipBox.size.width,
        max(widget.padding.left, localCenterX - tooltipBox.size.width / 2),
      );

      final tooltipCenterX = left + tooltipBox.size.width / 2;
      final arrowOffsetX = localCenterX - tooltipCenterX;

      setState(() {
        _offstage = false;
        _tooltipLeft = left;
        _arrowOffsetX = arrowOffsetX;
      });
    });
  }

  void _hideTooltip() {
    setState(() {
      _selectedIndex = -1;
      _offstage = true;
      _tooltipLeft = 0;
      _arrowOffsetX = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: widget.padding.top,
          bottom: widget.padding.bottom,
          left: _tooltipLeft,
          child: Offstage(
            offstage: _offstage,
            child: _selectedIndex != -1
                ? widget.tooltipBuilder(
                    context,
                    _tooltipKey,
                    _selectedIndex,
                    _arrowOffsetX,
                  )
                : Container(key: _tooltipKey),
          ),
        ),
        widget.builder(context, _showTooltip, _hideTooltip),
      ],
    );
  }
}
