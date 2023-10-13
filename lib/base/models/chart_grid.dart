import 'package:equatable/equatable.dart';

import 'chart_axis_lines.dart';

/// A model to determine which lines should be rendered and what they will look
/// like when a chart renders the grid.
class ChartGrid with EquatableMixin {
  /// The lines to show on the y-axis.
  final ChartAxisLines<double> vertical;

  /// The lines to show on the x-axis.
  final ChartAxisLines<int> horizontal;

  const ChartGrid({
    this.vertical = const ChartAxisLines(),
    this.horizontal = const ChartAxisLines(),
  });

  @override
  List<Object?> get props => [vertical, horizontal];
}
