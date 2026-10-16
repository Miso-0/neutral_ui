import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';

/// Nullable appearance and motion tokens.
@immutable
class BadgeStyle {
  /// Creates badge style.
  const BadgeStyle({
    this.decoration,
    this.textStyle,
    this.padding,
    this.smallSize,
    this.largeSize,
    this.alignment,
    this.offset,
    this.animationDuration,
    this.animationCurve,
  });

  /// The decoration token.
  final StateProperty<Decoration?>? decoration;

  /// The text style token.
  final StateProperty<TextStyle?>? textStyle;

  /// The padding token.
  final EdgeInsetsGeometry? padding;

  /// The small size token.
  final double? smallSize;

  /// The large size token.
  final double? largeSize;

  /// The alignment token.
  final AlignmentGeometry? alignment;

  /// The current page displacement from the selected index.
  final Offset? offset;

  /// The animation duration token.
  final Duration? animationDuration;

  /// The animation curve token.
  final Curve? animationCurve;

  /// Returns a copy with the supplied non-null tokens replaced.
  BadgeStyle copyWith({
    StateProperty<Decoration?>? decoration,
    StateProperty<TextStyle?>? textStyle,
    EdgeInsetsGeometry? padding,
    double? smallSize,
    double? largeSize,
    AlignmentGeometry? alignment,
    Offset? offset,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => BadgeStyle(
    decoration: decoration ?? this.decoration,
    textStyle: textStyle ?? this.textStyle,
    padding: padding ?? this.padding,
    smallSize: smallSize ?? this.smallSize,
    largeSize: largeSize ?? this.largeSize,
    alignment: alignment ?? this.alignment,
    offset: offset ?? this.offset,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
  );

  /// Inherits unset tokens while retaining this style's values.
  BadgeStyle merge(BadgeStyle? other) => other == null
      ? this
      : BadgeStyle(
          decoration: decoration ?? other.decoration,
          textStyle: textStyle ?? other.textStyle,
          padding: padding ?? other.padding,
          smallSize: smallSize ?? other.smallSize,
          largeSize: largeSize ?? other.largeSize,
          alignment: alignment ?? other.alignment,
          offset: offset ?? other.offset,
          animationDuration: animationDuration ?? other.animationDuration,
          animationCurve: animationCurve ?? other.animationCurve,
        );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeStyle &&
          decoration == other.decoration &&
          textStyle == other.textStyle &&
          padding == other.padding &&
          smallSize == other.smallSize &&
          largeSize == other.largeSize &&
          alignment == other.alignment &&
          offset == other.offset &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve;
  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    textStyle,
    padding,
    smallSize,
    largeSize,
    alignment,
    offset,
    animationDuration,
    animationCurve,
  ]);
  @override
  String toString() =>
      'BadgeStyle(decoration: $decoration, textStyle: $textStyle, padding: $padding, smallSize: $smallSize, largeSize: $largeSize, alignment: $alignment, offset: $offset, animationDuration: $animationDuration, animationCurve: $animationCurve)';
}
