import 'package:flutter/widgets.dart';

import '../localizations/neutral_localizations.dart';

/// Interprets, formats and navigates dates in a calendar system.
abstract class CalendarDelegate<T extends DateTime> {
  /// Creates a calendar delegate.
  const CalendarDelegate();

  /// The current date and time in this calendar.
  T now();

  /// Returns [date] with its time set to midnight.
  T dateOnly(T date);

  /// Returns [range] with both times set to midnight.
  DateTimeRange<T> datesOnly(DateTimeRange<T> range) =>
      DateTimeRange<T>(start: dateOnly(range.start), end: dateOnly(range.end));

  /// Whether both dates have the same year, month and day, or are both null.
  bool isSameDay(T? dateA, T? dateB) =>
      isSameMonth(dateA, dateB) && dateA?.day == dateB?.day;

  /// Whether both dates have the same year and month, or are both null.
  bool isSameMonth(T? dateA, T? dateB) =>
      dateA?.year == dateB?.year && dateA?.month == dateB?.month;

  /// The signed number of months from [startDate] to [endDate].
  int monthDelta(T startDate, T endDate);

  /// Adds months and returns the first day of the resulting month at midnight.
  T addMonthsToMonthDate(T monthDate, int monthsToAdd);

  /// Adds calendar days and sets the time to midnight.
  T addDaysToDate(T date, int days);

  /// The number of empty cells before the first day in the month's first week.
  int firstDayOffset(int year, int month, NeutralLocalizations localizations);

  /// The number of days in [month] of [year].
  int getDaysInMonth(int year, int month);

  /// The first day of [month] in [year], at midnight.
  T getMonth(int year, int month);

  /// The requested calendar date at midnight.
  T getDay(int year, int month, int day);

  /// Formats the full month name and year.
  String formatMonthYear(T date, NeutralLocalizations localizations);

  /// Formats the unabbreviated year.
  String formatYear(int year, NeutralLocalizations localizations) =>
      localizations.formatYear(DateTime(year));

  /// Formats an abbreviated weekday, month and day.
  String formatMediumDate(T date, NeutralLocalizations localizations);

  /// Formats an abbreviated month and day.
  String formatShortMonthDay(T date, NeutralLocalizations localizations);

  /// Formats an abbreviated month, day and year.
  String formatShortDate(T date, NeutralLocalizations localizations);

  /// Formats a full weekday, month, day and year for spoken announcements.
  String formatFullDate(T date, NeutralLocalizations localizations);

  /// Formats a numeric date for text input.
  String formatCompactDate(T date, NeutralLocalizations localizations);

  /// Parses a compact date, returning null for invalid or incomplete input.
  T? parseCompactDate(String? inputString, NeutralLocalizations localizations);

  /// The input hint describing the compact date format.
  String dateHelpText(NeutralLocalizations localizations);
}

/// Uses the Gregorian calendar and the ambient localized date formats.
class GregorianCalendarDelegate extends CalendarDelegate<DateTime> {
  /// Creates a Gregorian calendar delegate.
  const GregorianCalendarDelegate();

  @override
  DateTime now() => DateTime.now();

  @override
  DateTime dateOnly(DateTime date) => DateUtils.dateOnly(date);

  @override
  int monthDelta(DateTime startDate, DateTime endDate) =>
      DateUtils.monthDelta(startDate, endDate);

  @override
  DateTime addMonthsToMonthDate(DateTime monthDate, int monthsToAdd) =>
      DateUtils.addMonthsToMonthDate(monthDate, monthsToAdd);

  @override
  DateTime addDaysToDate(DateTime date, int days) =>
      DateUtils.addDaysToDate(date, days);

  @override
  int firstDayOffset(int year, int month, NeutralLocalizations localizations) =>
      DateUtils.firstDayOffset(year, month, localizations);

  @override
  int getDaysInMonth(int year, int month) =>
      DateUtils.getDaysInMonth(year, month);

  @override
  DateTime getMonth(int year, int month) => DateTime(year, month);

  @override
  DateTime getDay(int year, int month, int day) => DateTime(year, month, day);

  @override
  String formatMonthYear(DateTime date, NeutralLocalizations localizations) =>
      localizations.formatMonthYear(date);

