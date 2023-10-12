import 'package:equatable/equatable.dart';

abstract class ChartItem with EquatableMixin {
  final int x;

  const ChartItem({required this.x});

  @override
  List<Object?> get props => [x];
}
