import 'package:flutter/widgets.dart';

import 'decoration_lerp.dart';

/// An [AnimatedContainer] replacement whose decorations fade cleanly.
///
/// Layout, decoration insets and clipping come from a plain [Container] built
/// from the animated values, exactly as [AnimatedContainer] does. Decorations
/// interpolate with [lerpDecoration], so transparent colors never flash dark
/// part-way through a transition.
class AnimatedSurface extends ImplicitlyAnimatedWidget {
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
    super.curve,
    required super.duration,
    super.onEnd,
  }) : assert(padding == null || padding.isNonNegative),
       assert(decoration != null || clipBehavior == Clip.none),
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
  final Clip clipBehavior;

  /// The content of the surface.
  final Widget? child;

  @override
  AnimatedWidgetBaseState<AnimatedSurface> createState() =>
      _AnimatedSurfaceState();
}

class _AnimatedSurfaceState extends AnimatedWidgetBaseState<AnimatedSurface> {
  EdgeInsetsGeometryTween? _padding;
  _DecorationTween? _decoration;
  _DecorationTween? _foregroundDecoration;
  BoxConstraintsTween? _constraints;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _padding = visitor(
      _padding,
      widget.padding,
      (dynamic value) =>
          EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry),
    ) as EdgeInsetsGeometryTween?;
    _decoration = visitor(
      _decoration,
      widget.decoration,
      (dynamic value) => _DecorationTween(begin: value as Decoration),
    ) as _DecorationTween?;
    _foregroundDecoration = visitor(
      _foregroundDecoration,
      widget.foregroundDecoration,
      (dynamic value) => _DecorationTween(begin: value as Decoration),
    ) as _DecorationTween?;
    _constraints = visitor(
      _constraints,
      widget.constraints,
      (dynamic value) => BoxConstraintsTween(begin: value as BoxConstraints),
    ) as BoxConstraintsTween?;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;
    final Decoration? decoration = _decoration?.evaluate(animation);
    return Container(
      padding: _padding?.evaluate(animation),
      decoration: decoration,
      foregroundDecoration: _foregroundDecoration?.evaluate(animation),
      constraints: _constraints?.evaluate(animation),
      clipBehavior: decoration == null ? Clip.none : widget.clipBehavior,
      child: widget.child,
    );
  }
}

class _DecorationTween extends Tween<Decoration?> {
  _DecorationTween({super.begin});

  @override
  Decoration? lerp(double t) => lerpDecoration(begin, end, t);
}
