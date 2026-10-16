import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/src/dates/dates.dart';
import 'package:pure_ui/src/localizations/pure_localizations.dart';

class _CustomLocalizations extends DefaultPureLocalizations {
  const _CustomLocalizations();

  @override
  String get cancelButtonLabel => 'Go back';

  @override
  String get dateSeparator => '.';

  @override
  String get anteMeridiemAbbreviation => 'morning';

  @override
  String get postMeridiemAbbreviation => 'afternoon';
}

class _CustomDelegate extends LocalizationsDelegate<PureLocalizations> {
  const _CustomDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<PureLocalizations> load(Locale locale) =>
      Future<PureLocalizations>.value(const _CustomLocalizations());

  @override
  bool shouldReload(_CustomDelegate old) => false;
}

class _ClockLocalizations extends DefaultPureLocalizations {
  const _ClockLocalizations(this.clockFormat);

  final TimeOfDayFormat clockFormat;

  @override
  TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat = false}) =>
      clockFormat;
}

void main() {
  const DefaultPureLocalizations english = DefaultPureLocalizations();

  test('date formats use English names with Sunday-first weekday lists', () {
    final DateTime date = DateTime(2017, 9, 27);
    expect(english.months.length, 12);
    expect(english.shortMonths.length, 12);
    expect(english.weekdays.first, 'Sunday');
    expect(english.shortWeekdays.first, 'Sun');
    expect(english.narrowWeekdays.first, 'S');
    expect(english.firstDayOfWeekIndex, 0);
    expect(() => english.months[0] = 'modified', throwsUnsupportedError);
    expect(english.formatMonthYear(date), 'September 2017');
    expect(english.formatYear(date), '2017');
    expect(english.formatMediumDate(date), 'Wed, Sep 27');
    expect(english.formatFullDate(date), 'Wednesday, September 27, 2017');
    expect(english.formatShortDate(date), 'Sep 27, 2017');
    expect(english.formatShortMonthDay(date), 'Sep 27');
    expect(english.formatCompactDate(date), '09/27/2017');
    expect(english.formatCompactDate(DateTime(5, 1, 2)), '01/02/0005');
    expect(
      english.formatFullDate(DateTime(2023, 1, 1)),
      'Sunday, January 1, 2023',
    );
  });

  test('compact parsing rejects invalid days and unrepresentable dates', () {
    expect(english.parseCompactDate('2/29/2024'), DateTime(2024, 2, 29));
    expect(english.parseCompactDate('02/29/2000'), DateTime(2000, 2, 29));
    expect(english.parseCompactDate('01/02/0005'), DateTime(5, 1, 2));
    for (final String? value in <String?>[
      null,
      '',
      '1/2',
      '1/2/2024/3',
      '2024-01-02',
      'x/2/2024',
      '1/x/2024',
      '1/2/x',
      '0/2/2024',
      '13/2/2024',
      '1/0/2024',
      '1/32/2024',
      '4/31/2024',
      '2/29/1900',
      '2/29/2023',
      '1/1/0',
      '1/1/-1',
      '1/1/999999',
    ]) {
      expect(english.parseCompactDate(value), isNull, reason: '$value');
    }
    for (final DateTime date in <DateTime>[
      DateTime(2024, 2, 29),
      DateTime(2000, 12, 31),
      DateTime(5, 1, 2),
    ]) {
      expect(english.parseCompactDate(english.formatCompactDate(date)), date);
    }
    const _CustomLocalizations custom = _CustomLocalizations();
    expect(custom.formatCompactDate(DateTime(2024, 2, 29)), '02.29.2024');
    expect(custom.parseCompactDate('02.29.2024'), DateTime(2024, 2, 29));
  });

  test('decimal, count badges and remaining characters support boundaries', () {
    expect(english.formatDecimal(0), '0');
    expect(english.formatDecimal(999), '999');
    expect(english.formatDecimal(1000), '1,000');
    expect(english.formatDecimal(-1000000), '-1,000,000');
    expect(
      english.formatDecimal(-9223372036854775808),
      '-9,223,372,036,854,775,808',
    );
    expect(english.formatBadgeCount(0), '0');
    expect(english.formatBadgeCount(99), '99');
    expect(english.formatBadgeCount(100), '99+');
    expect(english.formatBadgeCount(1000, maxCount: 999), '999+');
    expect(
      english.remainingTextFieldCharacterCount(0),
      'No characters remaining',
    );
    expect(
      english.remainingTextFieldCharacterCount(1),
      '1 character remaining',
    );
    expect(
      english.remainingTextFieldCharacterCount(12),
      '12 characters remaining',
    );
    expect(english.tabLabel(tabIndex: 2, tabCount: 5), 'Tab 2 of 5');
  });

  test('time formatting handles midnight, noon and every clock layout', () {
    const TimeOfDay midnight = TimeOfDay(hour: 0, minute: 5);
    const TimeOfDay noon = TimeOfDay(hour: 12, minute: 0);
    const TimeOfDay afternoon = TimeOfDay(hour: 15, minute: 7);
    expect(english.formatTimeOfDay(midnight), '12:05 AM');
    expect(english.formatTimeOfDay(noon), '12:00 PM');
    expect(english.formatTimeOfDay(afternoon), '3:07 PM');
    expect(
      english.formatTimeOfDay(midnight, alwaysUse24HourFormat: true),
      '00:05',
    );
    expect(
      english.formatTimeOfDay(afternoon, alwaysUse24HourFormat: true),
      '15:07',
    );
    expect(
      const _CustomLocalizations().formatTimeOfDay(afternoon),
      '3:07 afternoon',
    );
    const Map<TimeOfDayFormat, String> formats = <TimeOfDayFormat, String>{
      TimeOfDayFormat.HH_colon_mm: '00:05',
      TimeOfDayFormat.HH_dot_mm: '00.05',
      TimeOfDayFormat.frenchCanadian: '00 h 05',
      TimeOfDayFormat.H_colon_mm: '0:05',
      TimeOfDayFormat.h_colon_mm_space_a: '12:05 AM',
      TimeOfDayFormat.a_space_h_colon_mm: 'AM 12:05',
    };
    for (final MapEntry<TimeOfDayFormat, String> format in formats.entries) {
      expect(
        _ClockLocalizations(format.key).formatTimeOfDay(midnight),
        format.value,
      );
    }
  });

  testWidgets('of falls back to English outside a Localizations widget', (
    WidgetTester tester,
  ) async {
    late PureLocalizations resources;
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          resources = PureLocalizations.of(context);
          return const SizedBox.shrink();
        },
      ),
    );
    expect(resources, isA<DefaultPureLocalizations>());
    expect(resources.cancelButtonLabel, 'Cancel');
    expect(resources.okButtonLabel, 'OK');
  });

  testWidgets(
    'a custom delegate overrides defaults and inherits other labels',
    (WidgetTester tester) async {
      late PureLocalizations resources;
      await tester.pumpWidget(
        Localizations(
          locale: const Locale('en'),
          delegates: const <LocalizationsDelegate<dynamic>>[
            _CustomDelegate(),
            DefaultWidgetsLocalizations.delegate,
          ],
          child: Builder(
            builder: (BuildContext context) {
              resources = PureLocalizations.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(resources.cancelButtonLabel, 'Go back');
      expect(resources.okButtonLabel, 'OK');
    },
  );

  test('the delegate loads English resources for English variants', () async {
    const PureLocalizationsDelegate delegate = PureLocalizationsDelegate();
    expect(delegate.isSupported(const Locale('en')), isTrue);
    expect(delegate.isSupported(const Locale('en', 'ZA')), isTrue);
    expect(delegate.isSupported(const Locale('fr')), isFalse);
    expect(delegate.shouldReload(const PureLocalizationsDelegate()), isFalse);
    expect(
      await delegate.load(const Locale('en')),
      isA<DefaultPureLocalizations>(),
    );
    expect(PureLocalizations.delegate, delegate);
    expect(DefaultPureLocalizations.delegate, delegate);
  });
}
