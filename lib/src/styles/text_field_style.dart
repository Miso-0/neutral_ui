import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';
import 'button_style.dart';

/// Placement of a field's label relative to its editable text.
enum TextFieldLabelBehavior {
  /// Keep the label above the field.
  above,

  /// Move the label above when focused or nonempty.
  floating,

  /// Omit the label.
  none,
}

/// Optional appearance and motion tokens for TextField.
@immutable
class TextFieldStyle {
  /// Creates inherited component tokens.
  const TextFieldStyle({
    this.decoration,
    this.foregroundDecoration,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.helperStyle,
    this.errorStyle,
    this.counterStyle,
    this.contentPadding,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.actionStyle,
    this.cursorColor,
    this.selectionColor,
    this.mouseCursor,
    this.iconTheme,
    this.labelBehavior,
    this.labelScale,
    this.spacing,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.clipBehavior,
    this.scrollPadding,
    this.animationDuration,
    this.animationCurve,
  });

  /// The decoration token.
  final StateProperty<Decoration?>? decoration;

  /// The foregroundDecoration token.
  final StateProperty<Decoration?>? foregroundDecoration;

  /// The textStyle token.
  final StateProperty<TextStyle?>? textStyle;

  /// The hintStyle token.
  final StateProperty<TextStyle?>? hintStyle;

  /// The labelStyle token.
  final StateProperty<TextStyle?>? labelStyle;

  /// The helperStyle token.
  final StateProperty<TextStyle?>? helperStyle;

  /// The errorStyle token.
  final StateProperty<TextStyle?>? errorStyle;

  /// The counterStyle token.
  final StateProperty<TextStyle?>? counterStyle;

  /// The contentPadding token.
  final StateProperty<EdgeInsetsGeometry?>? contentPadding;

  /// The minimum size of the input box, excluding label and supporting text.
  ///
  /// The width bound also applies to the label and supporting text, which
  /// share the box's width.
  final StateProperty<Size?>? minimumSize;

  /// The exact size of the input box, clamped by [minimumSize] and
  /// [maximumSize]. A non-finite dimension leaves that axis unconstrained.
  ///
  /// The height applies to single-line fields only. Multi-line fields take
  /// their height from their line counts, or from the parent when they
  /// expand, within [minimumSize] and [maximumSize]; pass the field's
  /// `height` for an exact multi-line height.
  final StateProperty<Size?>? fixedSize;

  /// The maximum size of the input box, excluding label and supporting text.
  final StateProperty<Size?>? maximumSize;

  /// The style of the clear and password reveal actions.
  ///
  /// Actions are compact by default, with no padding and no minimum or tap
  /// target size. Their content fits the input box's available height and
  /// width. The enclosing icon button theme does not apply to them.
  final ButtonStyle? actionStyle;

  /// The cursorColor token.
  final StateProperty<Color?>? cursorColor;

  /// The selectionColor token.
  final StateProperty<Color?>? selectionColor;

  /// The mouseCursor token.
  final StateProperty<MouseCursor?>? mouseCursor;

  /// The iconTheme token.
  final StateProperty<IconThemeData?>? iconTheme;

  /// The labelBehavior token.
  final TextFieldLabelBehavior? labelBehavior;

  /// The labelScale token.
  final double? labelScale;

  /// The spacing token.
  final double? spacing;

  /// The cursorWidth token.
  final double? cursorWidth;

  /// The cursorHeight token.
  final double? cursorHeight;

  /// The cursorRadius token.
  final Radius? cursorRadius;

  /// The clipBehavior token.
  final Clip? clipBehavior;

  /// The scrollPadding token.
  final EdgeInsets? scrollPadding;

  /// The animationDuration token.
  final Duration? animationDuration;

  /// The animationCurve token.
  final Curve? animationCurve;

  /// Replaces the supplied non-null tokens.
  TextFieldStyle copyWith({
    StateProperty<Decoration?>? decoration,
    StateProperty<Decoration?>? foregroundDecoration,
    StateProperty<TextStyle?>? textStyle,
    StateProperty<TextStyle?>? hintStyle,
    StateProperty<TextStyle?>? labelStyle,
    StateProperty<TextStyle?>? helperStyle,
    StateProperty<TextStyle?>? errorStyle,
    StateProperty<TextStyle?>? counterStyle,
    StateProperty<EdgeInsetsGeometry?>? contentPadding,
    StateProperty<Size?>? minimumSize,
    StateProperty<Size?>? fixedSize,
    StateProperty<Size?>? maximumSize,
    ButtonStyle? actionStyle,
    StateProperty<Color?>? cursorColor,
    StateProperty<Color?>? selectionColor,
    StateProperty<MouseCursor?>? mouseCursor,
    StateProperty<IconThemeData?>? iconTheme,
    TextFieldLabelBehavior? labelBehavior,
    double? labelScale,
    double? spacing,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    Clip? clipBehavior,
    EdgeInsets? scrollPadding,
    Duration? animationDuration,
    Curve? animationCurve,
  }) => TextFieldStyle(
    decoration: decoration ?? this.decoration,
    foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
    textStyle: textStyle ?? this.textStyle,
    hintStyle: hintStyle ?? this.hintStyle,
    labelStyle: labelStyle ?? this.labelStyle,
    helperStyle: helperStyle ?? this.helperStyle,
    errorStyle: errorStyle ?? this.errorStyle,
    counterStyle: counterStyle ?? this.counterStyle,
    contentPadding: contentPadding ?? this.contentPadding,
    minimumSize: minimumSize ?? this.minimumSize,
    fixedSize: fixedSize ?? this.fixedSize,
    maximumSize: maximumSize ?? this.maximumSize,
    actionStyle: actionStyle ?? this.actionStyle,
    cursorColor: cursorColor ?? this.cursorColor,
    selectionColor: selectionColor ?? this.selectionColor,
    mouseCursor: mouseCursor ?? this.mouseCursor,
    iconTheme: iconTheme ?? this.iconTheme,
    labelBehavior: labelBehavior ?? this.labelBehavior,
    labelScale: labelScale ?? this.labelScale,
    spacing: spacing ?? this.spacing,
    cursorWidth: cursorWidth ?? this.cursorWidth,
    cursorHeight: cursorHeight ?? this.cursorHeight,
    cursorRadius: cursorRadius ?? this.cursorRadius,
    clipBehavior: clipBehavior ?? this.clipBehavior,
    scrollPadding: scrollPadding ?? this.scrollPadding,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
  );

