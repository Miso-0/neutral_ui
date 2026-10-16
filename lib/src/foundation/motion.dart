import 'package:flutter/widgets.dart';

/// Resolves a motion duration against the user's reduced motion preference.
Duration reducedMotionDuration(BuildContext context, Duration duration) =>
    MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;

/// Shared spring responses for gestures and retargetable motion.
enum MotionSpring {
  /// A responsive spring that settles without bouncing.
  standard,

  /// A short response for small controls.
  quick,

  /// A softer response with a small amount of overshoot.
  bouncy;

  /// The physical spring used by this response.
  SpringDescription get description => switch (this) {
    standard => SpringDescription.withDurationAndBounce(
      duration: const Duration(milliseconds: 350),
    ),
    quick => SpringDescription.withDurationAndBounce(
      duration: const Duration(milliseconds: 220),
    ),
    bouncy => SpringDescription.withDurationAndBounce(
      duration: const Duration(milliseconds: 450),
      bounce: 0.2,
    ),
  };
}

/// Settles from the current value and velocity, preserving gesture momentum.
///
/// Use an unbounded controller when the response may overshoot its bounds.
TickerFuture animateWithSpring(
  BuildContext context,
  AnimationController controller,
  double target, {
  double? velocity,
  MotionSpring spring = MotionSpring.standard,
}) {
  if (MediaQuery.disableAnimationsOf(context)) {
    return controller.animateTo(target, duration: Duration.zero);
  }
  return controller.animateWith(
    ScrollSpringSimulation(
      spring.description,
      controller.value,
      target,
      velocity ?? controller.velocity,
    ),
  );
}

/// Builds the default popover fade and scale around a cached panel.
Widget overlayTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child, {
  AlignmentGeometry alignment = Alignment.topCenter,
}) => FadeTransition(
  opacity: animation,
  child: ScaleTransition(
    scale: animation.drive(Tween<double>(begin: 0.96, end: 1)),
    alignment: alignment.resolve(Directionality.of(context)),
    child: child is RepaintBoundary ? child : RepaintBoundary(child: child),
  ),
);
