import 'package:flutter/widgets.dart';

import 'button_style.dart';
import '../overlay/overlay_behavior.dart';
import '../overlay/overlay_placement.dart';
import '../overlay/overlay_transition.dart';

/// Optional appearance and motion tokens for date pickers.
@immutable
class DatePickerStyle {
  /// Creates a collection of inheritable picker tokens.
  const DatePickerStyle({
    this.decoration,
    this.padding,
    this.headerTextStyle,
    this.weekdayTextStyle,
    this.dayStyle,
    this.todayStyle,
    this.selectedDayStyle,
    this.inRangeDayStyle,
    this.rangeStartStyle,
    this.rangeEndStyle,
    this.yearStyle,
    this.disabledDayStyle,
    this.navigationButtonStyle,
    this.entryModeButtonStyle,
    this.rangeBandDecoration,
    this.dayExtent,
    this.yearExtent,
    this.monthWidth,
    this.animationDuration,
    this.animationCurve,
    this.placement,
    this.outsideTapBehavior,
    this.transitionDuration,
    this.transitionCurve,
    this.reverseTransitionCurve,
    this.reverseTransitionDuration,
    this.transitionBuilder,
  });

  /// The decoration token.
  final Decoration? decoration;

  /// The padding token.
  final EdgeInsetsGeometry? padding;

  /// The headerTextStyle token.
  final TextStyle? headerTextStyle;

  /// The weekdayTextStyle token.
  final TextStyle? weekdayTextStyle;

  /// The dayStyle token.
  final ButtonStyle? dayStyle;

  /// The todayStyle token.
  final ButtonStyle? todayStyle;

  /// The selectedDayStyle token.
  final ButtonStyle? selectedDayStyle;

  /// The inRangeDayStyle token.
  final ButtonStyle? inRangeDayStyle;

  /// The rangeStartStyle token.
  final ButtonStyle? rangeStartStyle;

  /// The rangeEndStyle token.
  final ButtonStyle? rangeEndStyle;

  /// The yearStyle token.
  final ButtonStyle? yearStyle;

  /// The disabledDayStyle token.
  final ButtonStyle? disabledDayStyle;

  /// The navigationButtonStyle token.
  final ButtonStyle? navigationButtonStyle;

  /// The entryModeButtonStyle token.
  final ButtonStyle? entryModeButtonStyle;

  /// The rangeBandDecoration token.
  final Decoration? rangeBandDecoration;

  /// The dayExtent token.
  final double? dayExtent;

  /// The yearExtent token.
  final double? yearExtent;

  /// The monthWidth token.
  final double? monthWidth;

  /// The animationDuration token.
  final Duration? animationDuration;

  /// The animationCurve token.
  final Curve? animationCurve;

  /// The placement token.
  final OverlayPlacement? placement;

  /// The outsideTapBehavior token.
  final OutsideTapBehavior? outsideTapBehavior;

  /// The transitionDuration token.
  final Duration? transitionDuration;

  /// The curve used while the popover enters.
  final Curve? transitionCurve;

  /// The curve used while the popover exits.
  final Curve? reverseTransitionCurve;

  /// The reverseTransitionDuration token.
  final Duration? reverseTransitionDuration;

  /// The transitionBuilder token.
  final OverlayTransitionBuilder? transitionBuilder;

