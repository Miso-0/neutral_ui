import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';
import 'list_tile_style.dart';

/// Nullable appearance and motion tokens.
@immutable
class ExpansionTileStyle {
  /// Creates expansion tile style.
  const ExpansionTileStyle({
    this.tileStyle,
    this.decoration,
    this.padding,
    this.childrenPadding,
    this.expandedAlignment,
    this.expandedCrossAxisAlignment,
    this.animationDuration,
    this.animationCurve,
  });

  /// The tile style token.
  final ListTileStyle? tileStyle;

  /// The decoration token.
  final StateProperty<Decoration?>? decoration;

  /// The padding token.
  final EdgeInsetsGeometry? padding;

  /// The children padding token.
  final EdgeInsetsGeometry? childrenPadding;

  /// The expanded alignment token.
  final AlignmentGeometry? expandedAlignment;

  /// The expanded cross axis alignment token.
  final CrossAxisAlignment? expandedCrossAxisAlignment;

  /// The animation duration token.
  final Duration? animationDuration;

  /// The animation curve token.
  final Curve? animationCurve;

  /// Returns a copy with the supplied non-null tokens replaced.
  ExpansionTileStyle copyWith({
    ListTileStyle? tileStyle,
    StateProperty<Decoration?>? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? childrenPadding,
    AlignmentGeometry? expandedAlignment,
    CrossAxisAlignment? expandedCrossAxisAlignment,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => ExpansionTileStyle(
    tileStyle: tileStyle ?? this.tileStyle,
    decoration: decoration ?? this.decoration,
    padding: padding ?? this.padding,
    childrenPadding: childrenPadding ?? this.childrenPadding,
    expandedAlignment: expandedAlignment ?? this.expandedAlignment,
    expandedCrossAxisAlignment:
        expandedCrossAxisAlignment ?? this.expandedCrossAxisAlignment,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
  );

  /// Inherits unset tokens while retaining this style's values.
  ExpansionTileStyle merge(ExpansionTileStyle? other) => other == null
      ? this
      : ExpansionTileStyle(
          tileStyle: tileStyle?.merge(other.tileStyle) ?? other.tileStyle,
          decoration: decoration ?? other.decoration,
          padding: padding ?? other.padding,
          childrenPadding: childrenPadding ?? other.childrenPadding,
          expandedAlignment: expandedAlignment ?? other.expandedAlignment,
          expandedCrossAxisAlignment:
              expandedCrossAxisAlignment ?? other.expandedCrossAxisAlignment,
          animationDuration: animationDuration ?? other.animationDuration,
          animationCurve: animationCurve ?? other.animationCurve,
        );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpansionTileStyle &&
          tileStyle == other.tileStyle &&
          decoration == other.decoration &&
          padding == other.padding &&
          childrenPadding == other.childrenPadding &&
          expandedAlignment == other.expandedAlignment &&
          expandedCrossAxisAlignment == other.expandedCrossAxisAlignment &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve;
  @override
  int get hashCode => Object.hashAll(<Object?>[
    tileStyle,
    decoration,
    padding,
    childrenPadding,
    expandedAlignment,
    expandedCrossAxisAlignment,
    animationDuration,
    animationCurve,
  ]);
  @override
  String toString() =>
      'ExpansionTileStyle(tileStyle: $tileStyle, decoration: $decoration, padding: $padding, childrenPadding: $childrenPadding, expandedAlignment: $expandedAlignment, expandedCrossAxisAlignment: $expandedCrossAxisAlignment, animationDuration: $animationDuration, animationCurve: $animationCurve)';
}
