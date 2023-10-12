import 'package:equatable/equatable.dart';

/// A base class for an item that will be rendered in a chart. This class
/// has specific implementations for each kind of chart.
///
/// See also:
///
///  * [BarChartItem], for an implementation used in a bar chart.
abstract class ChartItem with EquatableMixin {
  /// The x value of the item, this value is an int for simplicity and will be
  /// mapped to a string for display purposes.
  final int x;

  const ChartItem({required this.x});

  @override
  List<Object?> get props => [x];
}
