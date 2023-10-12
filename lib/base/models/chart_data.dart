import 'package:equatable/equatable.dart';

import 'chart_grid.dart';
import 'chart_item.dart';

abstract class ChartData<Item extends ChartItem> with EquatableMixin {
  final ChartGrid grid;
  final List<Item> items;

  double get minY;
  double get maxY;

  const ChartData({required this.grid, required this.items});

  @override
  List<Object?> get props => [grid, items];
}
