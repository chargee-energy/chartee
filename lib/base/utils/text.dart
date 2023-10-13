import 'package:flutter/material.dart';

/// Calculates the size of the provided text if when would be rendered with the
/// provided style.
Size calculateTextSize(String text, TextStyle? style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
