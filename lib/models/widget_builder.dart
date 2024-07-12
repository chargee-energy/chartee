import 'package:flutter/widgets.dart';

import 'bounding_box.dart';

typedef WidgetBuilder = Widget Function(
  BuildContext context,
  BoundingBox bounds,
  EdgeInsets padding,
);
