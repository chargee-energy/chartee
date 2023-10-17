import 'dart:math';

import 'package:flutter/material.dart';

typedef Builder = Widget Function(
  BuildContext context,
  void Function(double centerX, int selectedIndex) showTooltip,
  VoidCallback hideTooltip,
);

typedef TooltipBuilder = Widget Function(
  BuildContext context,
  Key key,
  int selectedIndex,
  double arrowOffsetX,
);

/// TODO: Docs
class TooltipHandler extends StatefulWidget {
  final EdgeInsets padding;
  final Builder builder;
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
