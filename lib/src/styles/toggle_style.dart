import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';

/// Tokens for checkbox, switch, and radio structure and appearance.
///
/// Null tokens inherit from the next style layer. No visual values are supplied.
@immutable
class ToggleStyle {
  /// Creates a collection of optional component tokens.
  const ToggleStyle({
    this.size,
    this.decoration,
    this.thumbSize,
    this.thumbDecoration,
    this.indicator,
    this.indeterminateIndicator,
    this.padding,
    this.tapTargetSize,
    this.mouseCursor,
    this.animationDuration,
    this.animationCurve,
    this.enableFeedback,
  });

  /// The visual size of the box, track, or ring.
  final StateProperty<Size?>? size;

  /// The decoration of the box, track, or ring.
  final StateProperty<Decoration?>? decoration;

  /// The visual size of the thumb or radio dot.
  final StateProperty<Size?>? thumbSize;

  /// The decoration of the thumb or radio dot.
  final StateProperty<Decoration?>? thumbDecoration;

  /// The indicator for the current state.
  final StateProperty<Widget?>? indicator;

  /// The indicator for an indeterminate checkbox.
  final StateProperty<Widget?>? indeterminateIndicator;

  /// The inset around the indicator or thumb travel.
  final EdgeInsetsGeometry? padding;

  /// The minimum interactive size.
  final Size? tapTargetSize;

  /// The pointer cursor for the current interaction state.
  final StateProperty<MouseCursor?>? mouseCursor;

  /// The duration of visual and selection transitions.
  final Duration? animationDuration;

  /// The curve of visual and selection transitions.
  final Curve? animationCurve;

  /// Whether interactions provide platform feedback.
  final bool? enableFeedback;

  /// Returns a copy with the supplied non-null tokens replaced.
  ToggleStyle copyWith({
    StateProperty<Size?>? size,
    StateProperty<Decoration?>? decoration,
    StateProperty<Size?>? thumbSize,
    StateProperty<Decoration?>? thumbDecoration,
    StateProperty<Widget?>? indicator,
    StateProperty<Widget?>? indeterminateIndicator,
    EdgeInsetsGeometry? padding,
    Size? tapTargetSize,
    StateProperty<MouseCursor?>? mouseCursor,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableFeedback,
  }) {
    return ToggleStyle(
      size: size ?? this.size,
      decoration: decoration ?? this.decoration,
      thumbSize: thumbSize ?? this.thumbSize,
      thumbDecoration: thumbDecoration ?? this.thumbDecoration,
      indicator: indicator ?? this.indicator,
      indeterminateIndicator:
          indeterminateIndicator ?? this.indeterminateIndicator,
      padding: padding ?? this.padding,
      tapTargetSize: tapTargetSize ?? this.tapTargetSize,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      enableFeedback: enableFeedback ?? this.enableFeedback,
    );
  }

  /// Fills unset tokens from [other], preserving this style's tokens.
  ToggleStyle merge(ToggleStyle? other) {
    if (other == null) {
      return this;
    }
    return ToggleStyle(
      size: size ?? other.size,
      decoration: decoration ?? other.decoration,
      thumbSize: thumbSize ?? other.thumbSize,
      thumbDecoration: thumbDecoration ?? other.thumbDecoration,
      indicator: indicator ?? other.indicator,
      indeterminateIndicator:
          indeterminateIndicator ?? other.indeterminateIndicator,
      padding: padding ?? other.padding,
      tapTargetSize: tapTargetSize ?? other.tapTargetSize,
      mouseCursor: mouseCursor ?? other.mouseCursor,
      animationDuration: animationDuration ?? other.animationDuration,
      animationCurve: animationCurve ?? other.animationCurve,
      enableFeedback: enableFeedback ?? other.enableFeedback,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ToggleStyle &&
            size == other.size &&
            decoration == other.decoration &&
            thumbSize == other.thumbSize &&
            thumbDecoration == other.thumbDecoration &&
            indicator == other.indicator &&
            indeterminateIndicator == other.indeterminateIndicator &&
            padding == other.padding &&
            tapTargetSize == other.tapTargetSize &&
            mouseCursor == other.mouseCursor &&
            animationDuration == other.animationDuration &&
            animationCurve == other.animationCurve &&
            enableFeedback == other.enableFeedback;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    size,
    decoration,
    thumbSize,
    thumbDecoration,
    indicator,
    indeterminateIndicator,
    padding,
    tapTargetSize,
    mouseCursor,
    animationDuration,
    animationCurve,
    enableFeedback,
  ]);

  @override
  String toString() =>
      'ToggleStyle(size: $size, decoration: $decoration, thumbSize: $thumbSize, thumbDecoration: $thumbDecoration, indicator: $indicator, indeterminateIndicator: $indeterminateIndicator, padding: $padding, tapTargetSize: $tapTargetSize, mouseCursor: $mouseCursor, animationDuration: $animationDuration, animationCurve: $animationCurve, enableFeedback: $enableFeedback)';
}
