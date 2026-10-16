import 'package:flutter/widgets.dart';

import '../styles/date_picker_style.dart';
import '../styles/time_picker_style.dart';
import 'pure_theme.dart';

/// Overrides datePicker tokens within a subtree.
class DatePickerTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const DatePickerTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final DatePickerStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static DatePickerStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).datePickerStyle;

  /// Returns local tokens when this component theme is present.
  static DatePickerStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DatePickerTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required DatePickerStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        DatePickerTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      DatePickerTheme(data: data, child: child);

  @override
  bool updateShouldNotify(DatePickerTheme oldWidget) => data != oldWidget.data;
}

/// Overrides timePicker tokens within a subtree.
class TimePickerTheme extends InheritedTheme {
  /// Supplies component tokens to the child.
  const TimePickerTheme({super.key, required this.data, required super.child});

  /// The component tokens inherited by this subtree.
  final TimePickerStyle data;

  /// Returns the nearest local tokens or the application's component style.
  static TimePickerStyle of(BuildContext context) =>
      maybeOf(context) ?? PureTheme.of(context).timePickerStyle;

  /// Returns local tokens when this component theme is present.
  static TimePickerStyle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TimePickerTheme>()?.data;

  /// Inherits unset tokens from the enclosing component theme.
  static Widget merge({
    Key? key,
    required TimePickerStyle data,
    required Widget child,
  }) => Builder(
    key: key,
    builder: (BuildContext context) =>
        TimePickerTheme(data: data.merge(of(context)), child: child),
  );

  @override
  Widget wrap(BuildContext context, Widget child) =>
      TimePickerTheme(data: data, child: child);

  @override
  bool updateShouldNotify(TimePickerTheme oldWidget) => data != oldWidget.data;
}
