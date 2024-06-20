import 'package:equatable/equatable.dart';

import 'selection_overlay_item.dart';

sealed class SelectionOverlay with EquatableMixin {
  const SelectionOverlay();

  @override
  List<Object?> get props => [];
}

class SingleChildSelectionOverlay extends SelectionOverlay {
  final SelectionOverlayItem child;

  const SingleChildSelectionOverlay({required this.child});

  @override
  List<Object?> get props => [...super.props, child];
}

class ColumnSelectionOverlay extends SelectionOverlay {
  final List<SelectionOverlayItem> children;

  const ColumnSelectionOverlay({required this.children});

  @override
  List<Object?> get props => [...super.props, children];
}
