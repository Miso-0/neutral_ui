import 'package:flutter/widgets.dart';

/// Builds an animated surface around an anchored or route-based overlay.
typedef OverlayTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);
