import 'package:flutter/widgets.dart';

import 'button_style.dart';
import '../foundation/motion.dart';

/// Optional appearance and motion tokens for time pickers.
@immutable
class TimePickerStyle {
  /// Creates a collection of inheritable picker tokens.
  const TimePickerStyle({
    this.decoration,
    this.padding,
    this.headerTextStyle,
    this.dialTextStyle,
    this.inputTextStyle,
    this.segmentStyle,
    this.selectedSegmentStyle,
    this.periodStyle,
    this.selectedPeriodStyle,
    this.entryModeButtonStyle,
    this.dialDecoration,
    this.handDecoration,
    this.handColor,
    this.dialBackgroundColor,
    this.dialSize,
    this.handWidth,
    this.handRadius,
    this.animationDuration,
    this.animationCurve,
    this.spring,
  });

  /// The decoration token.
  final Decoration? decoration;

  /// The padding token.
  final EdgeInsetsGeometry? padding;

  /// The headerTextStyle token.
  final TextStyle? headerTextStyle;

  /// The dialTextStyle token.
  final TextStyle? dialTextStyle;

  /// The inputTextStyle token.
  final TextStyle? inputTextStyle;

  /// The segmentStyle token.
  final ButtonStyle? segmentStyle;

  /// The selectedSegmentStyle token.
  final ButtonStyle? selectedSegmentStyle;

  /// The periodStyle token.
  final ButtonStyle? periodStyle;

  /// The selectedPeriodStyle token.
  final ButtonStyle? selectedPeriodStyle;

  /// The entryModeButtonStyle token.
  final ButtonStyle? entryModeButtonStyle;

  /// The dialDecoration token.
  final Decoration? dialDecoration;

  /// The handDecoration token.
  final Decoration? handDecoration;

  /// The handColor token.
  final Color? handColor;

  /// The dialBackgroundColor token.
  final Color? dialBackgroundColor;

  /// The dialSize token.
  final double? dialSize;

  /// The handWidth token.
  final double? handWidth;

  /// The handRadius token.
  final double? handRadius;

  /// The animationDuration token.
  final Duration? animationDuration;

  /// The animationCurve token.
  final Curve? animationCurve;

  /// The spring token.
  final MotionSpring? spring;

