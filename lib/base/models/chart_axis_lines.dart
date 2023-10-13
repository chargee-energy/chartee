import 'package:equatable/equatable.dart';

import 'chart_line.dart';

/// A model to determine which lines should be rendered and what they will look
/// like for a specific axis.
class ChartAxisLines<Value extends num> with EquatableMixin {
  /// Whether the lines on this axis should be visible.
  final bool visible;

  /// Whether the line should extend behind the labels.
  final bool extendBehindLabels;

  /// A function to get the text that should be rendered in a label.
  final ChartLine Function(Value value)? getLine;

  const ChartAxisLines({
    this.visible = false,
    this.extendBehindLabels = false,
    this.getLine,
  });

  @override
  List<Object?> get props => [visible, extendBehindLabels, getLine];
}
