import 'package:flutter/widgets.dart';

import 'decoration_lerp.dart';

/// An [AnimatedContainer] replacement whose decorations fade cleanly.
///
/// Layout, decoration insets and clipping match a plain [Container] built from
/// the animated values, exactly as [AnimatedContainer] does. Decorations
/// interpolate with [lerpDecoration], so transparent colors never flash dark
/// part-way through a transition, and a decoration that appears or disappears
/// fades instead of snapping.
///
/// The widget tree below the surface keeps the same shape whichever values are
/// null, so a state change never remounts [child] or resets its state.
class AnimatedSurface extends StatefulWidget {
  /// Creates an implicitly animated decorated box.
  AnimatedSurface({
    super.key,
    this.padding,
    this.decoration,
    this.foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.clipBehavior = Clip.none,
    this.child,
    this.curve = Curves.linear,
    required this.duration,
    this.transitionKey,
  }) : assert(padding == null || padding.isNonNegative),
       assert(constraints == null || constraints.debugAssertIsValid()),
       constraints = (width != null || height != null)
           ? constraints?.tighten(width: width, height: height) ??
                 BoxConstraints.tightFor(width: width, height: height)
           : constraints;

  /// The empty space inside the decoration.
  final EdgeInsetsGeometry? padding;

  /// The decoration painted behind [child].
  final Decoration? decoration;

  /// The decoration painted in front of [child].
  final Decoration? foregroundDecoration;

  /// Additional constraints, including any requested width and height.
  final BoxConstraints? constraints;

  /// How [child] is clipped to the decoration's shape.
  ///
  /// Clipping applies only while a decoration is painted.
  final Clip clipBehavior;

  /// The content of the surface.
  final Widget? child;

  /// The curve applied to each transition.
  final Curve curve;

  /// The length of each transition.
  final Duration duration;

  /// Identifies the state that the current values were resolved for.
  ///
  /// When non-null and unchanged between builds, new values do not start a new
  /// transition: an in-flight transition keeps blending toward the latest
  /// values and an idle surface shows them at once. Use this when the caller
  /// already animates a value, such as a selection position, and only changes
  /// to the key should fade.
  final Object? transitionKey;

  @override
  State<AnimatedSurface> createState() => _AnimatedSurfaceState();
}

class _AnimatedSurfaceState extends State<AnimatedSurface>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: 1,
  )..addListener(_tick);
  late CurvedAnimation _animation = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  // The painted values the current transition started from.
  late EdgeInsetsGeometry? _padding = widget.padding;
  late Decoration? _decoration = widget.decoration;
  late Decoration? _foregroundDecoration = widget.foregroundDecoration;
  late BoxConstraints? _constraints = widget.constraints;

  void _tick() => setState(() {});

  @override
  void didUpdateWidget(AnimatedSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    final bool changed =
        widget.padding != oldWidget.padding ||
        widget.decoration != oldWidget.decoration ||
        widget.foregroundDecoration != oldWidget.foregroundDecoration ||
        widget.constraints != oldWidget.constraints;
    final bool follows =
        widget.transitionKey != null &&
        widget.transitionKey == oldWidget.transitionKey;
    final bool restart = changed && !follows;
    if (restart) {
      // Start from what is on screen, using the outgoing curve.
      final double t = _animation.value;
      _padding = _lerpPadding(_padding, oldWidget.padding, t);
      _decoration = lerpDecoration(_decoration, oldWidget.decoration, t);
      _foregroundDecoration = lerpDecoration(
        _foregroundDecoration,
        oldWidget.foregroundDecoration,
        t,
      );
      _constraints = _lerpConstraints(_constraints, oldWidget.constraints, t);
    }
    if (widget.curve != oldWidget.curve) {
      _animation.dispose();
      _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    }
    if (restart) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double t = _animation.value;
    final Decoration? decoration = lerpDecoration(
      _decoration,
      widget.decoration,
      t,
    );
    final Decoration? foreground = lerpDecoration(
      _foregroundDecoration,
      widget.foregroundDecoration,
      t,
    );
    final EdgeInsetsGeometry? padding = _lerpPadding(
      _padding,
      widget.padding,
      t,
    );
    final BoxConstraints? constraints = _lerpConstraints(
      _constraints,
      widget.constraints,
      t,
    );
    final bool clip = decoration != null && widget.clipBehavior != Clip.none;
    Widget? current = widget.child;
    if (current == null && (constraints == null || !constraints.isTight)) {
      current = LimitedBox(
        maxWidth: 0,
        maxHeight: 0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    }
    EdgeInsetsGeometry inset = padding ?? EdgeInsets.zero;
    if (decoration != null) inset = inset.add(decoration.padding);
    // Every wrapper is always present, with inert values when unused, so the
    // child keeps its element and state whichever values are null.
    return ConstrainedBox(
      constraints: constraints ?? const BoxConstraints(),
      child: DecoratedBox(
        decoration: decoration ?? const _NoDecoration(),
        child: DecoratedBox(
          decoration: foreground ?? const _NoDecoration(),
          position: DecorationPosition.foreground,
          child: ClipPath(
            clipper: clip
                ? _DecorationClipper(
                    textDirection: Directionality.maybeOf(context),
                    decoration: decoration,
                  )
                : null,
            clipBehavior: clip ? widget.clipBehavior : Clip.none,
            child: Padding(padding: inset, child: current),
          ),
        ),
      ),
    );
  }
}

// Null endpoints snap, matching implicitly animated containers.
EdgeInsetsGeometry? _lerpPadding(
  EdgeInsetsGeometry? a,
  EdgeInsetsGeometry? b,
  double t,
) => a == null || b == null || t == 1 ? b : EdgeInsetsGeometry.lerp(a, b, t);

// Null endpoints snap; mixed finite and unbounded constraints cannot blend.
BoxConstraints? _lerpConstraints(
  BoxConstraints? a,
  BoxConstraints? b,
  double t,
) => a == null || b == null || t == 1 ? b : BoxConstraints.lerp(a, b, t);

/// Paints nothing and ignores hit tests, standing in for a null decoration.
class _NoDecoration extends Decoration {
  const _NoDecoration();

  @override
  bool hitTest(Size size, Offset position, {TextDirection? textDirection}) =>
      false;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => const _NoPainter();
}

class _NoPainter extends BoxPainter {
  const _NoPainter();

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}

class _DecorationClipper extends CustomClipper<Path> {
  _DecorationClipper({TextDirection? textDirection, required this.decoration})
    : textDirection = textDirection ?? TextDirection.ltr;

  final TextDirection textDirection;
  final Decoration decoration;

  @override
  Path getClip(Size size) =>
      decoration.getClipPath(Offset.zero & size, textDirection);

  @override
  bool shouldReclip(_DecorationClipper oldClipper) =>
      oldClipper.decoration != decoration ||
      oldClipper.textDirection != textDirection;
}
