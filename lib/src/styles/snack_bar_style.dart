import 'package:flutter/widgets.dart';

import '../feedback/feedback_transition.dart';
import 'button_style.dart';

/// Optional appearance and motion tokens for snackbar components.
@immutable
class SnackBarStyle {
  /// Creates inheritable component tokens.
  const SnackBarStyle({
    this.decoration,
    this.padding,
    this.margin,
    this.constraints,
    this.textStyle,
    this.actionStyle,
    this.closeButtonStyle,
    this.spacing,
    this.alignment,
    this.clipBehavior,
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

  /// The actionStyle token. Null inherits from the enclosing style.
  final ButtonStyle? actionStyle;

  /// The closeButtonStyle token. Null inherits from the enclosing style.
  final ButtonStyle? closeButtonStyle;

  /// The spacing token. Null inherits from the enclosing style.
  final double? spacing;

  /// The alignment token. Null inherits from the enclosing style.
  final AlignmentGeometry? alignment;

  /// The clipBehavior token. Null inherits from the enclosing style.
  final Clip? clipBehavior;

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
  SnackBarStyle copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxConstraints? constraints,
    TextStyle? textStyle,
    ButtonStyle? actionStyle,
    ButtonStyle? closeButtonStyle,
    double? spacing,
    AlignmentGeometry? alignment,
    Clip? clipBehavior,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Curve? transitionCurve,
    Curve? reverseTransitionCurve,
    FeedbackTransitionBuilder? transitionBuilder,
  }) => SnackBarStyle(
    decoration: decoration ?? this.decoration,
    padding: padding ?? this.padding,
    margin: margin ?? this.margin,
    constraints: constraints ?? this.constraints,
    textStyle: textStyle ?? this.textStyle,
    actionStyle: actionStyle ?? this.actionStyle,
    closeButtonStyle: closeButtonStyle ?? this.closeButtonStyle,
    spacing: spacing ?? this.spacing,
    alignment: alignment ?? this.alignment,
    clipBehavior: clipBehavior ?? this.clipBehavior,
    transitionDuration: transitionDuration ?? this.transitionDuration,
    reverseTransitionDuration:
        reverseTransitionDuration ?? this.reverseTransitionDuration,
    transitionCurve: transitionCurve ?? this.transitionCurve,
    reverseTransitionCurve:
        reverseTransitionCurve ?? this.reverseTransitionCurve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );

  /// Fills unset tokens from [other], preserving this style.
  SnackBarStyle merge(SnackBarStyle? other) {
    if (other == null) return this;
    return SnackBarStyle(
      decoration: decoration ?? other.decoration,
      padding: padding ?? other.padding,
      margin: margin ?? other.margin,
      constraints: constraints ?? other.constraints,
      textStyle: textStyle ?? other.textStyle,
      actionStyle: actionStyle?.merge(other.actionStyle) ?? other.actionStyle,
      closeButtonStyle:
          closeButtonStyle?.merge(other.closeButtonStyle) ??
          other.closeButtonStyle,
      spacing: spacing ?? other.spacing,
      alignment: alignment ?? other.alignment,
      clipBehavior: clipBehavior ?? other.clipBehavior,
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
      other is SnackBarStyle &&
          decoration == other.decoration &&
          padding == other.padding &&
          margin == other.margin &&
          constraints == other.constraints &&
          textStyle == other.textStyle &&
          actionStyle == other.actionStyle &&
          closeButtonStyle == other.closeButtonStyle &&
          spacing == other.spacing &&
          alignment == other.alignment &&
          clipBehavior == other.clipBehavior &&
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
    actionStyle,
    closeButtonStyle,
    spacing,
    alignment,
    clipBehavior,
    transitionDuration,
    reverseTransitionDuration,
    transitionCurve,
    reverseTransitionCurve,
    transitionBuilder,
  ]);

  @override
  String toString() =>
      'SnackBarStyle(decoration: $decoration, padding: $padding, margin: $margin, constraints: $constraints, textStyle: $textStyle, actionStyle: $actionStyle, closeButtonStyle: $closeButtonStyle, spacing: $spacing, alignment: $alignment, clipBehavior: $clipBehavior, transitionDuration: $transitionDuration, reverseTransitionDuration: $reverseTransitionDuration, transitionCurve: $transitionCurve, reverseTransitionCurve: $reverseTransitionCurve, transitionBuilder: $transitionBuilder)';
}
