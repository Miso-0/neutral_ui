import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';
import 'button_style.dart';

/// Builds the indicator within its interpolated tab bounds.
typedef TabIndicatorBuilder = Widget Function(
  BuildContext context,
  double position,
);

/// Nullable appearance and motion tokens.
@immutable
class TabBarStyle {
  /// Creates tab bar style.
  const TabBarStyle({
    this.tabStyle,
    this.indicatorDecoration,
    this.indicatorBuilder,
    this.labelPadding,
    this.padding,
    this.indicatorPadding,
    this.indicatorWeight,
    this.spacing,
    this.animationDuration,
    this.animationCurve,
  });

  /// The tab style token.
  final ButtonStyle? tabStyle;

  /// The indicator decoration token.
  final StateProperty<Decoration?>? indicatorDecoration;

  /// The indicator builder token.
  final TabIndicatorBuilder? indicatorBuilder;

  /// The label padding token.
  final EdgeInsetsGeometry? labelPadding;

  /// The padding token.
  final EdgeInsetsGeometry? padding;

  /// The indicator padding token.
  final EdgeInsetsGeometry? indicatorPadding;

  /// The indicator weight token.
  final double? indicatorWeight;

  /// The spacing token.
  final double? spacing;

  /// The animation duration token.
  final Duration? animationDuration;

  /// The animation curve token.
  final Curve? animationCurve;

  /// Returns a copy with the supplied non-null tokens replaced.
  TabBarStyle copyWith({
    ButtonStyle? tabStyle,
    StateProperty<Decoration?>? indicatorDecoration,
    TabIndicatorBuilder? indicatorBuilder,
    EdgeInsetsGeometry? labelPadding,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? indicatorPadding,
    double? indicatorWeight,
    double? spacing,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => TabBarStyle(
    tabStyle: tabStyle ?? this.tabStyle,
    indicatorDecoration: indicatorDecoration ?? this.indicatorDecoration,
    indicatorBuilder: indicatorBuilder ?? this.indicatorBuilder,
    labelPadding: labelPadding ?? this.labelPadding,
    padding: padding ?? this.padding,
    indicatorPadding: indicatorPadding ?? this.indicatorPadding,
    indicatorWeight: indicatorWeight ?? this.indicatorWeight,
    spacing: spacing ?? this.spacing,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
  );

  /// Inherits unset tokens while retaining this style's values.
  TabBarStyle merge(TabBarStyle? other) => other == null
      ? this
      : TabBarStyle(
          tabStyle: tabStyle?.merge(other.tabStyle) ?? other.tabStyle,
          indicatorDecoration: indicatorDecoration ?? other.indicatorDecoration,
          indicatorBuilder: indicatorBuilder ?? other.indicatorBuilder,
          labelPadding: labelPadding ?? other.labelPadding,
          padding: padding ?? other.padding,
          indicatorPadding: indicatorPadding ?? other.indicatorPadding,
          indicatorWeight: indicatorWeight ?? other.indicatorWeight,
          spacing: spacing ?? other.spacing,
          animationDuration: animationDuration ?? other.animationDuration,
          animationCurve: animationCurve ?? other.animationCurve,
        );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabBarStyle &&
          tabStyle == other.tabStyle &&
          indicatorDecoration == other.indicatorDecoration &&
          indicatorBuilder == other.indicatorBuilder &&
          labelPadding == other.labelPadding &&
          padding == other.padding &&
          indicatorPadding == other.indicatorPadding &&
          indicatorWeight == other.indicatorWeight &&
          spacing == other.spacing &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve;
  @override
  int get hashCode => Object.hashAll(<Object?>[
    tabStyle,
    indicatorDecoration,
    indicatorBuilder,
    labelPadding,
    padding,
    indicatorPadding,
    indicatorWeight,
    spacing,
    animationDuration,
    animationCurve,
  ]);
  @override
  String toString() =>
      'TabBarStyle(tabStyle: $tabStyle, indicatorDecoration: $indicatorDecoration, indicatorBuilder: $indicatorBuilder, labelPadding: $labelPadding, padding: $padding, indicatorPadding: $indicatorPadding, indicatorWeight: $indicatorWeight, spacing: $spacing, animationDuration: $animationDuration, animationCurve: $animationCurve)';
}
