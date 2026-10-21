import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/menus/menu_item_button.dart';
import 'package:neutral_ui/src/menus/menu_panel.dart';

import '../helpers/pump.dart';

const Color _idle = Color(0x00000000);
const Color _hovered = Color(0xFF00AA00);
const Color _focused = Color(0xFFAA0000);
const Key _dropdownKey = Key('dropdown');
const List<String> _labels = <String>[
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
];

/// Rows paint focus, hover and idle distinctly and change without fading.
const ButtonStyle _rowStyle = ButtonStyle(
  animationDuration: Duration.zero,
  decoration: StateProperty<Decoration?>.resolveWith(_rowDecoration),
);

Decoration _rowDecoration(InteractionState state) => BoxDecoration(
  color: state.isFocused
      ? _focused
      : state.isHovered
      ? _hovered
      : _idle,
);

Finder _row(String label) => find.ancestor(
  of: find.descendant(of: find.byType(MenuPanel), matching: find.text(label)),
  matching: find.byType(MenuItemButton),
);

Map<String, Color?> _litRows(WidgetTester tester) => <String, Color?>{
  for (final String label in _labels)
    if (_row(label).evaluate().isNotEmpty &&
        paintedColor(tester, _row(label)) != _idle)
      label: paintedColor(tester, _row(label)),
};

Widget _dropdown({
  ValueChanged<String?>? onChanged,
  double? menuMaxHeight,
  int count = 6,
  ButtonStyle? buttonStyle,
  FocusNode? focusNode,
}) => DropdownButton<String>(
  key: _dropdownKey,
  focusNode: focusNode,
  value: 'one',
  menuMaxHeight: menuMaxHeight,
  style: DropdownStyle(itemStyle: _rowStyle, buttonStyle: buttonStyle),
  items: <DropdownMenuItem<String>>[
    for (int index = 0; index < count; index++)
      DropdownMenuItem<String>(
        value: index < _labels.length ? _labels[index] : 'item $index',
        child: SizedBox(
          height: 30,
          child: Text(index < _labels.length ? _labels[index] : 'item $index'),
        ),
      ),
  ],
  onChanged: onChanged ?? (String? value) {},
);

Future<TestGesture> _mouseAt(WidgetTester tester, Offset location) async {
  final TestGesture mouse = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await mouse.addPointer(location: location);
  await tester.pump();
  return mouse;
}

