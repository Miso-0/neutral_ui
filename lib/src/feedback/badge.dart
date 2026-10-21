import 'package:flutter/widgets.dart';

import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/interaction_state.dart';
import '../foundation/motion.dart';
import '../foundation/style_resolution.dart';
import '../localizations/neutral_localizations.dart';
import '../styles/badge_style.dart';
import '../theme/navigation_themes.dart';

/// A compact status mark or label positioned over an optional child.
class Badge extends StatelessWidget {
  /// Creates badge.
  const Badge({
    super.key,
    this.label,
    this.child,
    this.isLabelVisible = true,
    this.style,
    this.decoration,
  }) : _count = null,
       maxCount = 99;

  /// Creates badge.count.
  const Badge.count({
    super.key,
    required int count,
    this.maxCount = 99,
    this.child,
    this.isLabelVisible = true,
    this.style,
    this.decoration,
  }) : assert(count >= 0),
       assert(maxCount > 0),
       _count = count,
       label = null;

  /// The label for this component.
  final Widget? label;

  /// The child for this component.
  final Widget? child;

  /// The is label visible for this component.
  final bool isLabelVisible;

  /// The style for this component.
  final BadgeStyle? style;

  /// The decoration for this component.
  final BoxDecoration? decoration;
  final int? _count;

  /// The max count for this component.
  final int maxCount;
  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'Badge',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: decoration,
        styleValue: style?.decoration,
      ),
    );
    final BadgeStyle theme = BadgeTheme.of(context);
    final BadgeStyle effective = style?.merge(theme) ?? theme;
    final Widget? content = _count == null
        ? label
        : Text(
            NeutralLocalizations.of(context)
                .formatBadgeCount(_count, maxCount: maxCount),
          );
    final bool large = content != null;
    final double size = large
        ? (effective.largeSize ?? 16)
        : (effective.smallSize ?? 6);
    final Duration duration = reducedMotionDuration(
      context,
      effective.animationDuration ?? const Duration(milliseconds: 200),
    );
    final Widget badge = AnimatedOpacity(
      opacity: isLabelVisible ? 1 : 0,
      duration: duration,
      curve: effective.animationCurve ?? Curves.easeInOut,
      child: ExcludeSemantics(
        excluding: !isLabelVisible,
        child: AnimatedSurface(
          duration: duration,
          curve: effective.animationCurve ?? Curves.easeInOut,
          constraints: BoxConstraints(minWidth: size, minHeight: size),
          padding: large ? effective.padding : null,
          decoration:
              decoration ??
              resolveStatefulOrDefault<BadgeStyle, Decoration>(
                const InteractionState(),
                <BadgeStyle?>[style, theme],
                (BadgeStyle s) => s.decoration,
                () => BoxDecoration(color: IconTheme.of(context).color),
              ),
          child: content == null
              ? null
              : AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: effective.animationCurve ?? Curves.easeInOut,
                  style: DefaultTextStyle.of(context).style.merge(
                    effective.textStyle?.resolve(const InteractionState()),
                  ),
                  child: Center(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: content,
                  ),
                ),
        ),
      ),
    );
    if (child == null) return badge;
    final Alignment alignment =
        (effective.alignment ?? AlignmentDirectional.topEnd).resolve(
          Directionality.of(context),
        );
    final Offset offset = effective.offset ?? Offset.zero;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        child!,
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: alignment,
              child: Transform.translate(
                offset: Offset(
                  Directionality.of(context) == TextDirection.rtl
                      ? -offset.dx
                      : offset.dx,
                  offset.dy,
                ),
                child: badge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
