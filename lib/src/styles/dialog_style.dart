import 'package:flutter/widgets.dart';

import '../feedback/feedback_transition.dart';
import 'button_style.dart';

/// Optional appearance and motion tokens for dialog components.
@immutable
class DialogStyle {
  /// Creates inheritable component tokens.
  const DialogStyle({
    this.decoration,
    this.padding,
    this.insetPadding,
    this.constraints,
    this.alignment,
    this.barrierColor,
    this.barrierBlur,
    this.clipBehavior,
    this.titleTextStyle,
    this.contentTextStyle,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
    this.actionsAlignment,
    this.actionsOverflowAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.iconPadding,
    this.iconTheme,
    this.optionStyle,
    this.insetAnimationDuration,
    this.insetAnimationCurve,
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

  /// The insetPadding token. Null inherits from the enclosing style.
  final EdgeInsetsGeometry? insetPadding;

  /// The constraints token. Null inherits from the enclosing style.
  final BoxConstraints? constraints;

  /// The alignment token. Null inherits from the enclosing style.
  final AlignmentGeometry? alignment;

  /// The barrierColor token. Null inherits from the enclosing style.
  final Color? barrierColor;

  /// The barrierBlur token. Null inherits from the enclosing style.
  final ImageFilterConfig? barrierBlur;

  /// The clipBehavior token. Null inherits from the enclosing style.
  final Clip? clipBehavior;

  /// The titleTextStyle token. Null inherits from the enclosing style.
  final TextStyle? titleTextStyle;

  /// The contentTextStyle token. Null inherits from the enclosing style.
  final TextStyle? contentTextStyle;

  /// The titlePadding token. Null inherits from the enclosing style.
  final EdgeInsetsGeometry? titlePadding;

  /// The contentPadding token. Null inherits from the enclosing style.
  final EdgeInsetsGeometry? contentPadding;

  /// The actionsPadding token. Null inherits from the enclosing style.
  final EdgeInsetsGeometry? actionsPadding;

  /// The actionsAlignment token. Null inherits from the enclosing style.
  final MainAxisAlignment? actionsAlignment;

  /// The actionsOverflowAlignment token. Null inherits from the enclosing style.
  final OverflowBarAlignment? actionsOverflowAlignment;

  /// The actionsOverflowDirection token. Null inherits from the enclosing style.
  final VerticalDirection? actionsOverflowDirection;

  /// The actionsOverflowButtonSpacing token. Null inherits from the enclosing style.
  final double? actionsOverflowButtonSpacing;

  /// The buttonPadding token. Null inherits from the enclosing style.
  final EdgeInsetsGeometry? buttonPadding;

  /// The iconPadding token. Null inherits from the enclosing style.
  final EdgeInsetsGeometry? iconPadding;

  /// The iconTheme token. Null inherits from the enclosing style.
  final IconThemeData? iconTheme;

  /// The optionStyle token. Null inherits from the enclosing style.
  final ButtonStyle? optionStyle;

  /// The insetAnimationDuration token. Null inherits from the enclosing style.
  final Duration? insetAnimationDuration;

  /// The insetAnimationCurve token. Null inherits from the enclosing style.
  final Curve? insetAnimationCurve;

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
  DialogStyle copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? insetPadding,
    BoxConstraints? constraints,
    AlignmentGeometry? alignment,
    Color? barrierColor,
    ImageFilterConfig? barrierBlur,
    Clip? clipBehavior,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    EdgeInsetsGeometry? titlePadding,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    MainAxisAlignment? actionsAlignment,
    OverflowBarAlignment? actionsOverflowAlignment,
    VerticalDirection? actionsOverflowDirection,
    double? actionsOverflowButtonSpacing,
    EdgeInsetsGeometry? buttonPadding,
    EdgeInsetsGeometry? iconPadding,
    IconThemeData? iconTheme,
    ButtonStyle? optionStyle,
    Duration? insetAnimationDuration,
    Curve? insetAnimationCurve,
    Duration? transitionDuration,
    Duration? reverseTransitionDuration,
    Curve? transitionCurve,
    Curve? reverseTransitionCurve,
    FeedbackTransitionBuilder? transitionBuilder,
  }) => DialogStyle(
    decoration: decoration ?? this.decoration,
    padding: padding ?? this.padding,
    insetPadding: insetPadding ?? this.insetPadding,
    constraints: constraints ?? this.constraints,
    alignment: alignment ?? this.alignment,
    barrierColor: barrierColor ?? this.barrierColor,
    barrierBlur: barrierBlur ?? this.barrierBlur,
    clipBehavior: clipBehavior ?? this.clipBehavior,
    titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    contentTextStyle: contentTextStyle ?? this.contentTextStyle,
    titlePadding: titlePadding ?? this.titlePadding,
    contentPadding: contentPadding ?? this.contentPadding,
    actionsPadding: actionsPadding ?? this.actionsPadding,
    actionsAlignment: actionsAlignment ?? this.actionsAlignment,
    actionsOverflowAlignment:
        actionsOverflowAlignment ?? this.actionsOverflowAlignment,
    actionsOverflowDirection:
        actionsOverflowDirection ?? this.actionsOverflowDirection,
    actionsOverflowButtonSpacing:
        actionsOverflowButtonSpacing ?? this.actionsOverflowButtonSpacing,
    buttonPadding: buttonPadding ?? this.buttonPadding,
    iconPadding: iconPadding ?? this.iconPadding,
    iconTheme: iconTheme ?? this.iconTheme,
    optionStyle: optionStyle ?? this.optionStyle,
    insetAnimationDuration:
        insetAnimationDuration ?? this.insetAnimationDuration,
    insetAnimationCurve: insetAnimationCurve ?? this.insetAnimationCurve,
    transitionDuration: transitionDuration ?? this.transitionDuration,
    reverseTransitionDuration:
        reverseTransitionDuration ?? this.reverseTransitionDuration,
    transitionCurve: transitionCurve ?? this.transitionCurve,
    reverseTransitionCurve:
        reverseTransitionCurve ?? this.reverseTransitionCurve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );

