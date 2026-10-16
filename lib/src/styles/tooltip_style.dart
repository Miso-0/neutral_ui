import 'package:flutter/widgets.dart';

import '../feedback/feedback_transition.dart';
import '../overlay/overlay_placement.dart';
import '../overlay/overlay_behavior.dart';

/// Optional appearance and motion tokens for tooltip components.
@immutable
class TooltipStyle {
  /// Creates inheritable component tokens.
  const TooltipStyle({
    this.decoration,
    this.padding,
    this.margin,
    this.constraints,
    this.textStyle,
    this.textAlign,
    this.placement,
    this.overlayLocation,
    this.verticalOffset,
    this.preferBelow,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.transitionCurve,
    this.reverseTransitionCurve,
    this.transitionBuilder,
  });

  /// The decoration token. Null inherits from the enclosing style.
  final Decoration? decoration;

  /// The padding token. Null inherits from the enclosing style.
  final EdgeInsetsGeometry? padding;

  /// The margin token. Null inherits from the enclosing style.
  final EdgeInsetsGeometry? margin;

  /// The constraints token. Null inherits from the enclosing style.
  final BoxConstraints? constraints;

  /// The textStyle token. Null inherits from the enclosing style.
  final TextStyle? textStyle;

  /// The textAlign token. Null inherits from the enclosing style.
  final TextAlign? textAlign;

  /// The placement token. Null inherits from the enclosing style.
  final OverlayPlacement? placement;

  /// The overlayLocation token. Null inherits from the enclosing style.
  final OverlayLocation? overlayLocation;

  /// The verticalOffset token. Null inherits from the enclosing style.
  final double? verticalOffset;

  /// The preferBelow token. Null inherits from the enclosing style.
  final bool? preferBelow;

  /// The transitionDuration token. Null inherits from the enclosing style.
  final Duration? transitionDuration;

  /// The reverseTransitionDuration token. Null inherits from the enclosing style.
  final Duration? reverseTransitionDuration;

  /// The transitionCurve token. Null inherits from the enclosing style.
  final Curve? transitionCurve;

  /// The reverseTransitionCurve token. Null inherits from the enclosing style.
  final Curve? reverseTransitionCurve;

  /// The transitionBuilder token. Null inherits from the enclosing style.
  final FeedbackTransitionBuilder? transitionBuilder;

  /// Copies this style, replacing supplied tokens.
  TooltipStyle copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxConstraints? constraints,
    TextStyle? textStyle,
    TextAlign? textAlign,
    OverlayPlacement? placement,
    OverlayLocation? overlayLocation,
    double? verticalOffset,
    bool? preferBelow,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Curve? transitionCurve,
    Curve? reverseTransitionCurve,
    FeedbackTransitionBuilder? transitionBuilder,
  }) => TooltipStyle(
    decoration: decoration ?? this.decoration,
    padding: padding ?? this.padding,
    margin: margin ?? this.margin,
    constraints: constraints ?? this.constraints,
    textStyle: textStyle ?? this.textStyle,
    textAlign: textAlign ?? this.textAlign,
    placement: placement ?? this.placement,
    overlayLocation: overlayLocation ?? this.overlayLocation,
    verticalOffset: verticalOffset ?? this.verticalOffset,
    preferBelow: preferBelow ?? this.preferBelow,
    transitionDuration: transitionDuration ?? this.transitionDuration,
    reverseTransitionDuration:
        reverseTransitionDuration ?? this.reverseTransitionDuration,
    transitionCurve: transitionCurve ?? this.transitionCurve,
    reverseTransitionCurve:
        reverseTransitionCurve ?? this.reverseTransitionCurve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );

  /// Fills unset tokens from [other], preserving this style.
  TooltipStyle merge(TooltipStyle? other) {
    if (other == null) return this;
    return TooltipStyle(
      decoration: decoration ?? other.decoration,
      padding: padding ?? other.padding,
      margin: margin ?? other.margin,
      constraints: constraints ?? other.constraints,
      textStyle: textStyle ?? other.textStyle,
      textAlign: textAlign ?? other.textAlign,
      placement: placement ?? other.placement,
      overlayLocation: overlayLocation ?? other.overlayLocation,
      verticalOffset: verticalOffset ?? other.verticalOffset,
      preferBelow: preferBelow ?? other.preferBelow,
      transitionDuration: transitionDuration ?? other.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? other.reverseTransitionDuration,
      transitionCurve: transitionCurve ?? other.transitionCurve,
      reverseTransitionCurve:
          reverseTransitionCurve ?? other.reverseTransitionCurve,
      transitionBuilder: transitionBuilder ?? other.transitionBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TooltipStyle &&
          decoration == other.decoration &&
          padding == other.padding &&
          margin == other.margin &&
          constraints == other.constraints &&
          textStyle == other.textStyle &&
          textAlign == other.textAlign &&
          placement == other.placement &&
          overlayLocation == other.overlayLocation &&
          verticalOffset == other.verticalOffset &&
          preferBelow == other.preferBelow &&
          transitionDuration == other.transitionDuration &&
          reverseTransitionDuration == other.reverseTransitionDuration &&
          transitionCurve == other.transitionCurve &&
          reverseTransitionCurve == other.reverseTransitionCurve &&
          transitionBuilder == other.transitionBuilder;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    padding,
    margin,
    constraints,
    textStyle,
    textAlign,
    placement,
    overlayLocation,
    verticalOffset,
    preferBelow,
    transitionDuration,
    reverseTransitionDuration,
    transitionCurve,
    reverseTransitionCurve,
    transitionBuilder,
  ]);

  @override
  String toString() =>
      'TooltipStyle(decoration: $decoration, padding: $padding, margin: $margin, constraints: $constraints, textStyle: $textStyle, textAlign: $textAlign, placement: $placement, overlayLocation: $overlayLocation, verticalOffset: $verticalOffset, preferBelow: $preferBelow, transitionDuration: $transitionDuration, reverseTransitionDuration: $reverseTransitionDuration, transitionCurve: $transitionCurve, reverseTransitionCurve: $reverseTransitionCurve, transitionBuilder: $transitionBuilder)';
}
