import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/chart_data.dart';
import 'chart_base.dart';

/// A widget to render the horizontal labels of a chart based on the information
/// provided by a [ChartLabels] object.
class HorizontalLabels extends StatelessWidget {
  /// The data that will be rendered in the chart, this will be a specific
  /// implementation for the type of chart that should be rendered.
  final ChartData data;

  // The alignment of the labels.
  final XAxisAlignment xAxisAlignment;

  const HorizontalLabels({
    super.key,
    required this.data,
    required this.xAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth /
            (xAxisAlignment == XAxisAlignment.spaceAround
                ? data.items.length
                : data.items.length - 1);
        return Stack(
          children: data.items
              .mapIndexed((index, item) {
                final text = data.labels.horizontal.getLabelText?.call(item.x);

                if (text == null) {
                  return null;
                }

                var offset = index * itemWidth;
                if (xAxisAlignment == XAxisAlignment.spaceAround) {
                  offset += itemWidth / 2;
                }

                var translation = data.labels.horizontal.offset - 0.5;

                if (xAxisAlignment == XAxisAlignment.spaceBetween &&
                    index == 0) {
                  translation = 0;
                }

                if (xAxisAlignment == XAxisAlignment.spaceBetween &&
                    index == data.items.length - 1) {
                  translation = -1;
                }

                return FractionalTranslation(
                  translation: Offset(translation, 0),
                  child: Transform.translate(
                    offset: Offset(offset, 0),
                    child: Text(text, style: data.labels.horizontal.style),
                  ),
                );
              })
              .whereNotNull()
              .toList(),
        );
      },
    );
  }
}
