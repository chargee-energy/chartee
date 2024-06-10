import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class SelectionOverlayItem with EquatableMixin {
  final Widget widget;
  final bool containWithinParent;
  final bool fullWidth;

  const SelectionOverlayItem({
    required this.widget,
    this.containWithinParent = false,
    this.fullWidth = false,
  });

  @override
  List<Object?> get props => [widget, containWithinParent, fullWidth];
}