  /// Returns a copy with non-null tokens replaced.
  DatePickerStyle copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    TextStyle? headerTextStyle,
    TextStyle? weekdayTextStyle,
    ButtonStyle? dayStyle,
    ButtonStyle? todayStyle,
    ButtonStyle? selectedDayStyle,
    ButtonStyle? inRangeDayStyle,
    ButtonStyle? rangeStartStyle,
    ButtonStyle? rangeEndStyle,
    ButtonStyle? yearStyle,
    ButtonStyle? disabledDayStyle,
    ButtonStyle? navigationButtonStyle,
    ButtonStyle? entryModeButtonStyle,
    Decoration? rangeBandDecoration,
    double? dayExtent,
    double? yearExtent,
    double? monthWidth,
    Duration? animationDuration,
    Curve? animationCurve,
    OverlayPlacement? placement,
    OutsideTapBehavior? outsideTapBehavior,
    Duration? transitionDuration,
    Curve? transitionCurve,
    Curve? reverseTransitionCurve,
    Duration? reverseTransitionDuration,
    OverlayTransitionBuilder? transitionBuilder,
  }) => DatePickerStyle(
    decoration: decoration ?? this.decoration,
    padding: padding ?? this.padding,
    headerTextStyle: headerTextStyle ?? this.headerTextStyle,
    weekdayTextStyle: weekdayTextStyle ?? this.weekdayTextStyle,
    dayStyle: dayStyle ?? this.dayStyle,
    todayStyle: todayStyle ?? this.todayStyle,
    selectedDayStyle: selectedDayStyle ?? this.selectedDayStyle,
    inRangeDayStyle: inRangeDayStyle ?? this.inRangeDayStyle,
    rangeStartStyle: rangeStartStyle ?? this.rangeStartStyle,
    rangeEndStyle: rangeEndStyle ?? this.rangeEndStyle,
    yearStyle: yearStyle ?? this.yearStyle,
    disabledDayStyle: disabledDayStyle ?? this.disabledDayStyle,
    navigationButtonStyle: navigationButtonStyle ?? this.navigationButtonStyle,
    entryModeButtonStyle: entryModeButtonStyle ?? this.entryModeButtonStyle,
    rangeBandDecoration: rangeBandDecoration ?? this.rangeBandDecoration,
    dayExtent: dayExtent ?? this.dayExtent,
    yearExtent: yearExtent ?? this.yearExtent,
    monthWidth: monthWidth ?? this.monthWidth,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
    placement: placement ?? this.placement,
    outsideTapBehavior: outsideTapBehavior ?? this.outsideTapBehavior,
    transitionDuration: transitionDuration ?? this.transitionDuration,
    transitionCurve: transitionCurve ?? this.transitionCurve,
    reverseTransitionCurve:
        reverseTransitionCurve ?? this.reverseTransitionCurve,
    reverseTransitionDuration:
        reverseTransitionDuration ?? this.reverseTransitionDuration,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );

  /// Fills unset tokens from [other], merging nested button tokens.
  DatePickerStyle merge(DatePickerStyle? other) {
    if (other == null) return this;
    return DatePickerStyle(
      decoration: decoration ?? other.decoration,
      padding: padding ?? other.padding,
      headerTextStyle: headerTextStyle ?? other.headerTextStyle,
      weekdayTextStyle: weekdayTextStyle ?? other.weekdayTextStyle,
      dayStyle: dayStyle?.merge(other.dayStyle) ?? other.dayStyle,
      todayStyle: todayStyle?.merge(other.todayStyle) ?? other.todayStyle,
      selectedDayStyle:
          selectedDayStyle?.merge(other.selectedDayStyle) ??
          other.selectedDayStyle,
      inRangeDayStyle:
          inRangeDayStyle?.merge(other.inRangeDayStyle) ??
          other.inRangeDayStyle,
      rangeStartStyle:
          rangeStartStyle?.merge(other.rangeStartStyle) ??
          other.rangeStartStyle,
      rangeEndStyle:
          rangeEndStyle?.merge(other.rangeEndStyle) ?? other.rangeEndStyle,
      yearStyle: yearStyle?.merge(other.yearStyle) ?? other.yearStyle,
      disabledDayStyle:
          disabledDayStyle?.merge(other.disabledDayStyle) ??
          other.disabledDayStyle,
      navigationButtonStyle:
          navigationButtonStyle?.merge(other.navigationButtonStyle) ??
          other.navigationButtonStyle,
      entryModeButtonStyle:
          entryModeButtonStyle?.merge(other.entryModeButtonStyle) ??
          other.entryModeButtonStyle,
      rangeBandDecoration: rangeBandDecoration ?? other.rangeBandDecoration,
      dayExtent: dayExtent ?? other.dayExtent,
      yearExtent: yearExtent ?? other.yearExtent,
      monthWidth: monthWidth ?? other.monthWidth,
      animationDuration: animationDuration ?? other.animationDuration,
      animationCurve: animationCurve ?? other.animationCurve,
      placement: placement ?? other.placement,
      outsideTapBehavior: outsideTapBehavior ?? other.outsideTapBehavior,
      transitionDuration: transitionDuration ?? other.transitionDuration,
      transitionCurve: transitionCurve ?? other.transitionCurve,
      reverseTransitionCurve:
          reverseTransitionCurve ?? other.reverseTransitionCurve,
      reverseTransitionDuration:
          reverseTransitionDuration ?? other.reverseTransitionDuration,
      transitionBuilder: transitionBuilder ?? other.transitionBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatePickerStyle &&
          decoration == other.decoration &&
          padding == other.padding &&
          headerTextStyle == other.headerTextStyle &&
          weekdayTextStyle == other.weekdayTextStyle &&
          dayStyle == other.dayStyle &&
          todayStyle == other.todayStyle &&
          selectedDayStyle == other.selectedDayStyle &&
          inRangeDayStyle == other.inRangeDayStyle &&
          rangeStartStyle == other.rangeStartStyle &&
          rangeEndStyle == other.rangeEndStyle &&
          yearStyle == other.yearStyle &&
          disabledDayStyle == other.disabledDayStyle &&
          navigationButtonStyle == other.navigationButtonStyle &&
          entryModeButtonStyle == other.entryModeButtonStyle &&
          rangeBandDecoration == other.rangeBandDecoration &&
          dayExtent == other.dayExtent &&
          yearExtent == other.yearExtent &&
          monthWidth == other.monthWidth &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve &&
          placement == other.placement &&
          outsideTapBehavior == other.outsideTapBehavior &&
          transitionDuration == other.transitionDuration &&
          transitionCurve == other.transitionCurve &&
          reverseTransitionCurve == other.reverseTransitionCurve &&
          reverseTransitionDuration == other.reverseTransitionDuration &&
          transitionBuilder == other.transitionBuilder;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    padding,
    headerTextStyle,
    weekdayTextStyle,
    dayStyle,
    todayStyle,
    selectedDayStyle,
    inRangeDayStyle,
    rangeStartStyle,
    rangeEndStyle,
    yearStyle,
    disabledDayStyle,
    navigationButtonStyle,
    entryModeButtonStyle,
    rangeBandDecoration,
    dayExtent,
    yearExtent,
    monthWidth,
    animationDuration,
    animationCurve,
    placement,
    outsideTapBehavior,
    transitionDuration,
    transitionCurve,
    reverseTransitionCurve,
    reverseTransitionDuration,
    transitionBuilder,
  ]);

  @override
  String toString() =>
      'DatePickerStyle(decoration: $decoration, padding: $padding, headerTextStyle: $headerTextStyle, weekdayTextStyle: $weekdayTextStyle, dayStyle: $dayStyle, todayStyle: $todayStyle, selectedDayStyle: $selectedDayStyle, inRangeDayStyle: $inRangeDayStyle, rangeStartStyle: $rangeStartStyle, rangeEndStyle: $rangeEndStyle, yearStyle: $yearStyle, disabledDayStyle: $disabledDayStyle, navigationButtonStyle: $navigationButtonStyle, entryModeButtonStyle: $entryModeButtonStyle, rangeBandDecoration: $rangeBandDecoration, dayExtent: $dayExtent, yearExtent: $yearExtent, monthWidth: $monthWidth, animationDuration: $animationDuration, animationCurve: $animationCurve, placement: $placement, outsideTapBehavior: $outsideTapBehavior, transitionDuration: $transitionDuration, transitionCurve: $transitionCurve, reverseTransitionCurve: $reverseTransitionCurve, reverseTransitionDuration: $reverseTransitionDuration, transitionBuilder: $transitionBuilder)';
}
