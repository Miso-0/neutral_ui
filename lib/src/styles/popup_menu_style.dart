import 'package:flutter/widgets.dart';

import '../foundation/state_property.dart';
import 'button_style.dart';
import 'menu_style.dart';

/// The placement of a popup menu relative to its trigger.
enum PopupMenuPosition {
  /// Aligns the panel with the top of the trigger.
  over,

  /// Places the panel below the trigger.
  under,
}

/// Tokens for the structure and appearance of a popup menu.
///
/// Null tokens inherit from the next style layer. No visual values are supplied.
@immutable
class PopupMenuStyle {
  /// Creates a collection of optional component tokens.
  const PopupMenuStyle({
    this.buttonStyle,
    this.menuStyle,
    this.itemStyle,
    this.checkIndicator,
    this.dividerDecoration,
    this.dividerHeight,
    this.position,
  });

  /// The tokens for the trigger.
  final ButtonStyle? buttonStyle;

  /// The tokens for the menu panel.
  final MenuStyle? menuStyle;

  /// The tokens for action rows.
  final ButtonStyle? itemStyle;

  /// The check glyph, with selected state meaning checked.
  final StateProperty<Widget?>? checkIndicator;

  /// The decoration painted by a divider.
  final Decoration? dividerDecoration;

  /// The height occupied by a divider.
  final double? dividerHeight;

  /// The placement of the panel relative to its anchor.
  final PopupMenuPosition? position;

  /// Returns a copy with the supplied non-null tokens replaced.
  PopupMenuStyle copyWith({
    ButtonStyle? buttonStyle,
    MenuStyle? menuStyle,
    ButtonStyle? itemStyle,
    StateProperty<Widget?>? checkIndicator,
    Decoration? dividerDecoration,
    double? dividerHeight,
    PopupMenuPosition? position,
  }) {
    return PopupMenuStyle(
      buttonStyle: buttonStyle ?? this.buttonStyle,
      menuStyle: menuStyle ?? this.menuStyle,
      itemStyle: itemStyle ?? this.itemStyle,
      checkIndicator: checkIndicator ?? this.checkIndicator,
      dividerDecoration: dividerDecoration ?? this.dividerDecoration,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      position: position ?? this.position,
    );
  }

  /// Fills unset tokens from [other], preserving this style's tokens.
  /// Nested button and menu styles merge their individual tokens.
  PopupMenuStyle merge(PopupMenuStyle? other) {
    if (other == null) {
      return this;
    }
    return PopupMenuStyle(
      buttonStyle: buttonStyle?.merge(other.buttonStyle) ?? other.buttonStyle,
      menuStyle: menuStyle?.merge(other.menuStyle) ?? other.menuStyle,
      itemStyle: itemStyle?.merge(other.itemStyle) ?? other.itemStyle,
      checkIndicator: checkIndicator ?? other.checkIndicator,
      dividerDecoration: dividerDecoration ?? other.dividerDecoration,
      dividerHeight: dividerHeight ?? other.dividerHeight,
      position: position ?? other.position,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PopupMenuStyle &&
            buttonStyle == other.buttonStyle &&
            menuStyle == other.menuStyle &&
            itemStyle == other.itemStyle &&
            checkIndicator == other.checkIndicator &&
            dividerDecoration == other.dividerDecoration &&
            dividerHeight == other.dividerHeight &&
            position == other.position;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    buttonStyle,
    menuStyle,
    itemStyle,
    checkIndicator,
    dividerDecoration,
    dividerHeight,
    position,
  ]);

  @override
  String toString() =>
      'PopupMenuStyle(buttonStyle: $buttonStyle, menuStyle: $menuStyle, itemStyle: $itemStyle, checkIndicator: $checkIndicator, dividerDecoration: $dividerDecoration, dividerHeight: $dividerHeight, position: $position)';
}
