import 'package:equatable/equatable.dart';

import 'chart_line.dart';

/// A model to determine which lines should be rendered and what they will look
/// like when a chart renders the grid.
class ChartGrid with EquatableMixin {
  /// Whether to show lines on the y-axis
  final bool showVertical;

  /// Whether to show lines on the x-axis
  final bool showHorizontal;

  /// A function to get the rendering information for a line on the y-axis
  final ChartLine Function(double value)? getVerticalLine;

  /// A function to get the rendering information for a line on the x-axis
  final ChartLine Function(int value)? getHorizontalLine;

  const ChartGrid({
    this.showHorizontal = true,
    this.showVertical = true,
    this.getHorizontalLine,
    this.getVerticalLine,
  });

  @override
  List<Object?> get props => [
        showVertical,
        showHorizontal,
        getVerticalLine,
        getHorizontalLine,
      ];
}
