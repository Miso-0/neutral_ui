import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/src/dates/dates.dart';
import 'package:pure_ui/src/localizations/pure_localizations.dart';

class _MondayLocalizations extends DefaultPureLocalizations {
  const _MondayLocalizations();

  @override
  int get firstDayOfWeekIndex => 1;
}

class _CustomDateLocalizations extends DefaultPureLocalizations {
  const _CustomDateLocalizations();

  @override
  String formatYear(DateTime date) => 'year ${date.year}';

  @override
  String formatCompactDate(DateTime date) => 'custom compact';

  @override
  DateTime? parseCompactDate(String? inputString) => DateTime(2040, 4, 5);

  @override
  String get dateHelpText => 'custom date hint';
}

void main() {
  const DefaultPureLocalizations english = DefaultPureLocalizations();
  const GregorianCalendarDelegate calendar = GregorianCalendarDelegate();

  test('date arithmetic crosses months and years and clears time', () {
    final DateTime date = DateTime(2024, 1, 31, 16, 45);
    expect(DateUtils.dateOnly(date), DateTime(2024, 1, 31));
    expect(
      DateUtils.dateOnly(DateTime.utc(2024, 1, 31, 16)),
      DateTime(2024, 1, 31),
    );
    expect(DateUtils.addMonthsToMonthDate(date, 1), DateTime(2024, 2));
    expect(DateUtils.addMonthsToMonthDate(date, -13), DateTime(2022, 12));
    expect(DateUtils.addDaysToDate(date, 30), DateTime(2024, 3, 1));
    expect(DateUtils.addDaysToDate(date, -31), DateTime(2023, 12, 31));
    expect(DateUtils.monthDelta(date, DateTime(2025, 3, 1)), 14);
    expect(DateUtils.monthDelta(date, DateTime(2023, 11, 30)), -2);
  });

  test('date comparisons handle nulls and ignore time', () {
    expect(DateUtils.isSameDay(null, null), isTrue);
    expect(DateUtils.isSameMonth(null, null), isTrue);
    expect(DateUtils.isSameDay(DateTime(2024), null), isFalse);
    expect(DateUtils.isSameMonth(null, DateTime(2024)), isFalse);
    expect(
      DateUtils.isSameDay(DateTime(2024), DateTime(2024, 1, 1, 23)),
      isTrue,
    );
    expect(DateUtils.isSameDay(DateTime(2024), DateTime(2024, 1, 2)), isFalse);
    expect(
      DateUtils.isSameMonth(DateTime(2024), DateTime(2024, 1, 31)),
      isTrue,
    );
    expect(DateUtils.isSameMonth(DateTime(2024), DateTime(2023)), isFalse);
  });

  test('Gregorian month lengths apply century leap-year rules', () {
    expect(DateUtils.getDaysInMonth(2024, 2), 29);
    expect(DateUtils.getDaysInMonth(2023, 2), 28);
    expect(DateUtils.getDaysInMonth(1900, 2), 28);
    expect(DateUtils.getDaysInMonth(2000, 2), 29);
    expect(DateUtils.getDaysInMonth(2100, 2), 28);
    expect(
      <int>[
        for (int month = 1; month <= 12; month += 1)
          DateUtils.getDaysInMonth(2023, month),
      ],
      <int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
    );
  });

  test('first-day offsets follow localized first weekdays', () {
    expect(DateUtils.firstDayOffset(2017, 9, english), 5);
    expect(DateUtils.firstDayOffset(2017, 9, const _MondayLocalizations()), 4);
    expect(DateUtils.firstDayOffset(2023, 1, english), 0);
    expect(DateUtils.firstDayOffset(2023, 1, const _MondayLocalizations()), 6);
    expect(calendar.firstDayOffset(2017, 9, english), 5);
  });

  test(
    'date ranges preserve endpoints, compare by value and clear both times',
    () {
      final DateTimeRange<DateTime> range = DateTimeRange<DateTime>(
        start: DateTime(2024, 2, 28, 12),
        end: DateTime(2024, 3, 1, 15),
      );
      final DateTimeRange<DateTime> equal = DateTimeRange<DateTime>(
        start: DateTime(2024, 2, 28, 12),
        end: DateTime(2024, 3, 1, 15),
      );
      expect(range, equal);
      expect(range.hashCode, equal.hashCode);
      expect(range.duration, const Duration(days: 2, hours: 3));
      expect(range.toString(), '${range.start} - ${range.end}');
      final DateTimeRange<DateTime> dates = DateTimeRange<DateTime>(
        start: DateTime(2024, 2, 28),
        end: DateTime(2024, 3, 1),
      );
      expect(DateUtils.datesOnly(range), dates);
      expect(calendar.datesOnly(range), dates);
      expect(
        DateTimeRange<DateTime>(
          start: DateTime(2024),
          end: DateTime(2024),
        ).duration,
        Duration.zero,
      );
      expect(
        () =>
            DateTimeRange<DateTime>(start: DateTime(2024), end: DateTime(2023)),
        throwsAssertionError,
      );
    },
  );

  test('Gregorian delegate navigates and formats using supplied resources', () {
    final DateTime date = DateTime(2017, 9, 27, 14);
    expect(calendar.getMonth(2024, 2), DateTime(2024, 2));
    expect(calendar.getDay(2024, 2, 29), DateTime(2024, 2, 29));
    expect(calendar.dateOnly(date), DateTime(2017, 9, 27));
    expect(calendar.addDaysToDate(date, 4), DateTime(2017, 10, 1));
    expect(calendar.addMonthsToMonthDate(date, 4), DateTime(2018, 1));
    expect(calendar.monthDelta(date, DateTime(2018, 1)), 4);
    expect(calendar.getDaysInMonth(2024, 2), 29);
    expect(calendar.isSameDay(date, DateTime(2017, 9, 27)), isTrue);
    expect(calendar.isSameMonth(date, DateTime(2017, 9, 30)), isTrue);
    expect(calendar.formatMonthYear(date, english), 'September 2017');
    expect(calendar.formatMediumDate(date, english), 'Wed, Sep 27');
    expect(calendar.formatShortMonthDay(date, english), 'Sep 27');
    expect(calendar.formatShortDate(date, english), 'Sep 27, 2017');
    expect(
      calendar.formatFullDate(date, english),
      'Wednesday, September 27, 2017',
    );
    expect(calendar.formatCompactDate(date, english), '09/27/2017');
    const _CustomDateLocalizations custom = _CustomDateLocalizations();
    expect(calendar.formatYear(2040, custom), 'year 2040');
    expect(calendar.formatCompactDate(date, custom), 'custom compact');
    expect(calendar.parseCompactDate('custom', custom), DateTime(2040, 4, 5));
    expect(calendar.dateHelpText(custom), 'custom date hint');
  });
}
