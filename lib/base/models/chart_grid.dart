import 'package:equatable/equatable.dart';

import 'chart_line.dart';

class ChartGrid with EquatableMixin {
  final bool showVertical;
  final bool showHorizontal;
  final ChartLine Function(double value)? getVerticalLine;
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
