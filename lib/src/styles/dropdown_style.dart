import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';
import 'button_style.dart';
import 'menu_style.dart';

/// Tokens for the structure and appearance of a dropdown.
///
/// Null tokens inherit from the next style layer. No visual values are supplied.
/// An editable field requires a cursor color and falls back to the ambient
/// text color, then opaque black, when [cursorColor] is unset.
@immutable
class DropdownStyle {
  /// Creates a collection of optional component tokens.
  const DropdownStyle({
    this.buttonStyle,
    this.menuStyle,
    this.itemStyle,
    this.iconTurns,
    this.selectedIndicator,
    this.textStyle,
    this.hintStyle,
    this.cursorColor,
    this.selectionColor,
    this.cursorWidth,
  });

  /// The tokens for the trigger or editable field surface.
  final ButtonStyle? buttonStyle;

  /// The tokens for the menu panel.
  final MenuStyle? menuStyle;

  /// The tokens for option rows.
  final ButtonStyle? itemStyle;

  /// How far the trailing icon rotates while the menu is open, in full turns.
  ///
  /// Defaults to 0.5, which flips the icon. Use 0 to keep it still. The
  /// rotation follows the trigger's `animationDuration` and `animationCurve`.
  final double? iconTurns;

  /// The leading option glyph, with selected state meaning chosen.
  final StateProperty<Widget?>? selectedIndicator;

  /// The text style for an editable field.
  final StateProperty<TextStyle?>? textStyle;

  /// The text style for a field hint or selection summary.
  final StateProperty<TextStyle?>? hintStyle;

  /// The cursor color for an editable field.
  final Color? cursorColor;

  /// The selection color for an editable field.
  final Color? selectionColor;

  /// The cursor width for an editable field.
  final double? cursorWidth;

  /// Returns a copy with the supplied non-null tokens replaced.
  DropdownStyle copyWith({
    ButtonStyle? buttonStyle,
    MenuStyle? menuStyle,
    ButtonStyle? itemStyle,
    double? iconTurns,
    StateProperty<Widget?>? selectedIndicator,
    StateProperty<TextStyle?>? textStyle,
    StateProperty<TextStyle?>? hintStyle,
    Color? cursorColor,
    Color? selectionColor,
    double? cursorWidth,
  }) {
    return DropdownStyle(
      buttonStyle: buttonStyle ?? this.buttonStyle,
      menuStyle: menuStyle ?? this.menuStyle,
      itemStyle: itemStyle ?? this.itemStyle,
      iconTurns: iconTurns ?? this.iconTurns,
      selectedIndicator: selectedIndicator ?? this.selectedIndicator,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      cursorColor: cursorColor ?? this.cursorColor,
      selectionColor: selectionColor ?? this.selectionColor,
      cursorWidth: cursorWidth ?? this.cursorWidth,
    );
  }

  /// Fills unset tokens from [other], preserving this style's tokens.
  /// Nested button and menu styles merge their individual tokens.
  DropdownStyle merge(DropdownStyle? other) {
    if (other == null) {
      return this;
    }
    return DropdownStyle(
      buttonStyle: buttonStyle?.merge(other.buttonStyle) ?? other.buttonStyle,
      menuStyle: menuStyle?.merge(other.menuStyle) ?? other.menuStyle,
      itemStyle: itemStyle?.merge(other.itemStyle) ?? other.itemStyle,
      iconTurns: iconTurns ?? other.iconTurns,
      selectedIndicator: selectedIndicator ?? other.selectedIndicator,
      textStyle: textStyle ?? other.textStyle,
      hintStyle: hintStyle ?? other.hintStyle,
      cursorColor: cursorColor ?? other.cursorColor,
      selectionColor: selectionColor ?? other.selectionColor,
      cursorWidth: cursorWidth ?? other.cursorWidth,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DropdownStyle &&
            buttonStyle == other.buttonStyle &&
            menuStyle == other.menuStyle &&
            itemStyle == other.itemStyle &&
            iconTurns == other.iconTurns &&
            selectedIndicator == other.selectedIndicator &&
            textStyle == other.textStyle &&
            hintStyle == other.hintStyle &&
            cursorColor == other.cursorColor &&
            selectionColor == other.selectionColor &&
            cursorWidth == other.cursorWidth;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    buttonStyle,
    menuStyle,
    itemStyle,
    iconTurns,
    selectedIndicator,
    textStyle,
    hintStyle,
    cursorColor,
    selectionColor,
    cursorWidth,
  ]);

  @override
  String toString() =>
      'DropdownStyle(buttonStyle: $buttonStyle, menuStyle: $menuStyle, itemStyle: $itemStyle, iconTurns: $iconTurns, selectedIndicator: $selectedIndicator, textStyle: $textStyle, hintStyle: $hintStyle, cursorColor: $cursorColor, selectionColor: $selectionColor, cursorWidth: $cursorWidth)';
}
