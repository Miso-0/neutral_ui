import 'package:flutter/widgets.dart';

/// Reveals [child] by growing from its start edge while it fades in, and
/// hides it in reverse.
///
/// Hidden, it occupies no space; shown, it takes the child's size. The child
/// stays mounted, so it fades out instead of disappearing as space closes.
class AnimatedReveal extends StatelessWidget {
  /// Creates an animated reveal.
  const AnimatedReveal({
    super.key,
    required this.visible,
    required this.duration,
    required this.curve,
    required this.child,
  });

  /// Whether [child] is shown.
  final bool visible;

  /// The length of each transition.
  final Duration duration;

  /// The curve of each transition.
  final Curve curve;

  /// The revealed content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double factor = visible ? 1 : 0;
    return ClipRect(
      child: AnimatedAlign(
        alignment: AlignmentDirectional.centerStart,
        widthFactor: factor,
        heightFactor: factor,
        duration: duration,
        curve: curve,
        child: AnimatedOpacity(
          opacity: factor,
          duration: duration,
          curve: curve,
          child: child,
        ),
      ),
    );
  }
}
