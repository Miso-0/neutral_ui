import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import 'package:neutral_ui_example/examples/feedback/alert_dialog_example.dart';
import 'package:neutral_ui_example/examples/feedback/bottom_sheet_example.dart';
import 'package:neutral_ui_example/examples/feedback/simple_dialog_example.dart';
import 'package:neutral_ui_example/examples/feedback/snack_bar_example.dart';
import 'package:neutral_ui_example/examples/input/autocomplete_example.dart';
import 'package:neutral_ui_example/examples/input/full_screen_search_example.dart';
import 'package:neutral_ui_example/examples/input/password_example.dart';
import 'package:neutral_ui_example/examples/input/search_bar_example.dart';
import 'package:neutral_ui_example/examples/input/text_field_example.dart';
import 'package:neutral_ui_example/examples/input/validated_field_example.dart';
import 'package:neutral_ui_example/examples/pickers/calendar_date_picker_example.dart';
import 'package:neutral_ui_example/examples/pickers/calendar_date_range_picker_example.dart';
import 'package:neutral_ui_example/examples/pickers/date_picker_field_example.dart';
import 'package:neutral_ui_example/examples/pickers/modal_date_picker_example.dart';
import 'package:neutral_ui_example/examples/pickers/modal_date_range_picker_example.dart';
import 'package:neutral_ui_example/examples/pickers/modal_time_picker_example.dart';
import 'package:neutral_ui_example/examples/pickers/time_picker_example.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget example, {
  TextDirection direction = TextDirection.ltr,
  bool reducedMotion = false,
  double width = 360,
}) async {
  await tester.pumpWidget(
    NeutralApp(
      color: const Color(0xFFF4F7F3),
      theme: const ThemeData(),
      builder: (BuildContext context, Widget? child) => Directionality(
        textDirection: direction,
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: reducedMotion),
          child: child!,
        ),
      ),
      home: Center(
        child: SingleChildScrollView(
          child: SizedBox(width: width, child: example),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('text fields clear, reveal passwords and validate forms', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const TextFieldExample());
    await tester.enterText(find.byType(EditableText), 'Ocean');
    await tester.pump();
    expect(find.text('Project: Ocean'), findsOneWidget);
    await tester.tap(find.byType(CloseGlyph));
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      isEmpty,
    );
    expect(find.text('Project: '), findsOneWidget);

    await _pump(tester, const PasswordExample());
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isTrue,
    );
    await tester.tap(find.byType(EyeGlyph));
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isFalse,
    );

    await _pump(tester, const ValidatedFieldExample());
    await tester.enterText(find.byType(EditableText), 'invalid');
    await tester.pump();
    expect(find.text('Enter an email address'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'person@example.com');
    await tester.tap(find.text('Save email'));
    await tester.pump();
    expect(find.text('Enter an email address'), findsNothing);
    expect(find.text('Saved: person@example.com'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('autocomplete filters options and keeps its selection locally', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const AutocompleteExample());
    await tester.enterText(find.byType(EditableText), 'Town');
    await tester.pumpAndSettle();
    expect(find.text('Cape Town'), findsOneWidget);
    expect(find.text('Durban'), findsNothing);
    await tester.tap(find.text('Cape Town'));
    await tester.pumpAndSettle();
    expect(find.text('City: Cape Town'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final bool fullScreen in <bool>[false, true]) {
    testWidgets(
      'search filters and selects in ${fullScreen ? 'full screen' : 'a docked panel'}',
      (WidgetTester tester) async {
        await _pump(
          tester,
          fullScreen
              ? const FullScreenSearchExample()
              : const SearchBarExample(),
        );
        await tester.tap(find.byType(EditableText));
        await tester.pumpAndSettle();
        expect(find.text('Design systems'), findsOneWidget);
        await tester.enterText(find.byType(EditableText).last, 'research');
        await tester.pumpAndSettle();
        expect(find.text('Design systems'), findsNothing);
        await tester.tap(find.text('Research'));
        await tester.pumpAndSettle();
        expect(find.text('Research'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('dialog, simple dialog, sheet and snack bar complete actions', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const AlertDialogExample());
    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Create a workspace?'), findsOneWidget);
    await tester.tap(find.text('Create workspace'));
    await tester.pumpAndSettle();
    expect(find.text('Workspace created'), findsOneWidget);

    await _pump(tester, const SimpleDialogExample());
    await tester.tap(find.text('Simple dialog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Team workspace'));
    await tester.pumpAndSettle();
    expect(find.text('Team workspace'), findsOneWidget);
    expect(find.byType(SimpleDialog), findsNothing);

    await _pump(tester, const BottomSheetExample());
    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
    expect(find.text('A sheet that follows your drag'), findsOneWidget);
    await tester.tap(find.text('Close sheet'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);

    await _pump(tester, const SnackBarExample());
    await tester.tap(find.text('Queue a message'));
    await tester.pumpAndSettle();
    expect(find.text('Your changes are saved'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Save undone'), findsOneWidget);
    expect(find.text('Your changes are saved'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  final List<(String, Widget, Type)> pickerModals = <(String, Widget, Type)>[
    ('Modal date picker', const ModalDatePickerExample(), DatePickerDialog),
    (
      'Modal range picker',
      const ModalDateRangePickerExample(),
      DateRangePickerDialog,
    ),
    ('Modal time picker', const ModalTimePickerExample(), TimePickerDialog),
  ];
  for (final (String label, Widget example, Type dialogType) in pickerModals) {
    testWidgets('$label opens in RTL with reduced motion at phone width', (
      WidgetTester tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _pump(
        tester,
        example,
        direction: TextDirection.rtl,
        reducedMotion: true,
        width: 294,
      );
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      final BuildContext context = tester.element(find.byType(dialogType));
      expect(Directionality.of(context), TextDirection.rtl);
      expect(MediaQuery.disableAnimationsOf(context), isTrue);
      expect(tester.takeException(), isNull);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(dialogType), findsNothing);
    });
  }

  testWidgets('inline calendars and clock fit a narrow preview', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final Widget example in <Widget>[
      const CalendarDatePickerExample(),
      const CalendarDateRangePickerExample(),
      const TimePickerExample(),
    ]) {
      await _pump(tester, example, width: 294);
      expect(tester.takeException(), isNull);
    }
    await _pump(tester, const DatePickerFieldExample(), width: 294);
    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarDatePicker), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
  });
}
