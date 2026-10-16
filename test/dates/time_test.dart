import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/src/dates/dates.dart';

void main() {
  test('AM and PM hours include midnight and noon', () {
    const TimeOfDay midnight = TimeOfDay(hour: 0, minute: 5);
    const TimeOfDay noon = TimeOfDay(hour: 12, minute: 30);
    const TimeOfDay evening = TimeOfDay(hour: 23, minute: 59);
    expect(midnight.period, DayPeriod.am);
    expect(midnight.periodOffset, 0);
    expect(midnight.hourOfPeriod, 12);
    expect(noon.period, DayPeriod.pm);
    expect(noon.periodOffset, 12);
    expect(noon.hourOfPeriod, 12);
    expect(evening.hourOfPeriod, 11);
    expect(midnight.toString(), 'TimeOfDay(00:05)');
    expect(evening.toString(), 'TimeOfDay(23:59)');
  });

  test(
    'comparison and replacement ignore date and respect minute ordering',
    () {
      const TimeOfDay first = TimeOfDay(hour: 8, minute: 15);
      const TimeOfDay laterMinute = TimeOfDay(hour: 8, minute: 16);
      const TimeOfDay laterHour = TimeOfDay(hour: 9, minute: 0);
      expect(first.isBefore(laterMinute), isTrue);
      expect(laterMinute.isBefore(laterHour), isTrue);
      expect(laterHour.isAfter(first), isTrue);
      expect(first.isAtSameTimeAs(first.replacing()), isTrue);
      expect(first.replacing(hour: 9, minute: 0), laterHour);
      expect(first.hashCode, first.replacing().hashCode);
      expect(TimeOfDay.fromDateTime(DateTime.utc(2024, 1, 1, 8, 15)), first);
      expect(() => first.replacing(hour: 24), throwsAssertionError);
      expect(() => first.replacing(minute: -1), throwsAssertionError);
    },
  );

  testWidgets(
    'format uses the MediaQuery 24-hour preference with English fallback',
    (WidgetTester tester) async {
      late String label;
      Widget app(bool always24) => MediaQuery(
        data: MediaQueryData(alwaysUse24HourFormat: always24),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (BuildContext context) {
              label = const TimeOfDay(hour: 15, minute: 7).format(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pumpWidget(app(false));
      expect(label, '3:07 PM');
      await tester.pumpWidget(app(true));
      expect(label, '15:07');
    },
  );

  test('hour representations cover all supported localized clock layouts', () {
    for (final TimeOfDayFormat format in TimeOfDayFormat.values) {
      expect(hourFormat(of: format), switch (format) {
        TimeOfDayFormat.H_colon_mm => HourFormat.H,
        TimeOfDayFormat.h_colon_mm_space_a ||
        TimeOfDayFormat.a_space_h_colon_mm => HourFormat.h,
        _ => HourFormat.HH,
      });
    }
  });
}
