import 'package:flutter/widgets.dart';

/// Builds a component transition around cached content.
typedef FeedbackTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);