  /// Returns a copy with non-null tokens replaced.
  TimePickerStyle copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    TextStyle? headerTextStyle,
    TextStyle? dialTextStyle,
    TextStyle? inputTextStyle,
    ButtonStyle? segmentStyle,
    ButtonStyle? selectedSegmentStyle,
    ButtonStyle? periodStyle,
    ButtonStyle? selectedPeriodStyle,
    ButtonStyle? entryModeButtonStyle,
    Decoration? dialDecoration,
    Decoration? handDecoration,
    Color? handColor,
    Color? dialBackgroundColor,
    double? dialSize,
    double? handWidth,
    double? handRadius,
    Duration? animationDuration,
    Curve? animationCurve,
    MotionSpring? spring,
  }) => TimePickerStyle(
    decoration: decoration ?? this.decoration,
    padding: padding ?? this.padding,
    headerTextStyle: headerTextStyle ?? this.headerTextStyle,
    dialTextStyle: dialTextStyle ?? this.dialTextStyle,
    inputTextStyle: inputTextStyle ?? this.inputTextStyle,
    segmentStyle: segmentStyle ?? this.segmentStyle,
    selectedSegmentStyle: selectedSegmentStyle ?? this.selectedSegmentStyle,
    periodStyle: periodStyle ?? this.periodStyle,
    selectedPeriodStyle: selectedPeriodStyle ?? this.selectedPeriodStyle,
    entryModeButtonStyle: entryModeButtonStyle ?? this.entryModeButtonStyle,
    dialDecoration: dialDecoration ?? this.dialDecoration,
    handDecoration: handDecoration ?? this.handDecoration,
    handColor: handColor ?? this.handColor,
    dialBackgroundColor: dialBackgroundColor ?? this.dialBackgroundColor,
    dialSize: dialSize ?? this.dialSize,
    handWidth: handWidth ?? this.handWidth,
    handRadius: handRadius ?? this.handRadius,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
    spring: spring ?? this.spring,
  );

  /// Fills unset tokens from [other], merging nested button tokens.
  TimePickerStyle merge(TimePickerStyle? other) {
    if (other == null) return this;
    return TimePickerStyle(
      decoration: decoration ?? other.decoration,
      padding: padding ?? other.padding,
      headerTextStyle: headerTextStyle ?? other.headerTextStyle,
      dialTextStyle: dialTextStyle ?? other.dialTextStyle,
      inputTextStyle: inputTextStyle ?? other.inputTextStyle,
      segmentStyle:
          segmentStyle?.merge(other.segmentStyle) ?? other.segmentStyle,
      selectedSegmentStyle:
          selectedSegmentStyle?.merge(other.selectedSegmentStyle) ??
          other.selectedSegmentStyle,
      periodStyle: periodStyle?.merge(other.periodStyle) ?? other.periodStyle,
      selectedPeriodStyle:
          selectedPeriodStyle?.merge(other.selectedPeriodStyle) ??
          other.selectedPeriodStyle,
      entryModeButtonStyle:
          entryModeButtonStyle?.merge(other.entryModeButtonStyle) ??
          other.entryModeButtonStyle,
      dialDecoration: dialDecoration ?? other.dialDecoration,
      handDecoration: handDecoration ?? other.handDecoration,
      handColor: handColor ?? other.handColor,
      dialBackgroundColor: dialBackgroundColor ?? other.dialBackgroundColor,
      dialSize: dialSize ?? other.dialSize,
      handWidth: handWidth ?? other.handWidth,
      handRadius: handRadius ?? other.handRadius,
      animationDuration: animationDuration ?? other.animationDuration,
      animationCurve: animationCurve ?? other.animationCurve,
      spring: spring ?? other.spring,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimePickerStyle &&
          decoration == other.decoration &&
          padding == other.padding &&
          headerTextStyle == other.headerTextStyle &&
          dialTextStyle == other.dialTextStyle &&
          inputTextStyle == other.inputTextStyle &&
          segmentStyle == other.segmentStyle &&
          selectedSegmentStyle == other.selectedSegmentStyle &&
          periodStyle == other.periodStyle &&
          selectedPeriodStyle == other.selectedPeriodStyle &&
          entryModeButtonStyle == other.entryModeButtonStyle &&
          dialDecoration == other.dialDecoration &&
          handDecoration == other.handDecoration &&
          handColor == other.handColor &&
          dialBackgroundColor == other.dialBackgroundColor &&
          dialSize == other.dialSize &&
          handWidth == other.handWidth &&
          handRadius == other.handRadius &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve &&
          spring == other.spring;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    decoration,
    padding,
    headerTextStyle,
    dialTextStyle,
    inputTextStyle,
    segmentStyle,
    selectedSegmentStyle,
    periodStyle,
    selectedPeriodStyle,
    entryModeButtonStyle,
    dialDecoration,
    handDecoration,
    handColor,
    dialBackgroundColor,
    dialSize,
    handWidth,
    handRadius,
    animationDuration,
    animationCurve,
    spring,
  ]);

  @override
  String toString() =>
      'TimePickerStyle(decoration: $decoration, padding: $padding, headerTextStyle: $headerTextStyle, dialTextStyle: $dialTextStyle, inputTextStyle: $inputTextStyle, segmentStyle: $segmentStyle, selectedSegmentStyle: $selectedSegmentStyle, periodStyle: $periodStyle, selectedPeriodStyle: $selectedPeriodStyle, entryModeButtonStyle: $entryModeButtonStyle, dialDecoration: $dialDecoration, handDecoration: $handDecoration, handColor: $handColor, dialBackgroundColor: $dialBackgroundColor, dialSize: $dialSize, handWidth: $handWidth, handRadius: $handRadius, animationDuration: $animationDuration, animationCurve: $animationCurve, spring: $spring)';
}
