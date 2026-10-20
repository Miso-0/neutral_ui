import 'package:flutter/widgets.dart';

import '../styles/button_style.dart';
import '../styles/toggle_style.dart';
import '../styles/list_tile_style.dart';
import '../styles/slider_style.dart';
import '../styles/dropdown_style.dart';
import '../styles/popup_menu_style.dart';
import '../styles/tooltip_style.dart';
import '../styles/dialog_style.dart';
import '../styles/bottom_sheet_style.dart';
import '../styles/snack_bar_style.dart';
import '../styles/text_field_style.dart';
import '../styles/autocomplete_style.dart';
import '../styles/search_style.dart';
import '../styles/date_picker_style.dart';
import '../styles/time_picker_style.dart';
import '../styles/chip_style.dart';
import '../styles/tab_bar_style.dart';
import '../styles/navigation_style.dart';
import '../styles/expansion_tile_style.dart';
import '../styles/progress_indicator_style.dart';
import '../styles/badge_style.dart';

/// Component tokens inherited through NeutralTheme.
@immutable
class ThemeData {
  /// Creates the central collection of optional component styles.
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
    this.tooltipStyle = const TooltipStyle(),
    this.dialogStyle = const DialogStyle(),
    this.bottomSheetStyle = const BottomSheetStyle(),
    this.snackBarStyle = const SnackBarStyle(),
    this.textFieldStyle = const TextFieldStyle(),
    this.autocompleteStyle = const AutocompleteStyle(),
    this.searchStyle = const SearchStyle(),
    this.datePickerStyle = const DatePickerStyle(),
    this.timePickerStyle = const TimePickerStyle(),
    this.filledButtonStyle = const ButtonStyle(),
    this.floatingActionButtonStyle = const ButtonStyle(),
    this.segmentedButtonStyle = const ButtonStyle(),
    this.toggleButtonsStyle = const ButtonStyle(),
    this.chipStyle = const ChipStyle(),
    this.tabBarStyle = const TabBarStyle(),
    this.navigationStyle = const NavigationStyle(),
    this.expansionTileStyle = const ExpansionTileStyle(),
    this.progressIndicatorStyle = const ProgressIndicatorStyle(),
    this.badgeStyle = const BadgeStyle(),
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

  /// The tokens for tooltip components.
  final TooltipStyle tooltipStyle;

  /// The tokens for dialog components.
  final DialogStyle dialogStyle;

  /// The tokens for bottomSheet components.
  final BottomSheetStyle bottomSheetStyle;

  /// The tokens for snackBar components.
  final SnackBarStyle snackBarStyle;

  /// The tokens for textField components.
  final TextFieldStyle textFieldStyle;

  /// The tokens for autocomplete components.
  final AutocompleteStyle autocompleteStyle;

  /// The tokens for search components.
  final SearchStyle searchStyle;

  /// The tokens for datePicker components.
  final DatePickerStyle datePickerStyle;

  /// The tokens for timePicker components.
  final TimePickerStyle timePickerStyle;

  /// The tokens for filledButton components.
  final ButtonStyle filledButtonStyle;

  /// The tokens for floatingActionButton components.
  final ButtonStyle floatingActionButtonStyle;

  /// The tokens for segmentedButton components.
  final ButtonStyle segmentedButtonStyle;

  /// The tokens for toggleButtons components.
  final ButtonStyle toggleButtonsStyle;

  /// The tokens for chip components.
  final ChipStyle chipStyle;

  /// The tokens for tabBar components.
  final TabBarStyle tabBarStyle;

  /// The tokens for navigation components.
  final NavigationStyle navigationStyle;

  /// The tokens for expansionTile components.
  final ExpansionTileStyle expansionTileStyle;

  /// The tokens for progressIndicator components.
  final ProgressIndicatorStyle progressIndicatorStyle;

  /// The tokens for badge components.
  final BadgeStyle badgeStyle;

