import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A model to determine whether the tooltip should be rendered and what it will
/// look like.
class ChartTooltip with EquatableMixin {
  /// Whether the tooltip should be enabled.
  final bool enabled;

  /// Whether the tooltip should be sticky. If the tooltip is sticky it will
  /// be full width and always visible. If not the width will be defined by
  /// the tooltip and it will be only visible when an index is selected.
  final bool sticky;

  /// Padding to apply to the tooltip, this means the tooltip will keep this
  /// distance from the sides of it's parent.
  final EdgeInsets padding;

  /// Whether the tooltip should be shown for a specific index. If this function
  /// is not supplied it will show the tooltip for every index.
  final bool Function(int index)? shouldShow;

  /// Builder function for the tooltip. The builder supplies the selected
  /// index and an offset which can be applied to an arrow so this will stay
  /// centered above the selected item even when the tooltip position is bound
  /// by the size of it's parent.
  final Widget Function(
    BuildContext context,
    Key key,
    int selectedIndex,
    double arrowOffsetX,
  )? getTooltip;

  const ChartTooltip({
    this.enabled = false,
    this.sticky = false,
    this.padding = EdgeInsets.zero,
    this.shouldShow,
    this.getTooltip,
  });

  @override
  List<Object?> get props => [enabled, sticky, padding, shouldShow, getTooltip];

  ChartTooltip addPadding(EdgeInsets padding) => ChartTooltip(
        enabled: enabled,
        sticky: sticky,
        padding: this.padding + padding,
        shouldShow: shouldShow,
        getTooltip: getTooltip,
      );
}
