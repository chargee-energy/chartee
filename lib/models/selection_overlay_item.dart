import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Represents an item for a selection overlay.
///
/// This class is used to define an item that can be displayed in a selection overlay.
class SelectionOverlayItem with EquatableMixin {
  /// The widget to be displayed as the item.
  final Widget widget;

  /// Whether the item should be contained within its parent widget.
  final bool containWithinParent;

  /// Whether the item should take the full width available.
  final bool fullWidth;

  /// Creates a [SelectionOverlayItem] with the given [widget], [containWithinParent], and [fullWidth] values.
  const SelectionOverlayItem({
    required this.widget,
    this.containWithinParent = false,
    this.fullWidth = false,
  });

  @override
  List<Object?> get props => [widget, containWithinParent, fullWidth];
}
