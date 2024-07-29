import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/bounding_box.dart';
import '../models/chart_item.dart';
import '../models/chart_layer.dart';
import '../models/labels.dart';
import '../utils/chart.dart';
import '../utils/items.dart';
import '../utils/layers.dart';
import 'chart_base.dart';

class ScrollableChart extends StatelessWidget {
  final List<ChartLayer> layers;
  final double contentWidth;
  final double contentInset;
  final EdgeInsets padding;
  final Labels? leftLabels;
  final Labels? rightLabels;
  final Labels? topLabels;
  final Labels? bottomLabels;
  final ValueChanged<List<ChartItem>>? onSelectionChanged;
  final BoundsAdjuster adjustBounds;
  final IntervalsProvider Function(BoundingBox bounds, List<ChartItem> items)
      xIntervalsProvider;
  final IntervalsProvider Function(BoundingBox bounds, List<ChartItem> items)
      yIntervalsProvider;

  const ScrollableChart({
    super.key,
    required this.layers,
    required this.contentWidth,
    this.contentInset = 0,
    this.padding = EdgeInsets.zero,
    this.leftLabels,
    this.rightLabels,
    this.topLabels,
    this.bottomLabels,
    this.onSelectionChanged,
    this.adjustBounds = AdjustBounds.noAdjustment,
    this.xIntervalsProvider = OutlineXIntervals.create,
    this.yIntervalsProvider = OutlineYIntervals.create,
  });

  @override
  Widget build(BuildContext context) {
    return ChartBase(
      layers: layers,
      padding: padding,
      leftLabels: leftLabels,
      rightLabels: rightLabels,
      topLabels: topLabels,
      bottomLabels: bottomLabels,
      adjustBounds: adjustBounds,
      xIntervalsProvider: xIntervalsProvider,
      yIntervalsProvider: yIntervalsProvider,
      builder: (
        context,
        bounds,
        items,
        contentPadding,
        xIntervals,
        yIntervals,
        leftLabels,
        rightLabels,
        topLabels,
        bottomLabels,
      ) =>
          ChartScrollView(
        bounds: bounds,
        layers: layers,
        contentWidth: contentWidth,
        contentInset: contentInset,
        padding: contentPadding,
        items: items,
        xIntervals: xIntervals.intervals,
        yIntervals: yIntervals.intervals,
        leftLabels: leftLabels,
        rightLabels: rightLabels,
        topLabels: topLabels,
        bottomLabels: bottomLabels,
      ),
    );
  }
}

class ChartScrollView extends StatefulWidget {
  final BoundingBox bounds;
  final List<ChartLayer> layers;
  final double contentWidth;
  final double contentInset;
  final EdgeInsets padding;
  final List<ChartItem> items;
  final List<double> xIntervals;
  final List<double> yIntervals;
  final Widget? leftLabels;
  final Widget? rightLabels;
  final Widget? topLabels;
  final Widget? bottomLabels;

  const ChartScrollView({
    super.key,
    required this.bounds,
    required this.layers,
    required this.contentWidth,
    required this.contentInset,
    required this.padding,
    required this.items,
    required this.xIntervals,
    required this.yIntervals,
    required this.leftLabels,
    required this.rightLabels,
    required this.topLabels,
    required this.bottomLabels,
  });

  @override
  State<ChartScrollView> createState() => _ChartScrollViewState();
}

class _ChartScrollViewState extends State<ChartScrollView> {
  late ScrollController _scrollController;
  List<ChartItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateSelectedItems);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateSelectedItems);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateSelectedItems() {
    final nearestItems = nearestItemsForOffset(
      widget.bounds,
      widget.items,
      _scrollController.offset,
      widget.contentWidth,
    );

    if (!listEquals(nearestItems, _selectedItems)) {
      setState(() {
        _selectedItems = nearestItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: _scrollController,
      axisDirection: AxisDirection.right,
      clipBehavior: Clip.none,
      physics: ScrollableChartPhysics(
        bounds: widget.bounds,
        items: widget.items,
        contentWidth: widget.contentWidth,
      ),
      viewportBuilder: (context, position) => Stack(
        fit: StackFit.expand,
        children: widget.layers.map(
              (layer) {
                final child = getLayerWidget(
                  context,
                  layer,
                  widget.bounds,
                  widget.xIntervals,
                  widget.yIntervals,
                  _selectedItems,
                  widget.padding,
                );

                if (layer.isStatic) {
                  return child;
                }

                return ChartScrollSection(
                  position: position,
                  contentWidth: widget.contentWidth + widget.padding.horizontal,
                  contentInset: widget.contentInset,
                  child: child,
                );
              },
            ).toList() +
            [
              // TODO: Left and right labels scroll possibility?
              widget.leftLabels,
              widget.rightLabels,
              if (widget.topLabels case final topLabels?)
                ChartScrollSection(
                  position: position,
                  contentWidth: widget.contentWidth + widget.padding.horizontal,
                  contentInset: widget.contentInset,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      topLabels,
                    ],
                  ),
                ),
              if (widget.bottomLabels case final bottomLabels?)
                ChartScrollSection(
                  position: position,
                  contentWidth: widget.contentWidth + widget.padding.horizontal,
                  contentInset: widget.contentInset,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      bottomLabels,
                    ],
                  ),
                ),
            ].whereNotNull().toList(),
      ),
    );
  }
}

class ChartScrollSection extends StatelessWidget {
  final ViewportOffset position;
  final double contentWidth;
  final double contentInset;
  final Widget child;

  const ChartScrollSection({
    super.key,
    required this.position,
    required this.contentWidth,
    required this.contentInset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Viewport(
      offset: position,
      clipBehavior: Clip.none,
      axisDirection: AxisDirection.right,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            // TODO: More logical padding to add a full viewports width?
            padding: EdgeInsets.only(left: contentInset, right: 1000),
            child: SizedBox(
              width: contentWidth,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollableChartPhysics extends ScrollPhysics {
  final BoundingBox bounds;
  final List<ChartItem> items;
  final double contentWidth;

  const ScrollableChartPhysics({
    super.parent,
    required this.bounds,
    required this.items,
    required this.contentWidth,
  });

  @override
  ScrollableChartPhysics applyTo(ScrollPhysics? ancestor) {
    return ScrollableChartPhysics(
      parent: buildParent(ancestor),
      bounds: bounds,
      items: items,
      contentWidth: contentWidth,
    );
  }

  double _getTargetPixels(ScrollMetrics position) {
    final nearestItems = nearestItemsForOffset(
      bounds,
      items,
      position.pixels,
      contentWidth,
    );

    if (nearestItems.isEmpty) {
      return position.pixels;
    }

    return bounds.getFractionX(nearestItems.first.x) * contentWidth;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final tolerance = toleranceFor(position);
    final target = _getTargetPixels(position);

    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }

    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
