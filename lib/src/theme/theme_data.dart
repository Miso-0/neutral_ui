import 'package:flutter/widgets.dart';

import '../styles/button_style.dart';
import '../styles/dropdown_style.dart';
import '../styles/popup_menu_style.dart';
import '../styles/toggle_style.dart';
import '../styles/list_tile_style.dart';
import '../styles/slider_style.dart';

/// The component tokens inherited through a PureTheme widget.
///
/// Every style is empty by default, leaving appearance to the application.
@immutable
class ThemeData {
  /// Creates the central collection of component styles.
  const ThemeData({
    this.elevatedButtonStyle = const ButtonStyle(),
    this.outlinedButtonStyle = const ButtonStyle(),
    this.textButtonStyle = const ButtonStyle(),
    this.iconButtonStyle = const ButtonStyle(),
    this.checkboxStyle = const ToggleStyle(),
    this.switchStyle = const ToggleStyle(),
    this.radioStyle = const ToggleStyle(),
    this.listTileStyle = const ListTileStyle(),
    this.sliderStyle = const SliderStyle(),
    this.dropdownButtonStyle = const DropdownStyle(),
    this.dropdownMenuStyle = const DropdownStyle(),
    this.popupMenuStyle = const PopupMenuStyle(),
  });

  /// The tokens for elevatedButton components.
  final ButtonStyle elevatedButtonStyle;

  /// The tokens for outlinedButton components.
  final ButtonStyle outlinedButtonStyle;

  /// The tokens for textButton components.
  final ButtonStyle textButtonStyle;

  /// The tokens for iconButton components.
  final ButtonStyle iconButtonStyle;

  /// The tokens for checkbox components.
  final ToggleStyle checkboxStyle;

  /// The tokens for switch components.
  final ToggleStyle switchStyle;

  /// The tokens for radio components.
  final ToggleStyle radioStyle;

  /// The tokens for listTile components.
  final ListTileStyle listTileStyle;

  /// The tokens for slider components.
  final SliderStyle sliderStyle;

  /// The tokens for dropdownButton components.
  final DropdownStyle dropdownButtonStyle;

  /// The tokens for dropdownMenu components.
  final DropdownStyle dropdownMenuStyle;

  /// The tokens for popupMenu components.
  final PopupMenuStyle popupMenuStyle;

  /// Returns a copy with the supplied component styles replaced.
  ThemeData copyWith({
    ButtonStyle? elevatedButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,
    ButtonStyle? iconButtonStyle,
    ToggleStyle? checkboxStyle,
    ToggleStyle? switchStyle,
    ToggleStyle? radioStyle,
    ListTileStyle? listTileStyle,
    SliderStyle? sliderStyle,
    DropdownStyle? dropdownButtonStyle,
    DropdownStyle? dropdownMenuStyle,
    PopupMenuStyle? popupMenuStyle,
  }) {
    return ThemeData(
      elevatedButtonStyle: elevatedButtonStyle ?? this.elevatedButtonStyle,
      outlinedButtonStyle: outlinedButtonStyle ?? this.outlinedButtonStyle,
      textButtonStyle: textButtonStyle ?? this.textButtonStyle,
      iconButtonStyle: iconButtonStyle ?? this.iconButtonStyle,
      checkboxStyle: checkboxStyle ?? this.checkboxStyle,
      switchStyle: switchStyle ?? this.switchStyle,
      radioStyle: radioStyle ?? this.radioStyle,
      listTileStyle: listTileStyle ?? this.listTileStyle,
      sliderStyle: sliderStyle ?? this.sliderStyle,
      dropdownButtonStyle: dropdownButtonStyle ?? this.dropdownButtonStyle,
      dropdownMenuStyle: dropdownMenuStyle ?? this.dropdownMenuStyle,
      popupMenuStyle: popupMenuStyle ?? this.popupMenuStyle,
    );
  }

  /// Fills every unset component token from [other].
  ThemeData merge(ThemeData? other) {
    if (other == null) {
      return this;
    }
    return ThemeData(
      elevatedButtonStyle: elevatedButtonStyle.merge(other.elevatedButtonStyle),
      outlinedButtonStyle: outlinedButtonStyle.merge(other.outlinedButtonStyle),
      textButtonStyle: textButtonStyle.merge(other.textButtonStyle),
      iconButtonStyle: iconButtonStyle.merge(other.iconButtonStyle),
      checkboxStyle: checkboxStyle.merge(other.checkboxStyle),
      switchStyle: switchStyle.merge(other.switchStyle),
      radioStyle: radioStyle.merge(other.radioStyle),
      listTileStyle: listTileStyle.merge(other.listTileStyle),
      sliderStyle: sliderStyle.merge(other.sliderStyle),
      dropdownButtonStyle: dropdownButtonStyle.merge(other.dropdownButtonStyle),
      dropdownMenuStyle: dropdownMenuStyle.merge(other.dropdownMenuStyle),
      popupMenuStyle: popupMenuStyle.merge(other.popupMenuStyle),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ThemeData &&
            elevatedButtonStyle == other.elevatedButtonStyle &&
            outlinedButtonStyle == other.outlinedButtonStyle &&
            textButtonStyle == other.textButtonStyle &&
            iconButtonStyle == other.iconButtonStyle &&
            checkboxStyle == other.checkboxStyle &&
            switchStyle == other.switchStyle &&
            radioStyle == other.radioStyle &&
            listTileStyle == other.listTileStyle &&
            sliderStyle == other.sliderStyle &&
            dropdownButtonStyle == other.dropdownButtonStyle &&
            dropdownMenuStyle == other.dropdownMenuStyle &&
            popupMenuStyle == other.popupMenuStyle;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    elevatedButtonStyle,
    outlinedButtonStyle,
    textButtonStyle,
    iconButtonStyle,
    checkboxStyle,
    switchStyle,
    radioStyle,
    listTileStyle,
    sliderStyle,
    dropdownButtonStyle,
    dropdownMenuStyle,
    popupMenuStyle,
  ]);

  @override
  String toString() =>
      'ThemeData(elevatedButtonStyle: $elevatedButtonStyle, outlinedButtonStyle: $outlinedButtonStyle, textButtonStyle: $textButtonStyle, iconButtonStyle: $iconButtonStyle, checkboxStyle: $checkboxStyle, switchStyle: $switchStyle, radioStyle: $radioStyle, listTileStyle: $listTileStyle, sliderStyle: $sliderStyle, dropdownButtonStyle: $dropdownButtonStyle, dropdownMenuStyle: $dropdownMenuStyle, popupMenuStyle: $popupMenuStyle)';
}
