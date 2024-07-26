import 'package:flutter/widgets.dart';

import '../models/bar_stack.dart';
import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/chart_layer.dart';
import '../widgets/chart_area.dart';
import '../widgets/chart_bars.dart';
import '../widgets/chart_cursor.dart';
import '../widgets/chart_grid.dart';
import '../widgets/chart_line.dart';
import '../widgets/chart_selection.dart';

Widget getLayerWidget(
  BuildContext context,
  ChartLayer layer,
  BoundingBox bounds,
  List<double> xIntervals,
  List<double> yIntervals,
  List<ChartItem> selectedItems,
  EdgeInsets padding,
) =>
    switch (layer) {
      ChartGridLayer(
        :final horizontalLineBuilder,
        :final verticalLineBuilder,
      ) =>
        ChartGrid(
          padding: padding,
          bounds: bounds,
          xIntervals: xIntervals,
          yIntervals: yIntervals,
          horizontalLineBuilder: horizontalLineBuilder,
          verticalLineBuilder: verticalLineBuilder,
        ),
      ChartSelectionLayer(
        :final builder,
        :final sticky,
        :final translation,
        :final initialItems,
      ) =>
        ChartSelection(
          padding: padding,
          bounds: bounds,
          items: selectedItems,
          initialItems: initialItems,
          builder: builder,
          sticky: sticky,
          translation: translation,
        ),
      ChartLineLayer(
        :final items,
        :final positiveColor,
        :final negativeColor,
        :final lineWidth,
        :final dashArray,
      ) =>
        Padding(
          padding: padding,
          child: ChartLine(
            bounds: bounds,
            points: items,
            positiveColor: positiveColor,
            negativeColor: negativeColor,
            lineWidth: lineWidth,
            dashArray: dashArray,
          ),
        ),
      ChartAreaLayer(
        :final items,
        :final positiveColor,
        :final negativeColor,
      ) =>
        Padding(
          padding: padding,
          child: ChartArea(
            bounds: bounds,
            points: items,
            positiveColor: positiveColor,
            negativeColor: negativeColor,
          ),
        ),
      ChartBarLayer(:final items) => Padding(
          padding: padding,
          child: ChartBars(
            bounds: bounds,
            barStacks: items,
            selectedBarStacks: selectedItems.whereType<BarStack>().toList(),
          ),
        ),
      ChartCursorLayer(:final builder, :final point) => Padding(
          padding: padding,
          child: ChartCursor(
            bounds: bounds,
            builder: builder,
            point: point,
          ),
        ),
      ChartCustomLayer(:final builder) => builder(context, bounds, padding),
    };
