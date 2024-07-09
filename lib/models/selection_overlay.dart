import 'package:equatable/equatable.dart';

import 'selection_overlay_item.dart';

/// Represents an overlay for selecting items.
///
/// This class serves as a base class for different types of selection overlays.
/// Subclasses should override the [props] method to provide a list of properties
/// used for equality comparison.
///
/// See also:
///   - [SingleChildSelectionOverlay]
///   - [ColumnSelectionOverlay]
sealed class SelectionOverlay with EquatableMixin {
  /// Creates a [SelectionOverlay].
  const SelectionOverlay();

  @override
  List<Object?> get props => [];
}

/// Represents an overlay for selecting a single child item.
///
/// This class extends [SelectionOverlay] and provides functionality for a selection overlay
/// with a single child item.
///
/// To create an instance of [SingleChildSelectionOverlay], use the constructor
/// and pass the child item as a required parameter.
///
/// Example:
/// ```dart
/// SingleChildSelectionOverlay(child: myChildItem)
/// ```
class SingleChildSelectionOverlay extends SelectionOverlay {
  /// The child item for the selection overlay.
  final SelectionOverlayItem child;

  /// Creates a [SingleChildSelectionOverlay] with the specified [child].
  const SingleChildSelectionOverlay({required this.child});

  @override
  List<Object?> get props => [...super.props, child];
}

/// Represents an overlay for selecting multiple child items in a column layout.
///
/// This class extends [SelectionOverlay] and provides functionality for a selection overlay
/// with multiple child items arranged in a column.
///
/// To create an instance of [ColumnSelectionOverlay], use the constructor
/// and pass the list of child items as a required parameter.
///
/// Example:
/// ```dart
/// ColumnSelectionOverlay(children: [childItem1, childItem2])
/// ```
class ColumnSelectionOverlay extends SelectionOverlay {
  /// The list of child items for the selection overlay.
  final List<SelectionOverlayItem> children;

  /// Creates a [ColumnSelectionOverlay] with the specified [children].
  const ColumnSelectionOverlay({required this.children});

  @override
  List<Object?> get props => [...super.props, children];
}