  /// Fills unset tokens from [other], preserving this style.
  DialogStyle merge(DialogStyle? other) {
    if (other == null) return this;
    return DialogStyle(
      decoration: decoration ?? other.decoration,
      padding: padding ?? other.padding,
      insetPadding: insetPadding ?? other.insetPadding,
      constraints: constraints ?? other.constraints,
      alignment: alignment ?? other.alignment,
      barrierColor: barrierColor ?? other.barrierColor,
      barrierBlur: barrierBlur ?? other.barrierBlur,
      clipBehavior: clipBehavior ?? other.clipBehavior,
      titleTextStyle: titleTextStyle ?? other.titleTextStyle,
      contentTextStyle: contentTextStyle ?? other.contentTextStyle,
      titlePadding: titlePadding ?? other.titlePadding,
      contentPadding: contentPadding ?? other.contentPadding,
      actionsPadding: actionsPadding ?? other.actionsPadding,
      actionsAlignment: actionsAlignment ?? other.actionsAlignment,
      actionsOverflowAlignment:
          actionsOverflowAlignment ?? other.actionsOverflowAlignment,
      actionsOverflowDirection:
          actionsOverflowDirection ?? other.actionsOverflowDirection,
      actionsOverflowButtonSpacing:
          actionsOverflowButtonSpacing ?? other.actionsOverflowButtonSpacing,
      buttonPadding: buttonPadding ?? other.buttonPadding,
      iconPadding: iconPadding ?? other.iconPadding,
      iconTheme: iconTheme ?? other.iconTheme,
      optionStyle: optionStyle?.merge(other.optionStyle) ?? other.optionStyle,
      insetAnimationDuration:
          insetAnimationDuration ?? other.insetAnimationDuration,
      insetAnimationCurve: insetAnimationCurve ?? other.insetAnimationCurve,
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
      other is DialogStyle &&
          decoration == other.decoration &&
          padding == other.padding &&
          insetPadding == other.insetPadding &&
          constraints == other.constraints &&
          alignment == other.alignment &&
          barrierColor == other.barrierColor &&
          barrierBlur == other.barrierBlur &&
          clipBehavior == other.clipBehavior &&
          titleTextStyle == other.titleTextStyle &&
          contentTextStyle == other.contentTextStyle &&
          titlePadding == other.titlePadding &&
          contentPadding == other.contentPadding &&
          actionsPadding == other.actionsPadding &&
          actionsAlignment == other.actionsAlignment &&
          actionsOverflowAlignment == other.actionsOverflowAlignment &&
          actionsOverflowDirection == other.actionsOverflowDirection &&
          actionsOverflowButtonSpacing == other.actionsOverflowButtonSpacing &&
          buttonPadding == other.buttonPadding &&
          iconPadding == other.iconPadding &&
          iconTheme == other.iconTheme &&
          optionStyle == other.optionStyle &&
          insetAnimationDuration == other.insetAnimationDuration &&
          insetAnimationCurve == other.insetAnimationCurve &&
          transitionDuration == other.transitionDuration &&
          reverseTransitionDuration == other.reverseTransitionDuration &&
          transitionCurve == other.transitionCurve &&
          reverseTransitionCurve == other.reverseTransitionCurve &&
          transitionBuilder == other.transitionBuilder;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    padding,
    insetPadding,
    constraints,
    alignment,
    barrierColor,
    barrierBlur,
    clipBehavior,
    titleTextStyle,
    contentTextStyle,
    titlePadding,
    contentPadding,
    actionsPadding,
    actionsAlignment,
    actionsOverflowAlignment,
    actionsOverflowDirection,
    actionsOverflowButtonSpacing,
    buttonPadding,
    iconPadding,
    iconTheme,
    optionStyle,
    insetAnimationDuration,
    insetAnimationCurve,
    transitionDuration,
    reverseTransitionDuration,
    transitionCurve,
    reverseTransitionCurve,
    transitionBuilder,
  ]);

  @override
  String toString() =>
      'DialogStyle(decoration: $decoration, padding: $padding, insetPadding: $insetPadding, constraints: $constraints, alignment: $alignment, barrierColor: $barrierColor, barrierBlur: $barrierBlur, clipBehavior: $clipBehavior, titleTextStyle: $titleTextStyle, contentTextStyle: $contentTextStyle, titlePadding: $titlePadding, contentPadding: $contentPadding, actionsPadding: $actionsPadding, actionsAlignment: $actionsAlignment, actionsOverflowAlignment: $actionsOverflowAlignment, actionsOverflowDirection: $actionsOverflowDirection, actionsOverflowButtonSpacing: $actionsOverflowButtonSpacing, buttonPadding: $buttonPadding, iconPadding: $iconPadding, iconTheme: $iconTheme, optionStyle: $optionStyle, insetAnimationDuration: $insetAnimationDuration, insetAnimationCurve: $insetAnimationCurve, transitionDuration: $transitionDuration, reverseTransitionDuration: $reverseTransitionDuration, transitionCurve: $transitionCurve, reverseTransitionCurve: $reverseTransitionCurve, transitionBuilder: $transitionBuilder)';
}
