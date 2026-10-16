import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';
import 'button_style.dart';

/// Nullable appearance and motion tokens.
@immutable
class NavigationStyle {
  /// Creates navigation style.
  const NavigationStyle({
    this.destinationStyle,
    this.indicatorDecoration,
    this.labelStyle,
    this.iconTheme,
    this.padding,
    this.indicatorPadding,
    this.indicatorSize,
    this.spacing,
    this.animationDuration,
    this.animationCurve,
  });

  /// The destination style token.
  final ButtonStyle? destinationStyle;

  /// The indicator decoration token.
  final StateProperty<Decoration?>? indicatorDecoration;

  /// The label style token.
  final StateProperty<TextStyle?>? labelStyle;

  /// The icon theme token.
  final StateProperty<IconThemeData?>? iconTheme;

  /// The padding token.
  final EdgeInsetsGeometry? padding;

  /// The indicator padding token.
  final EdgeInsetsGeometry? indicatorPadding;

  /// The indicator size token.
  final Size? indicatorSize;

  /// The spacing token.
  final double? spacing;

  /// The animation duration token.
  final Duration? animationDuration;

  /// The animation curve token.
  final Curve? animationCurve;

  /// Creates navigation style copy with.
  NavigationStyle copyWith({
    ButtonStyle? destinationStyle,
    StateProperty<Decoration?>? indicatorDecoration,
    StateProperty<TextStyle?>? labelStyle,
    StateProperty<IconThemeData?>? iconTheme,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? indicatorPadding,
    Size? indicatorSize,
    double? spacing,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => NavigationStyle(
    destinationStyle: destinationStyle ?? this.destinationStyle,
    indicatorDecoration: indicatorDecoration ?? this.indicatorDecoration,
    labelStyle: labelStyle ?? this.labelStyle,
    iconTheme: iconTheme ?? this.iconTheme,
    padding: padding ?? this.padding,
    indicatorPadding: indicatorPadding ?? this.indicatorPadding,
    indicatorSize: indicatorSize ?? this.indicatorSize,
    spacing: spacing ?? this.spacing,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
  );

  /// Creates navigation style merge.
  NavigationStyle merge(NavigationStyle? other) => other == null
      ? this
      : NavigationStyle(
          destinationStyle:
              destinationStyle?.merge(other.destinationStyle) ??
              other.destinationStyle,
          indicatorDecoration: indicatorDecoration ?? other.indicatorDecoration,
          labelStyle: labelStyle ?? other.labelStyle,
          iconTheme: iconTheme ?? other.iconTheme,
          padding: padding ?? other.padding,
          indicatorPadding: indicatorPadding ?? other.indicatorPadding,
          indicatorSize: indicatorSize ?? other.indicatorSize,
          spacing: spacing ?? other.spacing,
          animationDuration: animationDuration ?? other.animationDuration,
          animationCurve: animationCurve ?? other.animationCurve,
        );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationStyle &&
          destinationStyle == other.destinationStyle &&
          indicatorDecoration == other.indicatorDecoration &&
          labelStyle == other.labelStyle &&
          iconTheme == other.iconTheme &&
          padding == other.padding &&
          indicatorPadding == other.indicatorPadding &&
          indicatorSize == other.indicatorSize &&
          spacing == other.spacing &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve;
  @override
  int get hashCode => Object.hashAll(<Object?>[
    destinationStyle,
    indicatorDecoration,
    labelStyle,
    iconTheme,
    padding,
    indicatorPadding,
    indicatorSize,
    spacing,
    animationDuration,
    animationCurve,
  ]);
  @override
  String toString() =>
      'NavigationStyle(destinationStyle: $destinationStyle, indicatorDecoration: $indicatorDecoration, labelStyle: $labelStyle, iconTheme: $iconTheme, padding: $padding, indicatorPadding: $indicatorPadding, indicatorSize: $indicatorSize, spacing: $spacing, animationDuration: $animationDuration, animationCurve: $animationCurve)';
}
