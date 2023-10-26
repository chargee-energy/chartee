import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/chart_data.dart';

/// TODO: Docs
class HorizontalLabels extends StatelessWidget {
  final ChartData data;

  const HorizontalLabels({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / data.items.length;
        return Stack(
          children: data.items
              .mapIndexed((index, item) {
                final offset = index * itemWidth + itemWidth / 2;
                final text = data.labels.horizontal.getLabelText?.call(item.x);

                if (text == null) {
                  return null;
                }

                return FractionalTranslation(
                  translation: Offset(data.labels.horizontal.offset - 0.5, 0),
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
