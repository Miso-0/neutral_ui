// Enum names match Flutter's public time formatting API.
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import '../localizations/pure_localizations.dart';

/// Whether a time falls before or after noon.
enum DayPeriod {
  /// Before noon.
  am,

  /// Noon and later.
  pm,
}

/// A time in a day, independent of a calendar date or time zone.
@immutable
class TimeOfDay implements Comparable<TimeOfDay> {
  /// Creates a time with a 24-hour [hour] and a [minute] from 0 to 59.
  const TimeOfDay({required this.hour, required this.minute})
    : assert(hour >= 0 && hour < hoursPerDay),
      assert(minute >= 0 && minute < minutesPerHour);

  /// Uses the hour and minute in the supplied date's time zone.
  TimeOfDay.fromDateTime(DateTime time)
    : hour = time.hour,
      minute = time.minute;

  /// The current time in the local time zone.
  TimeOfDay.now() : this.fromDateTime(DateTime.now());

  /// Hours in one day.
  static const int hoursPerDay = 24;

  /// Hours in an AM or PM period.
  static const int hoursPerPeriod = 12;

  /// Minutes in an hour.
  static const int minutesPerHour = 60;

  /// The hour, from 0 to 23.
  final int hour;

  /// The minute, from 0 to 59.
  final int minute;

  /// This time's AM or PM period.
  DayPeriod get period => hour < hoursPerPeriod ? DayPeriod.am : DayPeriod.pm;

  /// The hour in the current period, from 1 to 12.
  int get hourOfPeriod => hour == 0 || hour == 12 ? 12 : hour - periodOffset;

  /// The 24-hour clock hour at which this period begins.
  int get periodOffset => period == DayPeriod.am ? 0 : hoursPerPeriod;

  /// Returns a copy with the supplied hour or minute replaced.
  TimeOfDay replacing({int? hour, int? minute}) =>
      TimeOfDay(hour: hour ?? this.hour, minute: minute ?? this.minute);

  /// Formats using the ambient localizations and 24-hour preference.
  String format(BuildContext context) => PureLocalizations.of(context)
      .formatTimeOfDay(
        this,
        alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      );

  /// Whether this time occurs earlier in the day than [other].
  bool isBefore(TimeOfDay other) => compareTo(other) < 0;

  /// Whether this time occurs later in the day than [other].
  bool isAfter(TimeOfDay other) => compareTo(other) > 0;

  /// Whether this time has the same hour and minute as [other].
  bool isAtSameTimeAs(TimeOfDay other) => compareTo(other) == 0;

  @override
  int compareTo(TimeOfDay other) {
    final int hours = hour.compareTo(other.hour);
    return hours == 0 ? minute.compareTo(other.minute) : hours;
  }

  @override
  bool operator ==(Object other) =>
      other is TimeOfDay && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() =>
      'TimeOfDay(${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')})';
}

/// Dial or text entry, optionally preventing the user from changing modes.
enum TimePickerEntryMode {
  /// Dial with a switch to text input.
  dial,

  /// Text input with a switch to the dial.
  input,

  /// Dial with no entry mode switch.
  dialOnly,

  /// Text input with no entry mode switch.
  inputOnly,
}

/// Localized hour, minute, separator and day-period arrangement.
enum TimeOfDayFormat {
  /// Zero-padded 24-hour time separated by a colon.
  HH_colon_mm,

  /// Zero-padded 24-hour time separated by a dot.
  HH_dot_mm,

  /// Zero-padded 24-hour time separated by a spaced letter h.
  frenchCanadian,

  /// Unpadded 24-hour time separated by a colon.
  H_colon_mm,

  /// 12-hour time followed by the day period.
  h_colon_mm_space_a,

  /// Day period followed by 12-hour time.
  a_space_h_colon_mm,
}

/// How the hour is represented by a localized time format.
enum HourFormat {
  /// Zero-padded 24-hour hour.
  HH,

  /// Unpadded 24-hour hour.
  H,

  /// Unpadded hour within an AM or PM period.
  h,
}

/// Returns the hour representation used by [of].
HourFormat hourFormat({required TimeOfDayFormat of}) => switch (of) {
  TimeOfDayFormat.h_colon_mm_space_a ||
  TimeOfDayFormat.a_space_h_colon_mm => HourFormat.h,
  TimeOfDayFormat.H_colon_mm => HourFormat.H,
  TimeOfDayFormat.HH_colon_mm ||
  TimeOfDayFormat.HH_dot_mm ||
  TimeOfDayFormat.frenchCanadian => HourFormat.HH,
};
