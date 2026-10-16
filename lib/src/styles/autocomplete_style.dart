import 'package:flutter/widgets.dart';

import 'text_field_style.dart';
import 'menu_style.dart';
import 'button_style.dart';

/// Optional appearance and motion tokens for Autocomplete.
@immutable
class AutocompleteStyle {
  /// Creates inherited component tokens.
  const AutocompleteStyle({
    this.fieldStyle,
    this.menuStyle,
    this.itemStyle,
    this.optionsMaxHeight,
    this.optionsViewOpenDirection,
  });

  /// The fieldStyle token.
  final TextFieldStyle? fieldStyle;

  /// The menuStyle token.
  final MenuStyle? menuStyle;

  /// The itemStyle token.
  final ButtonStyle? itemStyle;

  /// The optionsMaxHeight token.
  final double? optionsMaxHeight;

  /// The optionsViewOpenDirection token.
  final OptionsViewOpenDirection? optionsViewOpenDirection;

  /// Replaces the supplied non-null tokens.
  AutocompleteStyle copyWith({
    TextFieldStyle? fieldStyle,
    MenuStyle? menuStyle,
    ButtonStyle? itemStyle,
    double? optionsMaxHeight,
    OptionsViewOpenDirection? optionsViewOpenDirection,
  }) => AutocompleteStyle(
    fieldStyle: fieldStyle ?? this.fieldStyle,
    menuStyle: menuStyle ?? this.menuStyle,
    itemStyle: itemStyle ?? this.itemStyle,
    optionsMaxHeight: optionsMaxHeight ?? this.optionsMaxHeight,
    optionsViewOpenDirection:
        optionsViewOpenDirection ?? this.optionsViewOpenDirection,
  );

  /// Inherits unset tokens while retaining this style's values.
  AutocompleteStyle merge(AutocompleteStyle? other) {
    if (other == null) return this;
    return AutocompleteStyle(
      fieldStyle: fieldStyle?.merge(other.fieldStyle) ?? other.fieldStyle,
      menuStyle: menuStyle?.merge(other.menuStyle) ?? other.menuStyle,
      itemStyle: itemStyle?.merge(other.itemStyle) ?? other.itemStyle,
      optionsMaxHeight: optionsMaxHeight ?? other.optionsMaxHeight,
      optionsViewOpenDirection:
          optionsViewOpenDirection ?? other.optionsViewOpenDirection,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutocompleteStyle &&
          fieldStyle == other.fieldStyle &&
          menuStyle == other.menuStyle &&
          itemStyle == other.itemStyle &&
          optionsMaxHeight == other.optionsMaxHeight &&
          optionsViewOpenDirection == other.optionsViewOpenDirection;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    fieldStyle,
    menuStyle,
    itemStyle,
    optionsMaxHeight,
    optionsViewOpenDirection,
  ]);

  @override
  String toString() =>
      'AutocompleteStyle(fieldStyle: $fieldStyle, menuStyle: $menuStyle, itemStyle: $itemStyle, optionsMaxHeight: $optionsMaxHeight, optionsViewOpenDirection: $optionsViewOpenDirection)';
}
