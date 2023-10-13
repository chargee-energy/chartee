import 'package:equatable/equatable.dart';

import 'chart_axis_labels.dart';

/// A model to determine which labels should be rendered and what they will look
/// like when a chart renders the labels.
class ChartLabels with EquatableMixin {
  /// The labels to show on the y-axis.
  final ChartAxisLabels<double> vertical;

  /// The labels to show on the x-axis.
  final ChartAxisLabels<int> horizontal;

  const ChartLabels({
    this.vertical = const ChartAxisLabels(),
    this.horizontal = const ChartAxisLabels(),
  });

  @override
  List<Object?> get props => [vertical, horizontal];
}
