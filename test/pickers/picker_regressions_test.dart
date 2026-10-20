import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('calendar normalizes bounds before checking same-day times', (
    WidgetTester tester,
  ) async {
    DateTime? selected;
    await pumpNeutral(
      tester,
      CalendarDatePicker(
        initialDate: DateTime(2026, 10, 16, 8),
        firstDate: DateTime(2026, 10, 16, 12),
        lastDate: DateTime(2026, 10, 16, 6),
        selectableDayPredicate: (DateTime date) => date.hour == 0,
        onDateChanged: (DateTime date) {
          selected = date;
        },
      ),
    );
    await tester.tap(find.byKey(ValueKey<DateTime>(DateTime(2026, 10, 16))));
    expect(selected, DateTime(2026, 10, 16));
  });

  testWidgets(
    'calendar month controls keep subsequent keyboard selection visible',
    (WidgetTester tester) async {
      DateTime? selected;
      await pumpNeutral(
        tester,
        CalendarDatePicker(
          initialDate: DateTime(2026, 10, 31),
          firstDate: DateTime(2026),
          lastDate: DateTime(2027),
          autofocus: true,
          selectableDayPredicate: (DateTime date) =>
              date != DateTime(2026, 11, 30),
          onDateChanged: (DateTime date) {
            selected = date;
          },
        ),
      );
      final IconButton next = tester.widget<IconButton>(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is IconButton && widget.tooltip == 'Next month',
        ),
      );
      next.onPressed!();
      await tester.pumpAndSettle();
      expect(find.text('November 2026'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(selected, DateTime(2026, 11, 29));
    },
  );

  testWidgets('calendar rebases its page when selectable bounds change', (
    WidgetTester tester,
  ) async {
    late StateSetter update;
    DateTime first = DateTime(2026);
    DateTime last = DateTime(2027);
    DateTime? selected;
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return CalendarDatePicker(
            initialDate: null,
            currentDate: DateTime(2026, 10, 16),
            firstDate: first,
            lastDate: last,
            autofocus: true,
            onDateChanged: (DateTime date) {
              selected = date;
            },
          );
        },
      ),
    );
    update(() {
      first = DateTime(2026, 11, 10);
      last = DateTime(2026, 11, 20);
    });
    await tester.pumpAndSettle();
    expect(find.text('November 2026'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(selected, DateTime(2026, 11, 10));
  });

  testWidgets('date field Escape works inside a navigator route', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 320,
        child: DatePickerField(
          focusNode: node,
          value: DateTime(2026, 10, 16),
          firstDate: DateTime(2026),
          lastDate: DateTime(2027),
        ),
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsNothing);
    expect(node.hasFocus, isTrue);
  });

  testWidgets('changing period preserves edited time input', (
    WidgetTester tester,
  ) async {
    final GlobalKey<TimePickerState> key = GlobalKey<TimePickerState>();
    await pumpNeutral(
      tester,
      TimePicker(
        key: key,
        initialTime: const TimeOfDay(hour: 3, minute: 17),
        initialEntryMode: TimePickerEntryMode.inputOnly,
        alwaysUse24HourFormat: false,
        onTimeChanged: (TimeOfDay time) {},
      ),
    );
    await tester.enterText(find.byType(EditableText).at(0), '7');
    await tester.enterText(find.byType(EditableText).at(1), '45');
    await tester.tap(find.text('PM'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).at(0))
          .controller
          .text,
      '7',
    );
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).at(1))
          .controller
          .text,
      '45',
    );
    expect(key.currentState!.validate(), isTrue);
    expect(
      key.currentState!.selectedTime,
      const TimeOfDay(hour: 19, minute: 45),
    );
  });

  testWidgets(
    'ambient time-format changes update input without changing selected time',
    (WidgetTester tester) async {
      final GlobalKey<TimePickerState> key = GlobalKey<TimePickerState>();
      late StateSetter update;
      bool use24 = false;
      await pumpNeutral(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            update = setState;
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(alwaysUse24HourFormat: use24),
              child: TimePicker(
                key: key,
                initialTime: const TimeOfDay(hour: 15, minute: 17),
                initialEntryMode: TimePickerEntryMode.inputOnly,
                onTimeChanged: (TimeOfDay time) {},
              ),
            );
          },
        ),
      );
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).at(0))
            .controller
            .text,
        '3',
      );
      update(() {
        use24 = true;
      });
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).at(0))
            .controller
            .text,
        '15',
      );
      expect(key.currentState!.validate(), isTrue);
      expect(
        key.currentState!.selectedTime,
        const TimeOfDay(hour: 15, minute: 17),
      );
    },
  );
  testWidgets(
    'date modals return normalized dates and ranges without new selection',
    (WidgetTester tester) async {
      late BuildContext launch;
      await pumpNeutralApp(
        tester,
        Builder(
          builder: (BuildContext context) {
            launch = context;
            return const Text('Launch');
          },
        ),
      );
      final Future<DateTime?> date = showDatePicker(
        context: launch,
        initialDate: DateTime(2026, 10, 16, 8),
        firstDate: DateTime(2026, 10, 16, 12),
        lastDate: DateTime(2026, 10, 16, 6),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(await date, DateTime(2026, 10, 16));
      final Future<DateTimeRange<DateTime>?> range = showDateRangePicker(
        context: launch,
        initialDateRange: DateTimeRange<DateTime>(
          start: DateTime(2026, 10, 16, 8),
          end: DateTime(2026, 10, 18, 18),
        ),
        firstDate: DateTime(2026, 10, 16, 12),
        lastDate: DateTime(2026, 10, 18, 6),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(
        await range,
        DateTimeRange<DateTime>(
          start: DateTime(2026, 10, 16),
          end: DateTime(2026, 10, 18),
        ),
      );
    },
  );

  testWidgets(
    'custom compact-date parsing is normalized before bounds validation',
    (WidgetTester tester) async {
      final GlobalKey<InputDatePickerFormFieldState> key =
          GlobalKey<InputDatePickerFormFieldState>();
      DateTime? saved;
      await pumpNeutral(
        tester,
        SizedBox(
          width: 300,
          child: InputDatePickerFormField(
            key: key,
            firstDate: DateTime(2026, 10, 16),
            lastDate: DateTime(2026, 10, 16),
            calendarDelegate: const _NoonParser(),
            onDateSaved: (DateTime date) {
              saved = date;
            },
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'Custom date');
      expect(key.currentState!.validate(), isTrue);
      key.currentState!.save();
      expect(saved, DateTime(2026, 10, 16));
    },
  );

  testWidgets(
    'compact date input follows a changed initial date and clears to null',
    (WidgetTester tester) async {
      late StateSetter update;
      DateTime? date = DateTime(2026, 10, 16);
      await pumpNeutral(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            update = setState;
            return SizedBox(
              width: 300,
              child: InputDatePickerFormField(
                initialDate: date,
                firstDate: DateTime(2026),
                lastDate: DateTime(2027),
              ),
            );
          },
        ),
      );
      update(() {
        date = DateTime(2026, 10, 20);
      });
      await tester.pumpAndSettle();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        '10/20/2026',
      );
      update(() {
        date = null;
      });
      await tester.pumpAndSettle();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        isEmpty,
      );
    },
  );

  testWidgets('explicit time format changes preserve user-selected periods', (
    WidgetTester tester,
  ) async {
    final GlobalKey<TimePickerState> key = GlobalKey<TimePickerState>();
    late StateSetter update;
    bool use24 = false;
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return TimePicker(
            key: key,
            initialTime: const TimeOfDay(hour: 3, minute: 17),
            alwaysUse24HourFormat: use24,
            onTimeChanged: (TimeOfDay time) {},
          );
        },
      ),
    );
    await tester.tap(find.text('PM'));
    await tester.pumpAndSettle();
    expect(key.currentState!.selectedTime.hour, 15);
    update(() {
      use24 = true;
    });
    await tester.pumpAndSettle();
    expect(key.currentState!.selectedTime.hour, 15);
    expect(find.text('PM'), findsNothing);
  });

  testWidgets('range input remains scrollable with a large keyboard inset', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      NeutralApp(
        color: const Color(0xffffffff),
        builder: (BuildContext context, Widget? child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(viewInsets: const EdgeInsets.only(bottom: 500)),
          child: child!,
        ),
        home: Builder(
          builder: (BuildContext context) => TextButton(
            onPressed: () {
              showDateRangePicker(
                context: context,
                firstDate: DateTime(2026),
                lastDate: DateTime(2027),
                initialEntryMode: DatePickerEntryMode.inputOnly,
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byType(DateRangePickerDialog),
        matching: find.byType(SingleChildScrollView),
      ),
      findsOneWidget,
    );
  });

  testWidgets('virtual day focus exposes a live semantic announcement', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      CalendarDatePicker(
        initialDate: DateTime(2026, 10, 16),
        firstDate: DateTime(2026),
        lastDate: DateTime(2027),
        autofocus: true,
        onDateChanged: (DateTime date) {},
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Semantics &&
            widget.properties.focused == true &&
            widget.properties.liveRegion == true &&
            (widget.properties.label?.startsWith('17,') ?? false),
      ),
      findsOneWidget,
    );
  });
  testWidgets('year picker scrolls to selection using inherited year extent', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      SizedBox(
        width: 336,
        height: 220,
        child: YearPicker(
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          selectedDate: DateTime(2080),
          onChanged: (DateTime date) {},
        ),
      ),
      theme: const ThemeData(datePickerStyle: DatePickerStyle(yearExtent: 96)),
    );
    expect(find.text('2080'), findsOneWidget);
    final Rect viewport = tester.getRect(find.byType(GridView));
    expect(viewport.overlaps(tester.getRect(find.text('2080'))), isTrue);
  });

  testWidgets(
    'localized time digits validate and semantic adjustments stay localized',
    (WidgetTester tester) async {
      final GlobalKey<TimePickerState> key = GlobalKey<TimePickerState>();
      bool input = false;
      late StateSetter update;
      await pumpNeutral(
        tester,
        Builder(
          builder: (BuildContext context) => Localizations.override(
            context: context,
            delegates: const <LocalizationsDelegate<dynamic>>[
              _DigitsDelegate(),
            ],
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                update = setState;
                return TimePicker(
                  key: key,
                  initialTime: const TimeOfDay(hour: 3, minute: 17),
                  initialEntryMode: input
                      ? TimePickerEntryMode.inputOnly
                      : TimePickerEntryMode.dial,
                  alwaysUse24HourFormat: false,
                  onTimeChanged: (TimeOfDay time) {},
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final Semantics hour = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Semantics && widget.properties.label == 'Hour',
        ),
      );
      expect(hour.properties.increasedValue, '٤');
      await tester.tap(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is IconButton &&
              widget.tooltip ==
                  const DefaultNeutralLocalizations().inputTimeModeButtonLabel,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).at(0))
            .controller
            .text,
        '٣',
      );
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).at(1))
            .controller
            .text,
        '١٧',
      );
      expect(key.currentState!.validate(), isTrue);
      expect(
        key.currentState!.selectedTime,
        const TimeOfDay(hour: 3, minute: 17),
      );
      update(() {
        input = true;
      });
      await tester.pumpAndSettle();
    },
  );
}

class _NoonParser extends GregorianCalendarDelegate {
  const _NoonParser();
  @override
  DateTime? parseCompactDate(
    String? inputString,
    NeutralLocalizations localizations,
  ) => inputString == 'Custom date' ? DateTime(2026, 10, 16, 12) : null;
}

class _DigitsLocalizations extends DefaultNeutralLocalizations {
  const _DigitsLocalizations();
  @override
  String formatDecimal(int number) => number
      .toString()
      .split('')
      .map((String digit) => '٠١٢٣٤٥٦٧٨٩'[int.parse(digit)])
      .join();
  @override
  String formatMinute(TimeOfDay timeOfDay) =>
      formatDecimal(timeOfDay.minute).padLeft(2, '٠');
}

class _DigitsDelegate extends LocalizationsDelegate<NeutralLocalizations> {
  const _DigitsDelegate();
  @override
  bool isSupported(Locale locale) => true;
  @override
  Future<NeutralLocalizations> load(Locale locale) =>
      Future<NeutralLocalizations>.value(const _DigitsLocalizations());
  @override
  bool shouldReload(_DigitsDelegate old) => false;
}
