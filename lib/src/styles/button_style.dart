import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';

/// The position of an icon relative to its label.
enum IconAlignment {
  /// Before the label in the reading direction.
  start,

  /// After the label in the reading direction.
  end,
}

/// Tokens for the structure and appearance of a button.
///
/// Null tokens inherit from the next style layer. No visual values are supplied.
@immutable
class ButtonStyle {
  /// Creates a collection of optional component tokens.
  const ButtonStyle({
    this.decoration,
    this.foregroundDecoration,
    this.padding,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.textStyle,
    this.iconTheme,
    this.mouseCursor,
    this.loadingIndicator,
    this.alignment,
    this.spacing,
    this.iconAlignment,
    this.tapTargetSize,
    this.clipBehavior,
    this.animationDuration,
    this.animationCurve,
    this.enableFeedback,
  });

  /// The decoration behind the content.
  final StateProperty<Decoration?>? decoration;

  /// The decoration painted over the content.
  final StateProperty<Decoration?>? foregroundDecoration;

  /// The inset around the content.
  final StateProperty<EdgeInsetsGeometry?>? padding;

  /// The minimum visual size.
  final StateProperty<Size?>? minimumSize;

  /// The preferred fixed visual size.
  final StateProperty<Size?>? fixedSize;

  /// The maximum visual size.
  final StateProperty<Size?>? maximumSize;

  /// The text style inherited by the content.
  final StateProperty<TextStyle?>? textStyle;

  /// The icon theme inherited by the content.
  final StateProperty<IconThemeData?>? iconTheme;

  /// The pointer cursor for the current interaction state.
  final StateProperty<MouseCursor?>? mouseCursor;

  /// The content shown while loading.
  final StateProperty<Widget?>? loadingIndicator;

  /// The alignment of the content.
  final AlignmentGeometry? alignment;

  /// The space between content slots.
  final double? spacing;

  /// The position of an icon relative to its label.
  final IconAlignment? iconAlignment;

  /// The minimum interactive size.
  final Size? tapTargetSize;

  /// The clipping behavior of the visual content.
  final Clip? clipBehavior;

  /// The duration of visual transitions.
  final Duration? animationDuration;

  /// The curve of visual transitions.
  final Curve? animationCurve;

  /// Whether interactions provide platform feedback.
  final bool? enableFeedback;

  /// Returns a copy with the supplied non-null tokens replaced.
  ButtonStyle copyWith({
    StateProperty<Decoration?>? decoration,
    StateProperty<Decoration?>? foregroundDecoration,
    StateProperty<EdgeInsetsGeometry?>? padding,
    StateProperty<Size?>? minimumSize,
    StateProperty<Size?>? fixedSize,
    StateProperty<Size?>? maximumSize,
    StateProperty<TextStyle?>? textStyle,
    StateProperty<IconThemeData?>? iconTheme,
    StateProperty<MouseCursor?>? mouseCursor,
    StateProperty<Widget?>? loadingIndicator,
    AlignmentGeometry? alignment,
    double? spacing,
    IconAlignment? iconAlignment,
    Size? tapTargetSize,
    Clip? clipBehavior,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableFeedback,
  }) {
    return ButtonStyle(
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      padding: padding ?? this.padding,
      minimumSize: minimumSize ?? this.minimumSize,
      fixedSize: fixedSize ?? this.fixedSize,
      maximumSize: maximumSize ?? this.maximumSize,
      textStyle: textStyle ?? this.textStyle,
      iconTheme: iconTheme ?? this.iconTheme,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      loadingIndicator: loadingIndicator ?? this.loadingIndicator,
      alignment: alignment ?? this.alignment,
      spacing: spacing ?? this.spacing,
      iconAlignment: iconAlignment ?? this.iconAlignment,
      tapTargetSize: tapTargetSize ?? this.tapTargetSize,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      enableFeedback: enableFeedback ?? this.enableFeedback,
    );
  }

  /// Fills unset tokens from [other], preserving this style's tokens.
  ButtonStyle merge(ButtonStyle? other) {
    if (other == null) {
      return this;
    }
    return ButtonStyle(
      decoration: decoration ?? other.decoration,
      foregroundDecoration: foregroundDecoration ?? other.foregroundDecoration,
      padding: padding ?? other.padding,
      minimumSize: minimumSize ?? other.minimumSize,
      fixedSize: fixedSize ?? other.fixedSize,
      maximumSize: maximumSize ?? other.maximumSize,
      textStyle: textStyle ?? other.textStyle,
      iconTheme: iconTheme ?? other.iconTheme,
      mouseCursor: mouseCursor ?? other.mouseCursor,
      loadingIndicator: loadingIndicator ?? other.loadingIndicator,
      alignment: alignment ?? other.alignment,
      spacing: spacing ?? other.spacing,
      iconAlignment: iconAlignment ?? other.iconAlignment,
      tapTargetSize: tapTargetSize ?? other.tapTargetSize,
      clipBehavior: clipBehavior ?? other.clipBehavior,
      animationDuration: animationDuration ?? other.animationDuration,
      animationCurve: animationCurve ?? other.animationCurve,
      enableFeedback: enableFeedback ?? other.enableFeedback,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ButtonStyle &&
            decoration == other.decoration &&
            foregroundDecoration == other.foregroundDecoration &&
            padding == other.padding &&
            minimumSize == other.minimumSize &&
            fixedSize == other.fixedSize &&
            maximumSize == other.maximumSize &&
            textStyle == other.textStyle &&
            iconTheme == other.iconTheme &&
            mouseCursor == other.mouseCursor &&
            loadingIndicator == other.loadingIndicator &&
            alignment == other.alignment &&
            spacing == other.spacing &&
            iconAlignment == other.iconAlignment &&
            tapTargetSize == other.tapTargetSize &&
            clipBehavior == other.clipBehavior &&
            animationDuration == other.animationDuration &&
            animationCurve == other.animationCurve &&
            enableFeedback == other.enableFeedback;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    foregroundDecoration,
    padding,
    minimumSize,
    fixedSize,
    maximumSize,
    textStyle,
    iconTheme,
    mouseCursor,
    loadingIndicator,
    alignment,
    spacing,
    iconAlignment,
    tapTargetSize,
    clipBehavior,
    animationDuration,
    animationCurve,
    enableFeedback,
  ]);

  @override
  String toString() =>
      'ButtonStyle(decoration: $decoration, foregroundDecoration: $foregroundDecoration, padding: $padding, minimumSize: $minimumSize, fixedSize: $fixedSize, maximumSize: $maximumSize, textStyle: $textStyle, iconTheme: $iconTheme, mouseCursor: $mouseCursor, loadingIndicator: $loadingIndicator, alignment: $alignment, spacing: $spacing, iconAlignment: $iconAlignment, tapTargetSize: $tapTargetSize, clipBehavior: $clipBehavior, animationDuration: $animationDuration, animationCurve: $animationCurve, enableFeedback: $enableFeedback)';
}
