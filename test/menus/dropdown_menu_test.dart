import 'dart:ui' show Tristate;

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/foundation/animated_surface.dart';
import 'package:pure_ui/src/menus/menu_item_button.dart';
import 'package:pure_ui/src/menus/menu_panel.dart';

import '../helpers/pump.dart';

const List<DropdownMenuEntry<int>> entries = <DropdownMenuEntry<int>>[
  DropdownMenuEntry<int>(value: 1, label: 'Apple'),
  DropdownMenuEntry<int>(value: 2, label: 'Apricot', enabled: false),
  DropdownMenuEntry<int>(value: 3, label: 'Banana'),
  DropdownMenuEntry<int>(value: 4, label: 'Blueberry'),
];

Finder option(String label) =>
    find.descendant(of: find.byType(MenuPanel), matching: find.text(label));

Future<void> openField(WidgetTester tester) async {
  await tester.tap(find.byType(EditableText));
  await tester.pump();
}

Future<void> submitField(WidgetTester tester) async {
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
}

void main() {
  const Color idleColor = Color(0xFF000000);
  const Color hoverColor = Color(0xFFFFFFFF);

  DropdownStyle hoverStyle({Duration? duration, Curve? curve}) => DropdownStyle(
    buttonStyle: ButtonStyle(
      animationDuration: duration,
      animationCurve: curve,
      decoration: StateProperty<Decoration?>.resolveWith(
        (InteractionState state) =>
            BoxDecoration(color: state.isHovered ? hoverColor : idleColor),
      ),
    ),
  );

  Color paintedFieldColor(WidgetTester tester) =>
      (tester
                  .widget<DecoratedBox>(
                    find.descendant(
                      of: find.byType(AnimatedSurface),
                      matching: find.byType(DecoratedBox),
                    ),
                  )
                  .decoration
              as BoxDecoration)
          .color!;

  testWidgets('editable hover fades smoothly and reverses without a flash', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        style: hoverStyle(),
      ),
    );
    final Finder field = find.byType(EditableText);
    final Rect bounds = tester.getRect(field);
    expect(paintedFieldColor(tester), idleColor);
    final TestGesture mouse = await hover(tester, field);
    expect(paintedFieldColor(tester), idleColor);
    await tester.pump(const Duration(milliseconds: 50));
    final Color entering = paintedFieldColor(tester);
    expect(entering.r, inExclusiveRange(idleColor.r, hoverColor.r));
    expect(tester.getRect(field), bounds);

    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(paintedFieldColor(tester), entering);
    await tester.pump(const Duration(milliseconds: 50));
    expect(
      paintedFieldColor(tester).r,
      inExclusiveRange(idleColor.r, entering.r),
    );
    await tester.pumpAndSettle();
    expect(paintedFieldColor(tester), idleColor);

    await mouse.moveTo(tester.getCenter(field));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      paintedFieldColor(tester).r,
      inExclusiveRange(idleColor.r, hoverColor.r),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(paintedFieldColor(tester), hoverColor);
    expect(tester.getRect(field), bounds);
    await mouse.removePointer();
  });

  testWidgets('editable hover honors a themed duration and curve', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      const DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
      ),
      theme: ThemeData(
        dropdownMenuStyle: hoverStyle(
          duration: const Duration(milliseconds: 400),
          curve: Curves.linear,
        ),
      ),
    );
    final TestGesture mouse = await hover(tester, find.byType(EditableText));
    await tester.pump(const Duration(milliseconds: 100));
    expect(paintedFieldColor(tester), Color.lerp(idleColor, hoverColor, 0.25));
    await tester.pump(const Duration(milliseconds: 300));
    expect(paintedFieldColor(tester), hoverColor);
    await mouse.removePointer();
  });

  testWidgets('an explicit zero duration keeps editable hover immediate', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        style: hoverStyle(duration: Duration.zero),
      ),
    );
    final TestGesture mouse = await hover(tester, find.byType(EditableText));
    expect(paintedFieldColor(tester), hoverColor);
    await mouse.moveTo(Offset.zero);
    await tester.pump();
    expect(paintedFieldColor(tester), idleColor);
    await mouse.removePointer();
  });

  testWidgets('uses editable and select-only modes', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      const DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
      ),
    );
    expect(find.byType(EditableText), findsOneWidget);
    await pumpPure(
      tester,
      const DropdownMenu<int>(dropdownMenuEntries: entries, selectOnly: true),
    );
    expect(find.byType(EditableText), findsNothing);
    await tester.tap(find.byType(MenuItemButton));
    await tester.pump();
    expect(option('Apple'), findsOneWidget);
  });

  testWidgets('focus node mode wins over requestFocusOnTap', (
    WidgetTester tester,
  ) async {
    final FocusNode focus = FocusNode(canRequestFocus: false);
    addTearDown(focus.dispose);
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        focusNode: focus,
      ),
    );
    expect(find.byType(EditableText), findsNothing);
  });

  testWidgets('disabled fields cannot open', (WidgetTester tester) async {
    final MenuController menu = MenuController();
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        enabled: false,
        requestFocusOnTap: true,
        menuController: menu,
      ),
    );
    await tester.tap(find.byType(EditableText), warnIfMissed: false);
    await tester.pump();
    expect(menu.isOpen, isFalse);
  });

  testWidgets('default filter uses case-insensitive contains', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      const DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        enableFilter: true,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'AN');
    await tester.pump();
    expect(option('Banana'), findsOneWidget);
    expect(option('Apple'), findsNothing);
    expect(option('Blueberry'), findsNothing);
  });

  testWidgets('custom filter receives complete entries and query', (
    WidgetTester tester,
  ) async {
    String? received;
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        enableFilter: true,
        filterCallback: (List<DropdownMenuEntry<int>> all, String query) {
          expect(all, entries);
          received = query;
          return <DropdownMenuEntry<int>>[all.last];
        },
      ),
    );
    await tester.enterText(find.byType(EditableText), 'custom');
    await tester.pump();
    expect(received, 'custom');
    expect(option('Blueberry'), findsOneWidget);
    expect(option('Apple'), findsNothing);
  });

  test('filter callback requires filtering', () {
    expect(
      () => DropdownMenu<int>(
        dropdownMenuEntries: entries,
        filterCallback: (List<DropdownMenuEntry<int>> all, String query) => all,
      ),
      throwsAssertionError,
    );
  });

  testWidgets('search highlights a match without filtering', (
    WidgetTester tester,
  ) async {
    int? selection;
    final FocusNode focus = FocusNode();
    addTearDown(focus.dispose);
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        focusNode: focus,
        onSelected: (int? value) => selection = value,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'blu');
    await tester.pump();
    expect(option('Apple'), findsOneWidget);
    expect(option('Blueberry'), findsOneWidget);
    await submitField(tester);
    expect(selection, 4);
    expect(focus.hasFocus, isTrue);
  });

  testWidgets('custom search chooses the supplied index', (
    WidgetTester tester,
  ) async {
    int? selection;
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        searchCallback: (List<DropdownMenuEntry<int>> all, String query) => 2,
        onSelected: (int? value) => selection = value,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'unmatched');
    await tester.pump();
    await submitField(tester);
    expect(selection, 3);
  });

  testWidgets('Enter without an enabled match sends null', (
    WidgetTester tester,
  ) async {
    final List<int?> selections = <int?>[];
    final MenuController menu = MenuController();
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        menuController: menu,
        onSelected: selections.add,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'no match');
    await tester.pump();
    await submitField(tester);
    expect(selections, <int?>[null]);
    expect(menu.isOpen, isFalse);
  });

  testWidgets('arrows skip disabled entries, wrap, and ignore a closed menu', (
    WidgetTester tester,
  ) async {
    final TextEditingController text = TextEditingController();
    final FocusNode focus = FocusNode();
    final MenuController menu = MenuController();
    addTearDown(text.dispose);
    addTearDown(focus.dispose);
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        controller: text,
        focusNode: focus,
        menuController: menu,
        initialSelection: 1,
      ),
    );
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(text.text, 'Apple');
    expect(menu.isOpen, isFalse);
    menu.open();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(text.text, 'Banana');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(text.text, 'Apple');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(text.text, 'Blueberry');
  });

  testWidgets('left and right keep caret movement inside the field', (
    WidgetTester tester,
  ) async {
    final TextEditingController text = TextEditingController();
    addTearDown(text.dispose);
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        controller: text,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Apple');
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(text.selection.extentOffset, 4);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(text.selection.extentOffset, 5);
  });

  for (final DropdownMenuCloseBehavior behavior
      in DropdownMenuCloseBehavior.values) {
    testWidgets('selection honors $behavior before notifying', (
      WidgetTester tester,
    ) async {
      final MenuController menu = MenuController();
      bool? openAtCallback;
      int? selected;
      await pumpPure(
        tester,
        DropdownMenu<int>(
          dropdownMenuEntries: entries,
          requestFocusOnTap: true,
          menuController: menu,
          closeBehavior: behavior,
          onSelected: (int? value) {
            openAtCallback = menu.isOpen;
            selected = value;
          },
        ),
      );
      await openField(tester);
      await tester.tap(option('Banana'));
      await tester.pump();
      expect(selected, 3);
      expect(menu.isOpen, behavior == DropdownMenuCloseBehavior.none);
      expect(openAtCallback, behavior == DropdownMenuCloseBehavior.none);
    });
  }

  testWidgets('an option tap preserves field focus', (
    WidgetTester tester,
  ) async {
    final FocusNode focus = FocusNode();
    addTearDown(focus.dispose);
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        focusNode: focus,
      ),
    );
    await openField(tester);
    expect(focus.hasFocus, isTrue);
    await tester.tap(option('Banana'));
    await tester.pump();
    expect(focus.hasFocus, isTrue);
  });

  testWidgets('reopening clears filtering and highlights the selection', (
    WidgetTester tester,
  ) async {
    final MenuController menu = MenuController();
    final List<int?> selected = <int?>[];
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        initialSelection: 3,
        requestFocusOnTap: true,
        enableFilter: true,
        menuController: menu,
        onSelected: selected.add,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Blue');
    await tester.pump();
    expect(option('Apple'), findsNothing);
    menu.close();
    await tester.pump();
    await openField(tester);
    expect(option('Apple'), findsOneWidget);
    await submitField(tester);
    expect(selected, <int?>[3]);
  });

  testWidgets('changing initialSelection updates controller text', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    late StateSetter rebuild;
    int selection = 1;
    await pumpPure(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          rebuild = setState;
          return DropdownMenu<int>(
            dropdownMenuEntries: entries,
            initialSelection: selection,
            controller: controller,
            requestFocusOnTap: true,
          );
        },
      ),
    );
    expect(controller.text, 'Apple');
    rebuild(() => selection = 4);
    await tester.pump();
    expect(controller.text, 'Blueberry');
  });

  testWidgets('Escape and an outside tap dismiss without selecting', (
    WidgetTester tester,
  ) async {
    final MenuController menu = MenuController();
    final List<int?> selected = <int?>[];
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        menuController: menu,
        onSelected: selected.add,
      ),
    );
    await openField(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(menu.isOpen, isFalse);
    await openField(tester);
    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    expect(menu.isOpen, isFalse);
    expect(selected, isEmpty);
  });

  testWidgets('explicit width and expanded insets determine field width', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      const DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        width: 210,
        showTrailingIcon: false,
      ),
    );
    expect(tester.getSize(find.byType(EditableText)).width, 210);
    await pumpPure(
      tester,
      const SizedBox(
        width: 300,
        child: DropdownMenu<int>(
          dropdownMenuEntries: entries,
          requestFocusOnTap: true,
          expandedInsets: EdgeInsets.symmetric(horizontal: 20),
          showTrailingIcon: false,
        ),
      ),
    );
    expect(tester.getSize(find.byType(EditableText)).width, 260);
  });

  testWidgets('entry styles fall through null states to inline and theme', (
    WidgetTester tester,
  ) async {
    const Color themeColor = Color(0xFF123456);
    const Color selectedColor = Color(0xFF654321);
    await pumpPure(
      tester,
      DropdownMenuTheme(
        data: const DropdownStyle(
          itemStyle: ButtonStyle(
            textStyle: StateProperty<TextStyle?>.all(
              TextStyle(color: themeColor),
            ),
          ),
        ),
        child: DropdownMenu<int>(
          dropdownMenuEntries: <DropdownMenuEntry<int>>[
            DropdownMenuEntry<int>(
              value: 1,
              label: 'Apple',
              style: ButtonStyle(
                textStyle: StateProperty<TextStyle?>.resolveWith(
                  (InteractionState state) => state.isSelected
                      ? const TextStyle(color: selectedColor)
                      : null,
                ),
              ),
            ),
          ],
          requestFocusOnTap: true,
          closeBehavior: DropdownMenuCloseBehavior.none,
          style: const DropdownStyle(
            itemStyle: ButtonStyle(
              textStyle: StateProperty<TextStyle?>.all(null),
            ),
          ),
        ),
      ),
    );
    await openField(tester);
    final BuildContext context = tester.element(option('Apple'));
    expect(DefaultTextStyle.of(context).style.color, themeColor);
    await tester.tap(option('Apple'));
    await tester.pumpAndSettle();
    expect(
      DefaultTextStyle.of(tester.element(option('Apple'))).style.color,
      selectedColor,
    );
  });

  testWidgets('button mode opens and selects by keyboard with virtual focus', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    final FocusNode focus = FocusNode();
    final MenuController menu = MenuController();
    final List<int?> selected = <int?>[];
    addTearDown(focus.dispose);
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        initialSelection: 1,
        selectOnly: true,
        focusNode: focus,
        menuController: menu,
        onSelected: selected.add,
      ),
    );
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(menu.isOpen, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(selected, <int?>[3]);
    expect(menu.isOpen, isFalse);
    expect(focus.hasFocus, isTrue);
  });

  testWidgets('width defaults to the widest label without intrinsics', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      const DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
      ),
    );
    expect(
      tester.getSize(find.byType(EditableText)).width,
      tester.getSize(find.text('Blueberry')).width,
    );
  });

  testWidgets('field semantics report the label, selection and expansion', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await pumpPure(
      tester,
      const DropdownMenu<int>(
        dropdownMenuEntries: entries,
        initialSelection: 1,
        requestFocusOnTap: true,
        semanticLabel: 'Choose fruit',
      ),
    );
    final Finder fieldSemantics = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Semantics && widget.properties.label == 'Choose fruit',
    );
    SemanticsData data = tester
        .getSemantics(fieldSemantics.first)
        .getSemanticsData();
    expect(data.label, 'Choose fruit');
    expect(data.value, 'Apple');
    expect(data.flagsCollection.isTextField, isTrue);
    expect(data.flagsCollection.isExpanded, Tristate.isFalse);
    await openField(tester);
    data = tester.getSemantics(fieldSemantics.first).getSemanticsData();
    expect(data.flagsCollection.isExpanded, Tristate.isTrue);
    semantics.dispose();
  });

  testWidgets(
    'disabled editable field cannot receive pointer or traversal focus',
    (WidgetTester tester) async {
      final FocusNode focus = FocusNode();
      addTearDown(focus.dispose);
      await pumpPure(
        tester,
        DropdownMenu<int>(
          dropdownMenuEntries: entries,
          requestFocusOnTap: true,
          focusNode: focus,
          enabled: false,
        ),
      );
      await tester.tap(find.byType(EditableText), warnIfMissed: false);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(focus.hasFocus, isFalse);
      expect(tester.testTextInput.hasAnyClients, isFalse);
    },
  );

  testWidgets('selected indicators resolve live hover states', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      DropdownMenu<int>(
        dropdownMenuEntries: entries,
        requestFocusOnTap: true,
        style: DropdownStyle(
          selectedIndicator: StateProperty<Widget?>.resolveWith(
            (InteractionState state) =>
                state.isHovered ? const Text('hover option') : null,
          ),
        ),
      ),
    );
    final TestGesture gesture = await hover(tester, find.byType(EditableText));
    await openField(tester);
    await gesture.moveTo(tester.getCenter(option('Banana')));
    await tester.pumpAndSettle();
    expect(find.text('hover option'), findsOneWidget);
    await gesture.removePointer();
  });

  for (final bool selectOnly in <bool>[false, true]) {
    testWidgets(
      'the single trailing icon flips while open (selectOnly: $selectOnly)',
      (WidgetTester tester) async {
        const Key iconKey = Key('arrow');
        await pumpPure(
          tester,
          DropdownMenu<int>(
            trailingIcon: const SizedBox(key: iconKey, width: 10, height: 10),
            dropdownMenuEntries: entries,
            requestFocusOnTap: true,
            selectOnly: selectOnly,
            style: const DropdownStyle(
              buttonStyle: ButtonStyle(
                animationDuration: Duration(milliseconds: 200),
                animationCurve: Curves.linear,
              ),
            ),
          ),
        );
        double turns() => tester
            .widget<RotationTransition>(
              find.ancestor(
                of: find.byKey(iconKey),
                matching: find.byType(RotationTransition),
              ),
            )
            .turns
            .value;
        expect(turns(), 0);
        await tester.tap(find.byKey(iconKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(turns(), closeTo(0.25, 1e-9));
        await tester.pumpAndSettle();
        expect(turns(), 0.5);
        expect(find.byKey(iconKey), findsOneWidget);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(turns(), 0);
      },
    );
  }

  testWidgets('showTrailingIcon false omits the required icon', (
    WidgetTester tester,
  ) async {
    const Key iconKey = Key('arrow');
    await pumpPure(
      tester,
      const DropdownMenu<int>(
        trailingIcon: SizedBox(key: iconKey, width: 10, height: 10),
        showTrailingIcon: false,
        dropdownMenuEntries: entries,
      ),
    );
    expect(find.byKey(iconKey), findsNothing);
  });
}