  /// Inherits unset tokens while retaining this style's values.
  TextFieldStyle merge(TextFieldStyle? other) {
    if (other == null) return this;
    return TextFieldStyle(
      decoration: decoration ?? other.decoration,
      foregroundDecoration: foregroundDecoration ?? other.foregroundDecoration,
      textStyle: textStyle ?? other.textStyle,
      hintStyle: hintStyle ?? other.hintStyle,
      labelStyle: labelStyle ?? other.labelStyle,
      helperStyle: helperStyle ?? other.helperStyle,
      errorStyle: errorStyle ?? other.errorStyle,
      counterStyle: counterStyle ?? other.counterStyle,
      contentPadding: contentPadding ?? other.contentPadding,
      minimumSize: minimumSize ?? other.minimumSize,
      fixedSize: fixedSize ?? other.fixedSize,
      maximumSize: maximumSize ?? other.maximumSize,
      actionStyle: actionStyle?.merge(other.actionStyle) ?? other.actionStyle,
      cursorColor: cursorColor ?? other.cursorColor,
      selectionColor: selectionColor ?? other.selectionColor,
      mouseCursor: mouseCursor ?? other.mouseCursor,
      iconTheme: iconTheme ?? other.iconTheme,
      labelBehavior: labelBehavior ?? other.labelBehavior,
      labelScale: labelScale ?? other.labelScale,
      spacing: spacing ?? other.spacing,
      cursorWidth: cursorWidth ?? other.cursorWidth,
      cursorHeight: cursorHeight ?? other.cursorHeight,
      cursorRadius: cursorRadius ?? other.cursorRadius,
      clipBehavior: clipBehavior ?? other.clipBehavior,
      scrollPadding: scrollPadding ?? other.scrollPadding,
      animationDuration: animationDuration ?? other.animationDuration,
      animationCurve: animationCurve ?? other.animationCurve,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextFieldStyle &&
          decoration == other.decoration &&
          foregroundDecoration == other.foregroundDecoration &&
          textStyle == other.textStyle &&
          hintStyle == other.hintStyle &&
          labelStyle == other.labelStyle &&
          helperStyle == other.helperStyle &&
          errorStyle == other.errorStyle &&
          counterStyle == other.counterStyle &&
          contentPadding == other.contentPadding &&
          minimumSize == other.minimumSize &&
          fixedSize == other.fixedSize &&
          maximumSize == other.maximumSize &&
          actionStyle == other.actionStyle &&
          cursorColor == other.cursorColor &&
          selectionColor == other.selectionColor &&
          mouseCursor == other.mouseCursor &&
          iconTheme == other.iconTheme &&
          labelBehavior == other.labelBehavior &&
          labelScale == other.labelScale &&
          spacing == other.spacing &&
          cursorWidth == other.cursorWidth &&
          cursorHeight == other.cursorHeight &&
          cursorRadius == other.cursorRadius &&
          clipBehavior == other.clipBehavior &&
          scrollPadding == other.scrollPadding &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    foregroundDecoration,
    textStyle,
    hintStyle,
    labelStyle,
    helperStyle,
    errorStyle,
    counterStyle,
    contentPadding,
    minimumSize,
    fixedSize,
    maximumSize,
    actionStyle,
    cursorColor,
    selectionColor,
    mouseCursor,
    iconTheme,
    labelBehavior,
    labelScale,
    spacing,
    cursorWidth,
    cursorHeight,
    cursorRadius,
    clipBehavior,
    scrollPadding,
    animationDuration,
    animationCurve,
  ]);

  @override
  String toString() =>
      'TextFieldStyle(decoration: $decoration, foregroundDecoration: $foregroundDecoration, textStyle: $textStyle, hintStyle: $hintStyle, labelStyle: $labelStyle, helperStyle: $helperStyle, errorStyle: $errorStyle, counterStyle: $counterStyle, contentPadding: $contentPadding, minimumSize: $minimumSize, fixedSize: $fixedSize, maximumSize: $maximumSize, actionStyle: $actionStyle, cursorColor: $cursorColor, selectionColor: $selectionColor, mouseCursor: $mouseCursor, iconTheme: $iconTheme, labelBehavior: $labelBehavior, labelScale: $labelScale, spacing: $spacing, cursorWidth: $cursorWidth, cursorHeight: $cursorHeight, cursorRadius: $cursorRadius, clipBehavior: $clipBehavior, scrollPadding: $scrollPadding, animationDuration: $animationDuration, animationCurve: $animationCurve)';
}
