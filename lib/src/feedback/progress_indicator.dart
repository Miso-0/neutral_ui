import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../foundation/decoration_lerp.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/style_resolution.dart';
import '../styles/progress_indicator_style.dart';
import '../theme/navigation_themes.dart';

/// A circular determinate or repeating progress indicator.
class CircularProgressIndicator extends StatelessWidget {
  /// Creates circular progress indicator.
  const CircularProgressIndicator({
    super.key,
    this.value,
    this.semanticsLabel,
    this.semanticsValue,
    this.style,
  }) : assert(value == null || (value >= 0 && value <= 1));

  /// The value for this component.
  final double? value;

  /// The semantics label for this component.
  final String? semanticsLabel;

  /// The semantics value for this component.
  final String? semanticsValue;

  /// The style for this component.
  final ProgressIndicatorStyle? style;
  @override
  Widget build(BuildContext context) => _ProgressIndicator(
    value: value,
    semanticsLabel: semanticsLabel,
    semanticsValue: semanticsValue,
    style: style,
    circular: true,
  );
}

/// A linear determinate or repeating progress indicator.
class LinearProgressIndicator extends StatelessWidget {
  /// Creates linear progress indicator.
  const LinearProgressIndicator({
    super.key,
    this.value,
    this.semanticsLabel,
    this.semanticsValue,
    this.style,
  }) : assert(value == null || (value >= 0 && value <= 1));

  /// The value for this component.
  final double? value;

  /// The semantics label for this component.
  final String? semanticsLabel;

  /// The semantics value for this component.
  final String? semanticsValue;

  /// The style for this component.
  final ProgressIndicatorStyle? style;
  @override
  Widget build(BuildContext context) => _ProgressIndicator(
    value: value,
    semanticsLabel: semanticsLabel,
    semanticsValue: semanticsValue,
    style: style,
    circular: false,
  );
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.value,
    required this.semanticsLabel,
    required this.semanticsValue,
    required this.style,
    required this.circular,
  });
  final double? value;
  final String? semanticsLabel;
  final String? semanticsValue;
  final ProgressIndicatorStyle? style;
  final bool circular;
  @override
  Widget build(BuildContext context) {
    final ProgressIndicatorStyle effective =
        style?.merge(ProgressIndicatorTheme.of(context)) ??
        ProgressIndicatorTheme.of(context);
    final ProgressIndicatorStyle theme = ProgressIndicatorTheme.of(context);
    final List<ProgressIndicatorStyle?> layers = <ProgressIndicatorStyle?>[
      style,
      theme,
    ];
    final Color ambient = IconTheme.of(context).color!;
    final Color color =
        resolveStatefulOrDefault<ProgressIndicatorStyle, Color>(
          const InteractionState(),
          layers,
          (ProgressIndicatorStyle style) => style.color,
          () => ambient,
        ) ??
        ambient.withAlpha(0);
    final Color? background = resolveStateful<ProgressIndicatorStyle, Color>(
      const InteractionState(),
      layers,
      (ProgressIndicatorStyle style) => style.backgroundColor,
    );
    final double iconSize = IconTheme.of(context).size ?? 24;
    final Size size =
        effective.size ??
        (circular
            ? Size.square(iconSize)
            : Size(144, effective.minHeight ?? 4));
    final Duration duration = reducedMotionDuration(
      context,
      effective.animationDuration ?? const Duration(milliseconds: 200),
    );
    Widget paint(double phase) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          _AnimatedProgressPaint(
            duration: duration,
            curve: effective.animationCurve ?? Curves.easeInOut,
            value: value ?? 0.25,
            phase: phase,
            indeterminate: value == null,
            circular: circular,
            color: color,
            background: background,
            strokeWidth: effective.strokeWidth ?? 2,
            strokeCap: effective.strokeCap ?? StrokeCap.butt,
            radius: (effective.borderRadius ?? BorderRadius.zero).resolve(
              Directionality.of(context),
            ),
            rtl: Directionality.of(context) == TextDirection.rtl,
            child: SizedBox(
              width: circular
                  ? size.width
                  : (constraints.hasBoundedWidth
                        ? constraints.maxWidth
                        : size.width),
              height: size.height,
            ),
          ),
    );
    Widget result = value != null
        ? paint(0)
        : RepeatingAnimationBuilder<double>(
            animatable: Tween<double>(begin: 0, end: 1),
            duration:
                effective.indeterminateDuration ??
                const Duration(milliseconds: 1200),
            paused: MediaQuery.disableAnimationsOf(context),
            builder: (BuildContext context, double phase, Widget? child) =>
                paint(MediaQuery.disableAnimationsOf(context) ? 0.5 : phase),
          );
    if (!circular) {
      result = ConstrainedBox(
        constraints: BoxConstraints(minWidth: size.width),
        child: result,
      );
    }
    return Semantics(
      container: true,
      label: semanticsLabel,
      value:
          semanticsValue ??
          (value == null ? null : '${(value! * 100).round()}%'),
      child: RepaintBoundary(child: result),
    );
  }
}