void main() {
  testWidgets('hovering a row makes it the row arrow keys continue from', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    await pumpNeutral(tester, _dropdown());
    await tester.tap(find.byKey(_dropdownKey));
    await tester.pumpAndSettle();
    expect(_litRows(tester), <String, Color?>{'one': _focused});

    final TestGesture mouse = await _mouseAt(tester, Offset.zero);
    await mouse.moveTo(tester.getCenter(_row('four')));
    await tester.pumpAndSettle();
    expect(_litRows(tester), <String, Color?>{'four': _focused});

    // Arrows continue from the hovered row, and the resting pointer's hover is
    // hidden so only one row looks active.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(_litRows(tester), <String, Color?>{'five': _focused});

    // Moving the pointer again makes the row under it active.
    await mouse.moveBy(const Offset(1, 0));
    await tester.pumpAndSettle();
    expect(_litRows(tester), <String, Color?>{'four': _focused});
    await mouse.removePointer();
  });

  testWidgets('a panel opening under a resting pointer keeps its selection', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    await pumpNeutral(tester, _dropdown(focusNode: node));
    final Offset trigger = tester.getCenter(find.byKey(_dropdownKey));
    // Rest the pointer where the panel's later rows appear.
    final TestGesture mouse = await _mouseAt(
      tester,
      trigger + const Offset(0, 100),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(MenuPanel), findsOneWidget);
    expect(_litRows(tester), <String, Color?>{'one': _focused});
    await mouse.removePointer();
  });

  testWidgets('DropdownMenu Enter selects the hovered row', (
    WidgetTester tester,
  ) async {
    int? selected;
    await pumpNeutral(
      tester,
      DropdownMenu<int>(
        requestFocusOnTap: true,
        onSelected: (int? value) => selected = value,
        dropdownMenuEntries: <DropdownMenuEntry<int>>[
          for (int index = 0; index < _labels.length; index++)
            DropdownMenuEntry<int>(value: index, label: _labels[index]),
        ],
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();
    final TestGesture mouse = await _mouseAt(tester, Offset.zero);
    await mouse.moveTo(tester.getCenter(_row('three')));
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(selected, 2);
    await mouse.removePointer();
  });

  testWidgets('arrow keys scroll only as far as needed', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(tester, _dropdown(count: 20, menuMaxHeight: 150));
    await tester.tap(find.byKey(_dropdownKey));
    await tester.pumpAndSettle();
    final ScrollPosition position = tester
        .state<ScrollableState>(
          find.descendant(
            of: find.byType(MenuPanel),
            matching: find.byType(Scrollable),
          ),
        )
        .position;
    expect(position.pixels, 0);
    // The next row is already visible, so nothing scrolls.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(position.pixels, 0);
    // Moving past the bottom edge reveals the row at the bottom, not the top.
    for (int index = 0; index < 8; index++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
    }
    final Rect viewport = tester.getRect(
      find.descendant(
        of: find.byType(MenuPanel),
        matching: find.byType(Scrollable),
      ),
    );
    final Rect focusedRow = tester.getRect(_row('item 9'));
    expect(focusedRow.bottom, closeTo(viewport.bottom, 0.5));
  });

  testWidgets('DropdownMenu rows keep their width while hovered', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      DropdownMenu<int>(
        requestFocusOnTap: true,
        style: const DropdownStyle(itemStyle: _rowStyle),
        dropdownMenuEntries: <DropdownMenuEntry<int>>[
          for (int index = 0; index < _labels.length; index++)
            DropdownMenuEntry<int>(value: index, label: _labels[index]),
        ],
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();
    final double width = tester.getSize(_row('two')).width;
    final TestGesture mouse = await _mouseAt(tester, Offset.zero);
    for (final String label in <String>['two', 'three', 'four', 'one']) {
      await mouse.moveTo(tester.getCenter(_row(label)));
      for (int frame = 0; frame < 4; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
        for (final String row in _labels) {
          expect(tester.getSize(_row(row)).width, width, reason: row);
        }
      }
    }
    await mouse.removePointer();
  });

  testWidgets('the chosen row keeps its look while the panel exits', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(tester, _dropdown());
    await tester.tap(find.byKey(_dropdownKey));
    await tester.pumpAndSettle();
    final TestGesture mouse = await _mouseAt(tester, Offset.zero);
    await mouse.moveTo(tester.getCenter(_row('three')));
    await tester.pumpAndSettle();
    expect(paintedColor(tester, _row('three')), _hovered);
    await mouse.down(tester.getCenter(_row('three')));
    await mouse.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(_row('three'), findsOneWidget);
    expect(paintedColor(tester, _row('three')), _hovered);
    await tester.pumpAndSettle();
    await mouse.removePointer();
  });

  testWidgets('an open trigger hands its focus ring to the active row', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    await pumpNeutral(
      tester,
      _dropdown(buttonStyle: _rowStyle, focusNode: node),
    );
    final Finder trigger = find
        .descendant(
          of: find.byKey(_dropdownKey),
          matching: find.byWidgetPredicate(
            (Widget widget) => widget is ButtonStyleButton,
          ),
        )
        .first;
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(paintedColor(tester, trigger), _focused);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(_litRows(tester), <String, Color?>{'one': _focused});
    expect(paintedColor(tester, trigger), isNot(_focused));
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(paintedColor(tester, trigger), _focused);
  });

  testWidgets('Autocomplete Enter selects the hovered option', (
    WidgetTester tester,
  ) async {
    String? selected;
    await pumpNeutral(
      tester,
      SizedBox(
        width: 240,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue value) => _labels,
          onSelected: (String value) => selected = value,
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'x');
    await tester.pumpAndSettle();
    Finder option(String label) => find.ancestor(
      of: find.text(label),
      matching: find.byType(MenuItemButton),
    );
    final TestGesture mouse = await _mouseAt(tester, Offset.zero);
    await mouse.moveTo(tester.getCenter(option('four')));
    await tester.pumpAndSettle();
    // A second movement before and after the highlight arrives stays put.
    await mouse.moveBy(const Offset(2, 0));
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(selected, 'four');
    await mouse.removePointer();
  });
}
