import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';

/// Nullable appearance and motion tokens.
@immutable
class ProgressIndicatorStyle {
  /// Creates progress indicator style.
  const ProgressIndicatorStyle({
    this.color,
    this.backgroundColor,
    this.strokeWidth,
    this.strokeCap,
    this.minHeight,
    this.size,
    this.borderRadius,
    this.animationDuration,
    this.animationCurve,
    this.indeterminateDuration,
  });

  /// The color token.
  final StateProperty<Color?>? color;

  /// The background color token.
  final StateProperty<Color?>? backgroundColor;

  /// The stroke width token.
  final double? strokeWidth;

  /// The stroke cap token.
  final StrokeCap? strokeCap;

  /// The min height token.
  final double? minHeight;

  /// The size token.
  final Size? size;

  /// The border radius token.
  final BorderRadiusGeometry? borderRadius;

  /// The animation duration token.
  final Duration? animationDuration;

  /// The animation curve token.
  final Curve? animationCurve;

  /// The indeterminate duration token.
  final Duration? indeterminateDuration;

  /// Returns a copy with the supplied non-null tokens replaced.
  ProgressIndicatorStyle copyWith({
    StateProperty<Color?>? color,
    StateProperty<Color?>? backgroundColor,
    double? strokeWidth,
    StrokeCap? strokeCap,
    double? minHeight,
    Size? size,
    BorderRadiusGeometry? borderRadius,
    Duration? animationDuration,
    Curve? animationCurve,
    Duration? indeterminateDuration,
  }) => ProgressIndicatorStyle(
    color: color ?? this.color,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    strokeWidth: strokeWidth ?? this.strokeWidth,
    strokeCap: strokeCap ?? this.strokeCap,
    minHeight: minHeight ?? this.minHeight,
    size: size ?? this.size,
    borderRadius: borderRadius ?? this.borderRadius,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
    indeterminateDuration: indeterminateDuration ?? this.indeterminateDuration,
  );

  /// Inherits unset tokens while retaining this style's values.
  ProgressIndicatorStyle merge(ProgressIndicatorStyle? other) => other == null
      ? this
      : ProgressIndicatorStyle(
          color: color ?? other.color,
          backgroundColor: backgroundColor ?? other.backgroundColor,
          strokeWidth: strokeWidth ?? other.strokeWidth,
          strokeCap: strokeCap ?? other.strokeCap,
          minHeight: minHeight ?? other.minHeight,
          size: size ?? other.size,
          borderRadius: borderRadius ?? other.borderRadius,
          animationDuration: animationDuration ?? other.animationDuration,
          animationCurve: animationCurve ?? other.animationCurve,
          indeterminateDuration:
              indeterminateDuration ?? other.indeterminateDuration,
        );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressIndicatorStyle &&
          color == other.color &&
          backgroundColor == other.backgroundColor &&
          strokeWidth == other.strokeWidth &&
          strokeCap == other.strokeCap &&
          minHeight == other.minHeight &&
          size == other.size &&
          borderRadius == other.borderRadius &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve &&
          indeterminateDuration == other.indeterminateDuration;
  @override
  int get hashCode => Object.hashAll(<Object?>[
    color,
    backgroundColor,
    strokeWidth,
    strokeCap,
    minHeight,
    size,
    borderRadius,
    animationDuration,
    animationCurve,
    indeterminateDuration,
  ]);
  @override
  String toString() =>
      'ProgressIndicatorStyle(color: $color, backgroundColor: $backgroundColor, strokeWidth: $strokeWidth, strokeCap: $strokeCap, minHeight: $minHeight, size: $size, borderRadius: $borderRadius, animationDuration: $animationDuration, animationCurve: $animationCurve, indeterminateDuration: $indeterminateDuration)';
}