class _AnimatedProgressPaint extends ImplicitlyAnimatedWidget {
  const _AnimatedProgressPaint({
    required this.value,
    required this.phase,
    required this.indeterminate,
    required this.circular,
    required this.color,
    required this.background,
    required this.strokeWidth,
    required this.strokeCap,
    required this.radius,
    required this.rtl,
    required this.child,
    required super.duration,
    required super.curve,
  });
  final double value;
  final double phase;
  final bool indeterminate;
  final bool circular;
  final Color color;
  final Color? background;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final BorderRadius radius;
  final bool rtl;
  final Widget child;
  @override
  AnimatedWidgetBaseState<_AnimatedProgressPaint> createState() =>
      _AnimatedProgressPaintState();
}

class _AnimatedProgressPaintState
    extends AnimatedWidgetBaseState<_AnimatedProgressPaint> {
  Tween<double>? _value;
  _PremultipliedColorTween? _color;
  _PremultipliedColorTween? _background;
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _value = visitor(
      _value,
      widget.value,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _color = visitor(
      _color,
      widget.color,
      (dynamic value) => _PremultipliedColorTween(begin: value as Color),
    ) as _PremultipliedColorTween?;
    _background = visitor(
      _background,
      widget.background,
      (dynamic value) => _PremultipliedColorTween(begin: value as Color),
    ) as _PremultipliedColorTween?;
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _ProgressPainter(
      value: _value?.evaluate(animation) ?? widget.value,
      phase: widget.phase,
      indeterminate: widget.indeterminate,
      circular: widget.circular,
      color: _color?.evaluate(animation) ?? widget.color,
      background: _background?.evaluate(animation),
      strokeWidth: widget.strokeWidth,
      strokeCap: widget.strokeCap,
      radius: widget.radius,
      rtl: widget.rtl,
    ),
    child: widget.child,
  );
}

class _PremultipliedColorTween extends Tween<Color?> {
  _PremultipliedColorTween({super.begin});
  @override
  Color? lerp(double t) => lerpColorPremultiplied(begin, end, t);
}

class _ProgressPainter extends CustomPainter {
  const _ProgressPainter({
    required this.value,
    required this.phase,
    required this.indeterminate,
    required this.circular,
    required this.color,
    required this.background,
    required this.strokeWidth,
    required this.strokeCap,
    required this.radius,
    required this.rtl,
  });
  final double value;
  final double phase;
  final bool indeterminate;
  final bool circular;
  final Color color;
  final Color? background;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final BorderRadius radius;
  final bool rtl;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeCap = strokeCap;
    if (circular) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      final Rect rect = (Offset.zero & size).deflate(strokeWidth / 2);
      if (background != null) {
        paint.color = background!;
        canvas.drawArc(rect, 0, 2 * math.pi, false, paint);
        paint.color = color;
      }
      canvas.drawArc(
        rect,
        -math.pi / 2 + phase * math.pi * 2,
        value * math.pi * 2,
        false,
        paint,
      );
    } else {
      final Rect rect = Offset.zero & size;
      final RRect clip = radius.toRRect(rect);
      if (background != null) {
        paint.color = background!;
        canvas.drawRRect(clip, paint);
        paint.color = color;
      }
      canvas.save();
      canvas.clipRRect(clip);
      final double width = size.width * value;
      double left = indeterminate ? (size.width + width) * phase - width : 0;
      if (rtl) left = size.width - left - width;
      canvas.drawRect(Rect.fromLTWH(left, 0, width, size.height), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ProgressPainter old) =>
      value != old.value ||
      phase != old.phase ||
      indeterminate != old.indeterminate ||
      circular != old.circular ||
      color != old.color ||
      background != old.background ||
      strokeWidth != old.strokeWidth ||
      strokeCap != old.strokeCap ||
      radius != old.radius ||
      rtl != old.rtl;
}
