import 'dart:math' as math;
import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

Finder tooltip(String label) => find.byWidgetPredicate(
  (Widget widget) => widget is IconButton && widget.tooltip == label,
);

void main() {
  final DateTime first = DateTime(2026, 1);
  final DateTime last = DateTime(2027, 12, 31);

  testWidgets('calendar lazily pages months and selects enabled dates', (
    WidgetTester tester,
  ) async {
    DateTime? selected;
    await pumpNeutral(
      tester,
      CalendarDatePicker(
        initialDate: DateTime(2026, 10, 16),
        firstDate: first,
        lastDate: last,
        selectableDayPredicate: (DateTime date) => date.day != 18,
        onDateChanged: (DateTime date) {
          selected = date;
        },
      ),
    );
    expect(find.text('October 2026'), findsOneWidget);
    await tester.tap(find.byKey(ValueKey<DateTime>(DateTime(2026, 10, 18))));
    expect(selected, isNull);
    await tester.tap(find.byKey(ValueKey<DateTime>(DateTime(2026, 10, 19))));
    expect(selected, DateTime(2026, 10, 19));
    await tester.tap(tooltip('Next month'));
    await tester.pumpAndSettle();
    expect(find.text('November 2026'), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('December 2027'), findsNothing);
  });

  testWidgets('calendar keyboard skips disabled dates across month boundary', (
    WidgetTester tester,
  ) async {
    DateTime? selected;
    await pumpNeutral(
      tester,
      CalendarDatePicker(
        initialDate: DateTime(2026, 10, 31),
        firstDate: first,
        lastDate: last,
        selectableDayPredicate: (DateTime date) =>
            date != DateTime(2026, 11, 1),
        autofocus: true,
        onDateChanged: (DateTime date) {
          selected = date;
        },
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(selected, DateTime(2026, 11, 2));
    expect(find.text('November 2026'), findsOneWidget);
  });

  testWidgets('calendar mirrors horizontal keyboard navigation in RTL', (
    WidgetTester tester,
  ) async {
    DateTime? selected;
    await pumpNeutral(
      tester,
      CalendarDatePicker(
        initialDate: DateTime(2026, 10, 16),
        firstDate: first,
        lastDate: last,
        autofocus: true,
        onDateChanged: (DateTime date) {
          selected = date;
        },
      ),
      textDirection: TextDirection.rtl,
    );
    final Offset day15 = tester.getCenter(
      find.byKey(ValueKey<DateTime>(DateTime(2026, 10, 15))),
    );
    final Offset day16 = tester.getCenter(
      find.byKey(ValueKey<DateTime>(DateTime(2026, 10, 16))),
    );
    expect(day15.dx, greaterThan(day16.dx));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(selected, DateTime(2026, 10, 15));
  });

  testWidgets('calendar day semantics include complete date and today', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await pumpNeutral(
      tester,
      CalendarDatePicker(
        initialDate: DateTime(2026, 10, 16),
        currentDate: DateTime(2026, 10, 16),
        firstDate: first,
        lastDate: last,
        onDateChanged: (DateTime date) {},
      ),
    );
    expect(
      find.bySemanticsLabel('16, Friday, October 16, 2026, Today'),
      findsOneWidget,
    );
    expect(
      tester
          .getSemantics(find.byKey(ValueKey<DateTime>(DateTime(2026, 10, 16))))
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    semantics.dispose();
  });

  testWidgets(
    'year mode scrolls to current selection and returns to day mode',
    (WidgetTester tester) async {
      await pumpNeutral(
        tester,
        CalendarDatePicker(
          initialDate: DateTime(2026, 10, 16),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          initialCalendarMode: DatePickerMode.year,
          onDateChanged: (DateTime date) {},
        ),
      );
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('1900'), findsNothing);
      await tester.tap(find.text('2027'));
      await tester.pumpAndSettle();
      expect(find.text('October 2027'), findsOneWidget);
    },
  );

  testWidgets(
    'date input parses, rejects invalid and out of range, then saves',
    (WidgetTester tester) async {
      final GlobalKey<FormState> form = GlobalKey<FormState>();
      DateTime? saved;
      await pumpNeutral(
        tester,
        SizedBox(
          width: 320,
          child: Form(
            key: form,
            child: InputDatePickerFormField(
              firstDate: first,
              lastDate: last,
              onDateSaved: (DateTime date) {
                saved = date;
              },
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), '02/30/2026');
      expect(form.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Invalid format.'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), '01/01/2025');
      expect(form.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Out of range.'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), '10/16/2026');
      expect(form.currentState!.validate(), isTrue);
      form.currentState!.save();
      expect(saved, DateTime(2026, 10, 16));
    },
  );

  testWidgets('date modal validates input before returning its result', (
    WidgetTester tester,
  ) async {
    DateTime? result;
    await pumpNeutralApp(
      tester,
      Builder(
        builder: (BuildContext context) => TextButton(
          onPressed: () async {
            result = await showDatePicker(
              context: context,
              firstDate: first,
              lastDate: last,
              initialEntryMode: DatePickerEntryMode.inputOnly,
            );
          },
          child: const Text('Open'),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), 'bad');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    expect(result, isNull);
    await tester.enterText(find.byType(EditableText), '10/16/2026');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(result, DateTime(2026, 10, 16));
  });

  testWidgets('anchored date field passes outside taps through and dismisses', (
    WidgetTester tester,
  ) async {
    int taps = 0;
    await pumpNeutral(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 320,
            child: DatePickerField(
              value: DateTime(2026, 10, 16),
              firstDate: first,
              lastDate: last,
            ),
          ),
          const SizedBox(height: 400),
          TextButton(
            onPressed: () {
              taps++;
            },
            child: const Text('Outside'),
          ),
        ],
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsOneWidget);
    await tester.tap(find.text('Outside'));
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(find.byType(CalendarDatePicker), findsNothing);
  });

  testWidgets(
    'range calendar selects endpoints and skips disabled days by keyboard',
    (WidgetTester tester) async {
      DateTimeRange<DateTime>? selected;
      await pumpNeutral(
        tester,
        SizedBox(
          height: 380,
          child: CalendarDateRangePicker(
            firstDate: DateTime(2026, 10),
            lastDate: DateTime(2026, 11, 30),
            initialStartDate: DateTime(2026, 10, 16),
            selectableDayPredicate: (
              DateTime date,
              DateTime? start,
              DateTime? end,
            ) => date.day != 17,
            onChanged: (DateTimeRange<DateTime> range) {
              selected = range;
            },
            autofocus: true,
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(
        selected,
        DateTimeRange<DateTime>(
          start: DateTime(2026, 10, 16),
          end: DateTime(2026, 10, 18),
        ),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('range input refuses an inverted range', (
    WidgetTester tester,
  ) async {
    DateTimeRange<DateTime>? selected;
    await pumpNeutralApp(
      tester,
      Builder(
        builder: (BuildContext context) => TextButton(
          onPressed: () async {
            selected = await showDateRangePicker(
              context: context,
              firstDate: first,
              lastDate: last,
              initialEntryMode: DatePickerEntryMode.inputOnly,
            );
          },
          child: const Text('Open'),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(0), '10/20/2026');
    await tester.enterText(find.byType(EditableText).at(1), '10/16/2026');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Invalid range.'), findsOneWidget);
    expect(selected, isNull);
    await tester.enterText(find.byType(EditableText).at(1), '10/22/2026');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      selected,
      DateTimeRange<DateTime>(
        start: DateTime(2026, 10, 20),
        end: DateTime(2026, 10, 22),
      ),
    );
  });

  testWidgets(
    'time dial tracks drag continuously and taps snap to five minutes',
    (WidgetTester tester) async {
      TimeOfDay? selected;
      await pumpNeutral(
        tester,
        TimePicker(
          initialTime: const TimeOfDay(hour: 10, minute: 0),
          alwaysUse24HourFormat: true,
          onTimeChanged: (TimeOfDay time) {
            selected = time;
          },
        ),
      );
      await tester.tap(find.text('00').first);
      await tester.pumpAndSettle();
      final Finder dial = find.byKey(
        const ValueKey<String>('neutral-time-dial'),
      );
      final Offset center = tester.getCenter(dial);
      final Offset pointer = center + const Offset(70, -50);
      final TestGesture gesture = await tester.startGesture(
        center + const Offset(0, -90),
      );
      await gesture.moveTo(pointer);
      await tester.pump();
      final double turns = math.atan2(70, 50) / (2 * math.pi);
      expect(selected?.minute, (turns * 60).round());
      expect(
        find.byKey(const ValueKey<String>('neutral-time-hand')),
        paints..something(
          (Symbol method, List<dynamic> arguments) =>
              method == #drawLine &&
              ((arguments[0] as Offset) - const Offset(128, 128)).distance <
                  1e-6 &&
              ((arguments[1] as Offset) - const Offset(198, 78)).distance <
                  1e-6,
        ),
      );
      await gesture.up();
      await tester.pumpAndSettle();
      await tester.tapAt(center + const Offset(64, -90));
      await tester.pumpAndSettle();
      expect(selected?.minute, 5);
    },
  );

  testWidgets('24-hour dial supports inner ring and time input validates', (
    WidgetTester tester,
  ) async {
    final GlobalKey<TimePickerState> key = GlobalKey<TimePickerState>();
    await pumpNeutral(
      tester,
      TimePicker(
        key: key,
        initialTime: const TimeOfDay(hour: 15, minute: 45),
        alwaysUse24HourFormat: true,
        onTimeChanged: (TimeOfDay time) {},
      ),
    );
    final Offset center = tester.getCenter(
      find.byKey(const ValueKey<String>('neutral-time-dial')),
    );
    await tester.tapAt(center + const Offset(70, 0));
    await tester.pumpAndSettle();
    expect(key.currentState!.selectedTime.hour, 15);
    await tester.tap(tooltip('Switch to text input mode'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(0), '24');
    expect(key.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Enter a valid time'), findsOneWidget);
    await tester.enterText(find.byType(EditableText).at(0), '23');
    expect(key.currentState!.validate(), isTrue);
    expect(key.currentState!.selectedTime.hour, 23);
  });

  testWidgets('reduced motion changes calendar months immediately', (
    WidgetTester tester,
  ) async {
    await pumpNeutralApp(
      tester,
      CalendarDatePicker(
        initialDate: DateTime(2026, 10, 16),
        firstDate: first,
        lastDate: last,
        onDateChanged: (DateTime date) {},
        style: const DatePickerStyle(animationDuration: Duration(seconds: 5)),
      ),
      disableAnimations: true,
    );
    await tester.tap(tooltip('Next month'));
    await tester.pump();
    expect(find.text('November 2026'), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 0);
  });
  testWidgets(
    'month retargeting continues from the current page without a jump',
    (WidgetTester tester) async {
      await pumpNeutral(
        tester,
        CalendarDatePicker(
          initialDate: DateTime(2026, 10, 16),
          firstDate: first,
          lastDate: last,
          onDateChanged: (DateTime date) {},
        ),
      );
      final PageController pages = tester
          .widget<PageView>(find.byType(PageView))
          .controller!;
      await tester.tap(tooltip('Next month'));
      await tester.pump(const Duration(milliseconds: 40));
      await tester.pump(const Duration(milliseconds: 40));
      final double before = pages.page!;
      expect(before, greaterThan(9));
      expect(before, lessThan(10));
      await tester.tap(tooltip('Next month'));
      expect(pages.page, closeTo(before, 1e-9));
      final List<double> samples = await sampleValues(
        tester,
        () => pages.page!,
        duration: const Duration(milliseconds: 220),
      );
      expectMonotonicValues(samples, from: before, to: 11);
      await tester.pumpAndSettle();
      expect(find.text('December 2026'), findsOneWidget);
    },
  );

  testWidgets('calendar hover rebuilds its cell without rebuilding the month', (
    WidgetTester tester,
  ) async {
    int predicateCalls = 0;
    await pumpNeutral(
      tester,
      CalendarDatePicker(
        initialDate: DateTime(2026, 10, 16),
        firstDate: first,
        lastDate: last,
        selectableDayPredicate: (DateTime date) {
          predicateCalls++;
          return true;
        },
        onDateChanged: (DateTime date) {},
      ),
    );
    final int before = predicateCalls;
    final TestGesture mouse = await hover(
      tester,
      find.byKey(ValueKey<DateTime>(DateTime(2026, 10, 20))),
    );
    await tester.pumpAndSettle();
    expect(predicateCalls, before);
    await mouse.removePointer();
  });

  testWidgets('Tab leaves the calendar grid as one focus stop', (
    WidgetTester tester,
  ) async {
    final FocusNode after = FocusNode();
    addTearDown(after.dispose);
    await pumpNeutral(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CalendarDatePicker(
            initialDate: DateTime(2026, 10, 16),
            firstDate: first,
            lastDate: last,
            onDateChanged: (DateTime date) {},
            autofocus: true,
          ),
          TextButton(
            focusNode: after,
            onPressed: () {},
            child: const Text('After calendar'),
          ),
        ],
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(after.hasFocus, isTrue);
  });

  testWidgets(
    'anchored date picker retains its exit and restores focus on Escape',
    (WidgetTester tester) async {
      final FocusNode field = FocusNode();
      addTearDown(field.dispose);
      await pumpNeutral(
        tester,
        SizedBox(
          width: 320,
          child: DatePickerField(
            focusNode: field,
            value: DateTime(2026, 10, 16),
            firstDate: first,
            lastDate: last,
          ),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump(const Duration(milliseconds: 40));
      expect(find.byType(CalendarDatePicker), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(CalendarDatePicker), findsNothing);
      expect(field.hasFocus, isTrue);
    },
  );

  testWidgets('outside focus changes survive date picker dismissal', (
    WidgetTester tester,
  ) async {
    final FocusNode outside = FocusNode();
    addTearDown(outside.dispose);
    await pumpNeutral(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 320,
            child: DatePickerField(
              value: DateTime(2026, 10, 16),
              firstDate: first,
              lastDate: last,
            ),
          ),
          const SizedBox(height: 400),
          TextButton(
            focusNode: outside,
            onPressed: outside.requestFocus,
            child: const Text('Outside focus'),
          ),
        ],
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Outside focus'));
    await tester.pumpAndSettle();
    expect(outside.hasFocus, isTrue);
  });

  testWidgets('date picker consume token prevents underlying activation', (
    WidgetTester tester,
  ) async {
    int taps = 0;
    await pumpNeutral(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 320,
            child: DatePickerField(
              value: DateTime(2026, 10, 16),
              firstDate: first,
              lastDate: last,
              style: const DatePickerStyle(
                outsideTapBehavior: OutsideTapBehavior.consume,
              ),
            ),
          ),
          const SizedBox(height: 400),
          TextButton(
            onPressed: () {
              taps++;
            },
            child: const Text('Outside consume'),
          ),
        ],
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Outside consume'));
    await tester.pumpAndSettle();
    expect(taps, 0);
    expect(find.byType(CalendarDatePicker), findsNothing);
  });

  testWidgets('12-hour time picker preserves minutes while changing period', (
    WidgetTester tester,
  ) async {
    TimeOfDay? selected;
    await pumpNeutral(
      tester,
      TimePicker(
        initialTime: const TimeOfDay(hour: 3, minute: 17),
        alwaysUse24HourFormat: false,
        onTimeChanged: (TimeOfDay time) {
          selected = time;
        },
      ),
    );
    await tester.tap(find.text('PM'));
    await tester.pumpAndSettle();
    expect(selected, const TimeOfDay(hour: 15, minute: 17));
  });
  testWidgets('time segment semantic adjustments change the selected time', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    TimeOfDay? selected;
    await pumpNeutral(
      tester,
      TimePicker(
        initialTime: const TimeOfDay(hour: 3, minute: 17),
        alwaysUse24HourFormat: false,
        onTimeChanged: (TimeOfDay time) {
          selected = time;
        },
      ),
    );
    final Finder hour = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Semantics && widget.properties.label == 'Hour',
    );
    final int id = tester.getSemantics(hour).id;
    tester.binding.renderViews.single.owner!.semanticsOwner!.performAction(
      id,
      SemanticsAction.increase,
    );
    await tester.pumpAndSettle();
    expect(selected, const TimeOfDay(hour: 4, minute: 17));
    tester.binding.renderViews.single.owner!.semanticsOwner!.performAction(
      id,
      SemanticsAction.decrease,
    );
    await tester.pumpAndSettle();
    expect(selected, const TimeOfDay(hour: 3, minute: 17));
    semantics.dispose();
  });

  testWidgets('time modal validates input and returns the confirmed time', (
    WidgetTester tester,
  ) async {
    TimeOfDay? selected;
    await pumpNeutralApp(
      tester,
      Builder(
        builder: (BuildContext context) => TextButton(
          onPressed: () async {
            selected = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 15, minute: 17),
              initialEntryMode: TimePickerEntryMode.inputOnly,
              builder: (BuildContext context, Widget? child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              ),
            );
          },
          child: const Text('Open time'),
        ),
      ),
    );
    await tester.tap(find.text('Open time'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).at(1), '67');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsOneWidget);
    expect(selected, isNull);
    await tester.enterText(find.byType(EditableText).at(1), '27');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(selected, const TimeOfDay(hour: 15, minute: 27));
  });

  testWidgets(
    'date field uses the root overlay inside a smaller nested overlay',
    (WidgetTester tester) async {
      await pumpNeutral(
        tester,
        SizedBox(
          width: 200,
          height: 60,
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (BuildContext context) => DatePickerField(
                  value: DateTime(2026, 10, 16),
                  firstDate: first,
                  lastDate: last,
                ),
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(CalendarDatePicker)).width, 336);
      expect(
        tester.getSize(find.byType(CalendarDatePicker)).height,
        greaterThan(60),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