  /// Replaces the supplied component styles.
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
    TooltipStyle? tooltipStyle,
    DialogStyle? dialogStyle,
    BottomSheetStyle? bottomSheetStyle,
    SnackBarStyle? snackBarStyle,
    TextFieldStyle? textFieldStyle,
    AutocompleteStyle? autocompleteStyle,
    SearchStyle? searchStyle,
    DatePickerStyle? datePickerStyle,
    TimePickerStyle? timePickerStyle,
    ButtonStyle? filledButtonStyle,
    ButtonStyle? floatingActionButtonStyle,
    ButtonStyle? segmentedButtonStyle,
    ButtonStyle? toggleButtonsStyle,
    ChipStyle? chipStyle,
    TabBarStyle? tabBarStyle,
    NavigationStyle? navigationStyle,
    ExpansionTileStyle? expansionTileStyle,
    ProgressIndicatorStyle? progressIndicatorStyle,
    BadgeStyle? badgeStyle,
  }) => ThemeData(
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
    tooltipStyle: tooltipStyle ?? this.tooltipStyle,
    dialogStyle: dialogStyle ?? this.dialogStyle,
    bottomSheetStyle: bottomSheetStyle ?? this.bottomSheetStyle,
    snackBarStyle: snackBarStyle ?? this.snackBarStyle,
    textFieldStyle: textFieldStyle ?? this.textFieldStyle,
    autocompleteStyle: autocompleteStyle ?? this.autocompleteStyle,
    searchStyle: searchStyle ?? this.searchStyle,
    datePickerStyle: datePickerStyle ?? this.datePickerStyle,
    timePickerStyle: timePickerStyle ?? this.timePickerStyle,
    filledButtonStyle: filledButtonStyle ?? this.filledButtonStyle,
    floatingActionButtonStyle:
        floatingActionButtonStyle ?? this.floatingActionButtonStyle,
    segmentedButtonStyle: segmentedButtonStyle ?? this.segmentedButtonStyle,
    toggleButtonsStyle: toggleButtonsStyle ?? this.toggleButtonsStyle,
    chipStyle: chipStyle ?? this.chipStyle,
    tabBarStyle: tabBarStyle ?? this.tabBarStyle,
    navigationStyle: navigationStyle ?? this.navigationStyle,
    expansionTileStyle: expansionTileStyle ?? this.expansionTileStyle,
    progressIndicatorStyle:
        progressIndicatorStyle ?? this.progressIndicatorStyle,
    badgeStyle: badgeStyle ?? this.badgeStyle,
  );

  /// Inherits unset component tokens from the supplied theme.
  ThemeData merge(ThemeData? other) {
    if (other == null) return this;
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
      tooltipStyle: tooltipStyle.merge(other.tooltipStyle),
      dialogStyle: dialogStyle.merge(other.dialogStyle),
      bottomSheetStyle: bottomSheetStyle.merge(other.bottomSheetStyle),
      snackBarStyle: snackBarStyle.merge(other.snackBarStyle),
      textFieldStyle: textFieldStyle.merge(other.textFieldStyle),
      autocompleteStyle: autocompleteStyle.merge(other.autocompleteStyle),
      searchStyle: searchStyle.merge(other.searchStyle),
      datePickerStyle: datePickerStyle.merge(other.datePickerStyle),
      timePickerStyle: timePickerStyle.merge(other.timePickerStyle),
      filledButtonStyle: filledButtonStyle.merge(other.filledButtonStyle),
      floatingActionButtonStyle: floatingActionButtonStyle.merge(
        other.floatingActionButtonStyle,
      ),
      segmentedButtonStyle: segmentedButtonStyle.merge(
        other.segmentedButtonStyle,
      ),
      toggleButtonsStyle: toggleButtonsStyle.merge(other.toggleButtonsStyle),
      chipStyle: chipStyle.merge(other.chipStyle),
      tabBarStyle: tabBarStyle.merge(other.tabBarStyle),
      navigationStyle: navigationStyle.merge(other.navigationStyle),
      expansionTileStyle: expansionTileStyle.merge(other.expansionTileStyle),
      progressIndicatorStyle: progressIndicatorStyle.merge(
        other.progressIndicatorStyle,
      ),
      badgeStyle: badgeStyle.merge(other.badgeStyle),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
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
          popupMenuStyle == other.popupMenuStyle &&
          tooltipStyle == other.tooltipStyle &&
          dialogStyle == other.dialogStyle &&
          bottomSheetStyle == other.bottomSheetStyle &&
          snackBarStyle == other.snackBarStyle &&
          textFieldStyle == other.textFieldStyle &&
          autocompleteStyle == other.autocompleteStyle &&
          searchStyle == other.searchStyle &&
          datePickerStyle == other.datePickerStyle &&
          timePickerStyle == other.timePickerStyle &&
          filledButtonStyle == other.filledButtonStyle &&
          floatingActionButtonStyle == other.floatingActionButtonStyle &&
          segmentedButtonStyle == other.segmentedButtonStyle &&
          toggleButtonsStyle == other.toggleButtonsStyle &&
          chipStyle == other.chipStyle &&
          tabBarStyle == other.tabBarStyle &&
          navigationStyle == other.navigationStyle &&
          expansionTileStyle == other.expansionTileStyle &&
          progressIndicatorStyle == other.progressIndicatorStyle &&
          badgeStyle == other.badgeStyle;

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
    tooltipStyle,
    dialogStyle,
    bottomSheetStyle,
    snackBarStyle,
    textFieldStyle,
    autocompleteStyle,
    searchStyle,
    datePickerStyle,
    timePickerStyle,
    filledButtonStyle,
    floatingActionButtonStyle,
    segmentedButtonStyle,
    toggleButtonsStyle,
    chipStyle,
    tabBarStyle,
    navigationStyle,
    expansionTileStyle,
    progressIndicatorStyle,
    badgeStyle,
  ]);

  @override
  String toString() =>
      'ThemeData(elevatedButtonStyle: $elevatedButtonStyle, outlinedButtonStyle: $outlinedButtonStyle, textButtonStyle: $textButtonStyle, iconButtonStyle: $iconButtonStyle, checkboxStyle: $checkboxStyle, switchStyle: $switchStyle, radioStyle: $radioStyle, listTileStyle: $listTileStyle, sliderStyle: $sliderStyle, dropdownButtonStyle: $dropdownButtonStyle, dropdownMenuStyle: $dropdownMenuStyle, popupMenuStyle: $popupMenuStyle, tooltipStyle: $tooltipStyle, dialogStyle: $dialogStyle, bottomSheetStyle: $bottomSheetStyle, snackBarStyle: $snackBarStyle, textFieldStyle: $textFieldStyle, autocompleteStyle: $autocompleteStyle, searchStyle: $searchStyle, datePickerStyle: $datePickerStyle, timePickerStyle: $timePickerStyle, filledButtonStyle: $filledButtonStyle, floatingActionButtonStyle: $floatingActionButtonStyle, segmentedButtonStyle: $segmentedButtonStyle, toggleButtonsStyle: $toggleButtonsStyle, chipStyle: $chipStyle, tabBarStyle: $tabBarStyle, navigationStyle: $navigationStyle, expansionTileStyle: $expansionTileStyle, progressIndicatorStyle: $progressIndicatorStyle, badgeStyle: $badgeStyle)';
}
