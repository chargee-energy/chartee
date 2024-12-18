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
  final ScrollableChartController? controller;
  final EdgeInsets padding;
  final Labels? leftLabels;
  final Labels? rightLabels;
  final Labels? topLabels;
  final Labels? bottomLabels;
  final ValueChanged<double?>? onSelectionChanged;
  final ValueChanged<double>? onXPressed;
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
    this.controller,
    this.padding = EdgeInsets.zero,
    this.leftLabels,
    this.rightLabels,
    this.topLabels,
    this.bottomLabels,
    this.onSelectionChanged,
    this.onXPressed,
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
        controller: controller,
        padding: contentPadding,
        items: items,
        xIntervals: xIntervals.intervals,
        yIntervals: yIntervals.intervals,
        leftLabels: leftLabels,
        rightLabels: rightLabels,
        topLabels: topLabels,
        bottomLabels: bottomLabels,
        onSelectionChanged: onSelectionChanged,
        onXPressed: onXPressed,
      ),
    );
  }
}

class ChartScrollView extends StatefulWidget {
  final BoundingBox bounds;
  final List<ChartLayer> layers;
  final double contentWidth;
  final double contentInset;
  final ScrollableChartController? controller;
  final EdgeInsets padding;
  final List<ChartItem> items;
  final List<double> xIntervals;
  final List<double> yIntervals;
  final Widget? leftLabels;
  final Widget? rightLabels;
  final Widget? topLabels;
  final Widget? bottomLabels;
  final ValueChanged<double?>? onSelectionChanged;
  final ValueChanged<double>? onXPressed;

  const ChartScrollView({
    super.key,
    required this.bounds,
    required this.layers,
    required this.contentWidth,
    required this.contentInset,
    required this.controller,
    required this.padding,
    required this.items,
    required this.xIntervals,
    required this.yIntervals,
    required this.leftLabels,
    required this.rightLabels,
    required this.topLabels,
    required this.bottomLabels,
    required this.onSelectionChanged,
    required this.onXPressed,
  });

  @override
  State<ChartScrollView> createState() => _ChartScrollViewState();
}