  @override
  String formatMediumDate(DateTime date, NeutralLocalizations localizations) =>
      localizations.formatMediumDate(date);

  @override
  String formatShortMonthDay(
    DateTime date,
    NeutralLocalizations localizations,
  ) => localizations.formatShortMonthDay(date);

  @override
  String formatShortDate(DateTime date, NeutralLocalizations localizations) =>
      localizations.formatShortDate(date);

  @override
  String formatFullDate(DateTime date, NeutralLocalizations localizations) =>
      localizations.formatFullDate(date);

  @override
  String formatCompactDate(DateTime date, NeutralLocalizations localizations) =>
      localizations.formatCompactDate(date);

  @override
  DateTime? parseCompactDate(
    String? inputString,
    NeutralLocalizations localizations,
  ) => localizations.parseCompactDate(inputString);

  @override
  String dateHelpText(NeutralLocalizations localizations) =>
      localizations.dateHelpText;
}

/// Calendar arithmetic that avoids elapsed-time errors across daylight saving.
abstract final class DateUtils {
  /// The date of [date], in local time, with its time set to midnight.
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// The dates of [range], in local time, with times set to midnight.
  static DateTimeRange<DateTime> datesOnly(DateTimeRange<DateTime> range) =>
      DateTimeRange<DateTime>(
        start: dateOnly(range.start),
        end: dateOnly(range.end),
      );

  /// Whether dates share a year, month and day, or are both null.
  static bool isSameDay(DateTime? dateA, DateTime? dateB) =>
      isSameMonth(dateA, dateB) && dateA?.day == dateB?.day;

  /// Whether dates share a year and month, or are both null.
  static bool isSameMonth(DateTime? dateA, DateTime? dateB) =>
      dateA?.year == dateB?.year && dateA?.month == dateB?.month;

  /// The signed number of months from [startDate] to [endDate].
  static int monthDelta(DateTime startDate, DateTime endDate) =>
      (endDate.year - startDate.year) * 12 + endDate.month - startDate.month;

  /// Adds months, resetting the day to 1 and time to midnight.
  static DateTime addMonthsToMonthDate(DateTime monthDate, int monthsToAdd) =>
      DateTime(monthDate.year, monthDate.month + monthsToAdd);

  /// Adds calendar days, resetting the time to midnight.
  static DateTime addDaysToDate(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);

  /// Leading blank days before the first day of the month in a calendar grid.
  static int firstDayOffset(
    int year,
    int month,
    NeutralLocalizations localizations,
  ) => (DateTime(year, month).weekday - localizations.firstDayOfWeekIndex) % 7;

  /// The number of days in a proleptic Gregorian month, including leap years.
  static int getDaysInMonth(int year, int month) {
    assert(month >= DateTime.january && month <= DateTime.december);
    if (month == DateTime.february) {
      final bool isLeapYear =
          year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    return const <int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month -
        1];
  }
}

/// Whether the calendar displays days in a month or a grid of years.
enum DatePickerMode {
  /// Select a day within a month.
  day,

  /// Select a year.
  year,
}

/// Calendar or text input, optionally preventing the user from changing modes.
enum DatePickerEntryMode {
  /// Calendar with a switch to text input.
  calendar,

  /// Text input with a switch to the calendar.
  input,

  /// Calendar with no entry mode switch.
  calendarOnly,

  /// Text input with no entry mode switch.
  inputOnly,
}

/// Enables dates based on the date range currently being selected.
typedef SelectableDayForRangePredicate = bool Function(
  DateTime day,
  DateTime? selectedStartDay,
  DateTime? selectedEndDay,
);

/// An inclusive range of dates whose start cannot follow its end.
@immutable
@optionalTypeArgs
class DateTimeRange<T extends DateTime> {
  /// Creates an inclusive date range.
  DateTimeRange({required this.start, required this.end})
    : assert(!start.isAfter(end));

  /// The start of the range.
  final T start;

  /// The end of the range.
  final T end;

  /// Elapsed time between [start] and [end].
  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is DateTimeRange<T> &&
      other.start == start &&
      other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start - $end';
}
