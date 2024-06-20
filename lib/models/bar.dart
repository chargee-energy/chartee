import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

class Bar with EquatableMixin {
  final double fromValue;
  final double toValue;
  final Color color;
  final Color? highlightColor;
  final double? width;
  final BorderRadius borderRadius;

  double get minValue => min(fromValue, toValue);
  double get maxValue => max(fromValue, toValue);

  const Bar({
    required this.fromValue,
    required this.toValue,
    required this.color,
    this.highlightColor,
    this.width,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  List<Object?> get props => [
        fromValue,
        toValue,
        color,
        highlightColor,
        width,
        borderRadius,
      ];
}
