import 'package:flutter/widgets.dart';

import '../models/bounding_box.dart';
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
  double? selectedX,
  EdgeInsets padding,
) =>
    switch (layer) {
      ChartHorizontalGridLineLayer(:final lineBuilder) =>
        HorizontalChartGridLines(
          padding: padding,
          bounds: bounds,
          intervals: yIntervals,
          lineBuilder: lineBuilder,
        ),
      ChartVerticalGridLineLayer(:final lineBuilder) => VerticalChartGridLines(
          padding: padding,
          bounds: bounds,
          intervals: xIntervals,
          lineBuilder: lineBuilder,
        ),
      ChartSelectionLayer(
        :final builder,
        :final isSticky,
        :final translation,
        :final initialSelectedX,
        :final isStatic,
      ) =>
        ChartSelection(
          padding: padding,
          bounds: bounds,
          selectedX: selectedX,
          initialSelectedX: initialSelectedX,
          builder: builder,
          isSticky: isSticky,
          translation: translation,
          isStatic: isStatic,
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
            selectedBarStacks:
                items.where((item) => item.x == selectedX).toList(),
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
