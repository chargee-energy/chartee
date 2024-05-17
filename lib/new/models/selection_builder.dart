import 'package:flutter/widgets.dart';

import 'chart_item.dart';

typedef SelectionBuilder = Widget Function(
  BuildContext context,
  List<ChartItem> items,
  double centerOffset,
);