class _ChartScrollViewState extends State<ChartScrollView> {
  late ScrollableChartController _controller;
  final ValueNotifier<double?> _selectedX = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _initController();
    _selectedX.value = _controller.initialX;
  }

  @override
  void didUpdateWidget(covariant ChartScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.contentWidth != widget.contentWidth) {
      _unlinkController(oldWidget.controller == null);
      _initController();
    }
  }

  @override
  void dispose() {
    _unlinkController(widget.controller == null);
    super.dispose();
  }

  void _initController() {
    _controller = widget.controller ?? ScrollableChartController();
    _controller.init(
      bounds: widget.bounds,
      items: widget.items,
      contentWidth: widget.contentWidth,
    );
    _controller.addListener(_updateSelectedItems);
  }

  void _unlinkController(bool dispose) {
    _controller.removeListener(_updateSelectedItems);
    _controller.reset();
    if (dispose) {
      _controller.dispose();
    }
  }

  void _updateSelectedItems() {
    final nearestX = nearestXForOffset(
      widget.bounds,
      widget.items.map((item) => item.x).toSet(),
      _controller.offset,
      widget.contentWidth,
    );

    if (nearestX != _selectedX.value) {
      widget.onSelectionChanged?.call(nearestX);
      _selectedX.value = nearestX;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: _controller,
      axisDirection: AxisDirection.right,
      clipBehavior: Clip.none,
      physics: ScrollableChartPhysics(
        bounds: widget.bounds,
        items: widget.items,
        contentWidth: widget.contentWidth,
      ),
      scrollBehavior:
          ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                  _selectedX,
                  widget.padding,
                  onXPressed: widget.onXPressed,
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
    final nearestX = position is ScrollableChartPosition
        ? position.nearestX
        : nearestXForOffset(
            bounds,
            items.map((item) => item.x).toSet(),
            position.pixels,
            contentWidth,
          );

    if (nearestX == null) {
      return position.pixels;
    }

    return bounds.getFractionX(nearestX) * contentWidth;
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

class ScrollableChartPosition extends ScrollPositionWithSingleContext {
  final BoundingBox bounds;
  final List<ChartItem> items;
  final double contentWidth;
  final double? initialX;

  @override
  double get minScrollExtent => 0;

  @override
  double get maxScrollExtent => contentWidth;

  double? get nearestX {
    assert(
      !hasPixels || hasContentDimensions,
      'Nearest items are only available after content dimensions are established.',
    );
    return !hasPixels || !hasContentDimensions
        ? null
        : getNearestXFromPixels(
            clampDouble(pixels, minScrollExtent, maxScrollExtent));
  }

  ScrollableChartPosition({
    required this.bounds,
    required this.items,
    required this.contentWidth,
    required this.initialX,
    required super.physics,
    required super.context,
    super.initialPixels,
    super.keepScrollOffset,
    super.oldPosition,
    super.debugLabel,
  });

  double getPixelsFromX(double x) => bounds.getFractionX(x) * contentWidth;

  double? getNearestXFromPixels(double pixels) => nearestXForOffset(
        bounds,
        items.map((item) => item.x).toSet(),
        pixels,
        contentWidth,
      );

  @override
  bool applyViewportDimension(double viewportDimension) {
    final oldViewportDimensions =
        hasViewportDimension ? this.viewportDimension : null;

    if (viewportDimension == oldViewportDimensions) {
      return true;
    }

    final result = super.applyViewportDimension(viewportDimension);
    final oldPixels = hasPixels ? pixels : null;

    // TODO: Cache x when viewport resizes to zero? (See PageView)
    final x = initialX;
    final newPixels = x != null ? getPixelsFromX(x) : null;

    if (newPixels != null && newPixels != oldPixels) {
      correctPixels(newPixels);
      return false;
    }

    return result;
  }
}

class ScrollableChartController extends ScrollController {
  final double? initialX;

  BoundingBox? _bounds;
  List<ChartItem>? _items;
  double? _contentWidth;

  double? get nearestX {
    assert(
      positions.isNotEmpty,
      'ScrollableChartController.nearestX cannot be accessed before a ScrollableChart is built with it.',
    );
    assert(
      positions.length == 1,
      'The page nearestX cannot be read when multiple ScrollableChart are attached to '
      'the same ScrollableChartController.',
    );
    final ScrollableChartPosition position =
        this.position as ScrollableChartPosition;
    return position.nearestX;
  }

  ScrollableChartController({
    this.initialX,
    super.onAttach,
    super.onDetach,
  });

  void init({
    required BoundingBox bounds,
    required List<ChartItem> items,
    required double contentWidth,
  }) {
    _bounds = bounds;
    _items = items;
    _contentWidth = contentWidth;
  }

  void reset() {
    _bounds = null;
    _items = null;
    _contentWidth = null;
  }

  Future<void> animateToX(
    double x, {
    required Duration duration,
    required Curve curve,
  }) {
    final ScrollableChartPosition position =
        this.position as ScrollableChartPosition;
    return position.animateTo(
      position.getPixelsFromX(x),
      duration: duration,
      curve: curve,
    );
  }

  void jumpToX(double x) {
    final ScrollableChartPosition position =
        this.position as ScrollableChartPosition;
    position.jumpTo(position.getPixelsFromX(x));
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    _ensureInitialized();
    return ScrollableChartPosition(
      bounds: _bounds!,
      items: _items!,
      contentWidth: _contentWidth!,
      initialX: initialX,
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  void _ensureInitialized() {
    assert(
      _bounds != null && _items != null && _contentWidth != null,
      'This ScrollableChartController has not been initialized yet.',
    );
  }
}
