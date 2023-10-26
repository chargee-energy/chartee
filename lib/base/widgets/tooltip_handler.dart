import 'dart:math';

import 'package:flutter/material.dart';

import '../models/chart_tooltip.dart';

/// A widget to handle the positioning of a tooltip inside a chart.
class TooltipHandler extends StatelessWidget {
  /// The information that will be used to render the chart tooltip.
  final ChartTooltip tooltip;

  /// Builder function to render the children of this widget. The builder
  /// supplies functions to show and hide the tooltip.
  final Widget Function(
    BuildContext context,
    void Function(double centerX, int selectedIndex) showTooltip,
    VoidCallback hideTooltip,
  ) builder;

  const TooltipHandler({
    super.key,
    required this.tooltip,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (!tooltip.enabled) {
      return builder(context, (_, __) {}, () {});
    }

    if (tooltip.sticky) {
      return _StickyTooltipHandler(tooltip: tooltip, builder: builder);
    }

    return _DefaultTooltipHandler(tooltip: tooltip, builder: builder);
  }
}

/// TODO: Docs
class _DefaultTooltipHandler extends StatefulWidget {
  /// The information that will be used to render the chart tooltip.
  final ChartTooltip tooltip;

  /// Builder function to render the children of this widget. The builder
  /// supplies functions to show and hide the tooltip.
  final Widget Function(
    BuildContext context,
    void Function(double centerX, int selectedIndex) showTooltip,
    VoidCallback hideTooltip,
  ) builder;

  const _DefaultTooltipHandler({
    super.key,
    required this.tooltip,
    required this.builder,
  });

  @override
  State<_DefaultTooltipHandler> createState() => _DefaultTooltipHandlerState();
}

class _DefaultTooltipHandlerState extends State<_DefaultTooltipHandler> {
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
        (ownBox.size.width - widget.tooltip.padding.right) -
            tooltipBox.size.width,
        max(widget.tooltip.padding.left,
            localCenterX - tooltipBox.size.width / 2),
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
    final getTooltip = widget.tooltip.getTooltip;
    return Stack(
      children: [
        Positioned(
          top: widget.tooltip.padding.top,
          bottom: widget.tooltip.padding.bottom,
          left: _tooltipLeft,
          child: Offstage(
            offstage: _offstage,
            child: _selectedIndex != -1 && getTooltip != null
                ? getTooltip(
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

/// TODO: Docs
class _StickyTooltipHandler extends StatefulWidget {
  /// The information that will be used to render the chart tooltip.
  final ChartTooltip tooltip;

  /// Builder function to render the children of this widget. The builder
  /// supplies functions to show and hide the tooltip.
  final Widget Function(
    BuildContext context,
    void Function(double centerX, int selectedIndex) showTooltip,
    VoidCallback hideTooltip,
  ) builder;

  const _StickyTooltipHandler({
    super.key,
    required this.tooltip,
    required this.builder,
  });

  @override
  State<_StickyTooltipHandler> createState() => _StickyTooltipHandlerState();
}

class _StickyTooltipHandlerState extends State<_StickyTooltipHandler> {
  final _tooltipKey = GlobalKey();
  int _selectedIndex = 0;
  double _arrowOffsetX = 0;

  void _updateTooltip(double centerX, int selectedIndex) {
    setState(() {
      _selectedIndex = selectedIndex;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ownBox = context.findRenderObject() as RenderBox;
      final tooltipBox =
          _tooltipKey.currentContext?.findRenderObject() as RenderBox;
      final localCenterX = ownBox.globalToLocal(Offset(centerX, 0)).dx;

      final left = min(
        (ownBox.size.width - widget.tooltip.padding.right) -
            tooltipBox.size.width,
        max(widget.tooltip.padding.left,
            localCenterX - tooltipBox.size.width / 2),
      );

      final tooltipCenterX = left + tooltipBox.size.width / 2;
      final arrowOffsetX = localCenterX - tooltipCenterX;

      setState(() {
        _arrowOffsetX = arrowOffsetX;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final getTooltip = widget.tooltip.getTooltip;
    return Stack(
      children: [
        Padding(
          padding: widget.tooltip.padding,
          child: getTooltip != null
              ? getTooltip(
                  context,
                  _tooltipKey,
                  _selectedIndex,
                  _arrowOffsetX,
                )
              : Container(key: _tooltipKey),
        ),
        widget.builder(context, _updateTooltip, () {}),
      ],
    );
  }
}
