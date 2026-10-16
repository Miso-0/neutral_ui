import 'package:flutter/widgets.dart';

import 'text_field_style.dart';
import 'menu_style.dart';
import 'button_style.dart';
import '../overlay/overlay_behavior.dart';
import '../overlay/overlay_transition.dart';

/// Optional appearance and motion tokens for Search.
@immutable
class SearchStyle {
  /// Creates inherited component tokens.
  const SearchStyle({
    this.fieldStyle,
    this.viewDecoration,
    this.viewPadding,
    this.suggestionStyle,
    this.menuStyle,
    this.constraints,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.transitionCurve,
    this.reverseTransitionCurve,
    this.transitionBuilder,
    this.outsideTapBehavior,
  });

  /// The fieldStyle token.
  final TextFieldStyle? fieldStyle;

  /// The viewDecoration token.
  final Decoration? viewDecoration;

  /// The viewPadding token.
  final EdgeInsetsGeometry? viewPadding;

  /// The suggestionStyle token.
  final ButtonStyle? suggestionStyle;

  /// The menuStyle token.
  final MenuStyle? menuStyle;

  /// The constraints token.
  final BoxConstraints? constraints;

  /// The transitionDuration token.
  final Duration? transitionDuration;

  /// The reverseTransitionDuration token.
  final Duration? reverseTransitionDuration;

  /// The transitionCurve token.
  final Curve? transitionCurve;

  /// The reverseTransitionCurve token.
  final Curve? reverseTransitionCurve;

  /// The transitionBuilder token.
  final OverlayTransitionBuilder? transitionBuilder;

  /// The outsideTapBehavior token.
  final OutsideTapBehavior? outsideTapBehavior;

  /// Replaces the supplied non-null tokens.
  SearchStyle copyWith({
    TextFieldStyle? fieldStyle,
    Decoration? viewDecoration,
    EdgeInsetsGeometry? viewPadding,
    ButtonStyle? suggestionStyle,
    MenuStyle? menuStyle,
    BoxConstraints? constraints,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Curve? transitionCurve,
    Curve? reverseTransitionCurve,
    OverlayTransitionBuilder? transitionBuilder,
    OutsideTapBehavior? outsideTapBehavior,
  }) => SearchStyle(
    fieldStyle: fieldStyle ?? this.fieldStyle,
    viewDecoration: viewDecoration ?? this.viewDecoration,
    viewPadding: viewPadding ?? this.viewPadding,
    suggestionStyle: suggestionStyle ?? this.suggestionStyle,
    menuStyle: menuStyle ?? this.menuStyle,
    constraints: constraints ?? this.constraints,
    transitionDuration: transitionDuration ?? this.transitionDuration,
    reverseTransitionDuration:
        reverseTransitionDuration ?? this.reverseTransitionDuration,
    transitionCurve: transitionCurve ?? this.transitionCurve,
    reverseTransitionCurve:
        reverseTransitionCurve ?? this.reverseTransitionCurve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
    outsideTapBehavior: outsideTapBehavior ?? this.outsideTapBehavior,
  );

  /// Inherits unset tokens while retaining this style's values.
  SearchStyle merge(SearchStyle? other) {
    if (other == null) return this;
    return SearchStyle(
      fieldStyle: fieldStyle?.merge(other.fieldStyle) ?? other.fieldStyle,
      viewDecoration: viewDecoration ?? other.viewDecoration,
      viewPadding: viewPadding ?? other.viewPadding,
      suggestionStyle:
          suggestionStyle?.merge(other.suggestionStyle) ??
          other.suggestionStyle,
      menuStyle: menuStyle?.merge(other.menuStyle) ?? other.menuStyle,
      constraints: constraints ?? other.constraints,
      transitionDuration: transitionDuration ?? other.transitionDuration,
      reverseTransitionDuration:
          reverseTransitionDuration ?? other.reverseTransitionDuration,
      transitionCurve: transitionCurve ?? other.transitionCurve,
      reverseTransitionCurve:
          reverseTransitionCurve ?? other.reverseTransitionCurve,
      transitionBuilder: transitionBuilder ?? other.transitionBuilder,
      outsideTapBehavior: outsideTapBehavior ?? other.outsideTapBehavior,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchStyle &&
          fieldStyle == other.fieldStyle &&
          viewDecoration == other.viewDecoration &&
          viewPadding == other.viewPadding &&
          suggestionStyle == other.suggestionStyle &&
          menuStyle == other.menuStyle &&
          constraints == other.constraints &&
          transitionDuration == other.transitionDuration &&
          reverseTransitionDuration == other.reverseTransitionDuration &&
          transitionCurve == other.transitionCurve &&
          reverseTransitionCurve == other.reverseTransitionCurve &&
          transitionBuilder == other.transitionBuilder &&
          outsideTapBehavior == other.outsideTapBehavior;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    fieldStyle,
    viewDecoration,
    viewPadding,
    suggestionStyle,
    menuStyle,
    constraints,
    transitionDuration,
    reverseTransitionDuration,
    transitionCurve,
    reverseTransitionCurve,
    transitionBuilder,
    outsideTapBehavior,
  ]);

  @override
  String toString() =>
      'SearchStyle(fieldStyle: $fieldStyle, viewDecoration: $viewDecoration, viewPadding: $viewPadding, suggestionStyle: $suggestionStyle, menuStyle: $menuStyle, constraints: $constraints, transitionDuration: $transitionDuration, reverseTransitionDuration: $reverseTransitionDuration, transitionCurve: $transitionCurve, reverseTransitionCurve: $reverseTransitionCurve, transitionBuilder: $transitionBuilder, outsideTapBehavior: $outsideTapBehavior)';
}
