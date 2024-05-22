import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class SelectionOverlayItem with EquatableMixin {
  final Widget widget;
  final bool containWithinParent;

  const SelectionOverlayItem({
    required this.widget,
    this.containWithinParent = false,
  });

  @override
  List<Object?> get props => [containWithinParent, widget];
}
