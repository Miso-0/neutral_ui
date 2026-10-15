import 'dart:ui' show Tristate;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/menus/menu_item_button.dart';

import '../helpers/pump.dart';

const Key _dropdownKey = Key('dropdown');

List<DropdownMenuItem<String>> _items({List<String>? log}) =>
    <DropdownMenuItem<String>>[
      DropdownMenuItem<String>(
        value: 'one',
        onTap: () => log?.add('item one'),
        child: const Text('One'),
      ),
      const DropdownMenuItem<String>(
        value: 'disabled',
        enabled: false,
        child: Text('Disabled'),
      ),
      DropdownMenuItem<String>(
        value: 'three',
        onTap: () => log?.add('item three'),
        child: const Text('Three'),
      ),
    ];

DropdownButton<String> _dropdown({
  List<DropdownMenuItem<String>>? items,
  String? value = 'one',
  ValueChanged<String?>? onChanged,
  FocusNode? focusNode,
  DropdownStyle? style,
}) => DropdownButton<String>(
  key: _dropdownKey,
  items: items ?? _items(),
  value: value,
  onChanged: onChanged ?? (String? value) {},
  focusNode: focusNode,
  style: style,
);

MenuController _controller(WidgetTester tester) =>
    tester.widget<RawMenuAnchor>(find.byType(RawMenuAnchor)).controller;

Finder get _options => find.byType(MenuItemButton);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byKey(_dropdownKey));
  await tester.pumpAndSettle();
}

AnimatedContainer _optionContainer(WidgetTester tester, int index) =>
    tester.widget<AnimatedContainer>(
      find.descendant(
        of: _options.at(index),
        matching: find.byType(AnimatedContainer),
      ),
    );

void main() {
  test('non-null values must match exactly one item', () {
    expect(
      () => DropdownButton<String>(
        items: _items(),
        value: 'missing',
        onChanged: (String? value) {},
      ),
      throwsAssertionError,
    );
    expect(
      () => DropdownButton<String>(
        items: <DropdownMenuItem<String>>[
          ..._items(),
          const DropdownMenuItem<String>(value: 'one', child: Text('Again')),
        ],
        value: 'one',
        onChanged: (String? value) {},
      ),
      throwsAssertionError,
    );
  });

  testWidgets('a missing callback or missing options disables the trigger', (
    WidgetTester tester,
  ) async {
    int taps = 0;
    for (final List<DropdownMenuItem<String>>? items
        in <List<DropdownMenuItem<String>>?>[
          null,
          <DropdownMenuItem<String>>[],
        ]) {
      await pumpPure(
        tester,
        DropdownButton<String>(
          key: _dropdownKey,
          items: items,
          hint: const Text('Choose'),
          onChanged: (String? value) {},
          onTap: () => taps++,
        ),
      );
      await _open(tester);
      expect(_controller(tester).isOpen, isFalse);
    }
    await pumpPure(
      tester,
      DropdownButton<String>(
        key: _dropdownKey,
        items: _items(),
        onChanged: null,
        onTap: () => taps++,
        hint: const Text('Choose'),
      ),
    );
    await _open(tester);
    expect(_controller(tester).isOpen, isFalse);
    expect(taps, 0);
  });

  testWidgets('sizes the trigger to its widest option', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      DropdownButton<int>(
        key: _dropdownKey,
        items: const <DropdownMenuItem<int>>[
          DropdownMenuItem<int>(
            value: 1,
            child: SizedBox(width: 30, height: 10),
          ),
          DropdownMenuItem<int>(
            value: 2,
            child: SizedBox(width: 160, height: 20),
          ),
        ],
        value: 1,
        onChanged: (int? value) {},
      ),
    );
    expect(tester.getSize(find.byKey(_dropdownKey)), const Size(160, 20));
  });

  testWidgets('shows hints and preserves option sizing without a selection', (
    WidgetTester tester,
  ) async {
    for (final bool enabled in <bool>[true, false]) {
      await pumpPure(
        tester,
        DropdownButton<String>(
          key: _dropdownKey,
          items: _items(),
          hint: const Text('Choose'),
          disabledHint: const Text('Unavailable'),
          onChanged: enabled ? (String? value) {} : null,
        ),
      );
      expect(find.text(enabled ? 'Choose' : 'Unavailable'), findsOneWidget);
      expect(find.text('One'), findsNothing);
    }
  });

  testWidgets(
    'selectedItemBuilder controls trigger content and checks length',
    (WidgetTester tester) async {
      await pumpPure(
        tester,
        DropdownButton<String>(
          key: _dropdownKey,
          items: _items(),
          value: 'three',
          selectedItemBuilder: (BuildContext context) => const <Widget>[
            Text('First selected'),
            Text('Disabled selected'),
            Text('Third selected'),
          ],
          onChanged: (String? value) {},
        ),
      );
      expect(find.text('Third selected'), findsOneWidget);
      await _open(tester);
      expect(find.text('Three'), findsOneWidget);
      await pumpPure(
        tester,
        DropdownButton<String>(
          items: _items(),
          selectedItemBuilder: (BuildContext context) => const <Widget>[],
          onChanged: (String? value) {},
        ),
      );
      expect(tester.takeException(), isAssertionError);
    },
  );

  testWidgets('isExpanded fills the width while retaining the trailing icon', (
    WidgetTester tester,
  ) async {
    const Key iconKey = Key('icon');
    await pumpPure(
      tester,
      SizedBox(
        width: 250,
        child: DropdownButton<String>(
          key: _dropdownKey,
          items: _items(),
          value: 'one',
          isExpanded: true,
          icon: const SizedBox(key: iconKey, width: 10, height: 10),
          onChanged: (String? value) {},
        ),
      ),
    );
    expect(tester.getSize(find.byKey(_dropdownKey)).width, 250);
    expect(
      tester.getTopRight(find.byKey(iconKey)).dx,
      tester.getTopRight(find.byKey(_dropdownKey)).dx,
    );
  });

  testWidgets('tap opens and calls onTap before the menu opens', (
    WidgetTester tester,
  ) async {
    late MenuController controller;
    final List<bool> openDuringTap = <bool>[];
    await pumpPure(
      tester,
      DropdownButton<String>(
        key: _dropdownKey,
        items: _items(),
        onChanged: (String? value) {},
        onTap: () => openDuringTap.add(controller.isOpen),
      ),
    );
    controller = _controller(tester);
    await _open(tester);
    expect(controller.isOpen, isTrue);
    expect(openDuringTap, <bool>[false]);
    expect(_options, findsNWidgets(3));
  });

  testWidgets('Enter and Space open the focused trigger', (
    WidgetTester tester,
  ) async {
    for (final LogicalKeyboardKey key in <LogicalKeyboardKey>[
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.space,
    ]) {
      final FocusNode node = FocusNode();
      await pumpPure(tester, _dropdown(focusNode: node));
      node.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(key);
      await tester.pumpAndSettle();
      expect(_controller(tester).isOpen, isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
      node.dispose();
    }
  });

  testWidgets('focuses the selected option and scrolls it into view', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      DropdownButton<int>(
        key: _dropdownKey,
        items: List<DropdownMenuItem<int>>.generate(
          40,
          (int index) => DropdownMenuItem<int>(
            value: index,
            child: SizedBox(width: 80, height: 30, child: Text('$index')),
          ),
        ),
        value: 35,
        menuMaxHeight: 90,
        onChanged: (int? value) {},
      ),
    );
    await _open(tester);
    expect(
      tester.widget<MenuItemButton>(_options.at(35)).focusNode!.hasFocus,
      isTrue,
    );
    final ScrollableState scrollable = tester.state<ScrollableState>(
      find.byType(Scrollable),
    );
    expect(scrollable.position.pixels, greaterThan(0));
    final Rect viewport = tester.getRect(find.byType(SingleChildScrollView));
    final Rect selected = tester.getRect(_options.at(35));
    expect(selected.top, greaterThanOrEqualTo(viewport.top));
    expect(selected.bottom, lessThanOrEqualTo(viewport.bottom));
  });

  testWidgets('without a selection the first enabled option receives focus', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      _dropdown(
        items: <DropdownMenuItem<String>>[_items()[1], _items()[2]],
        value: null,
      ),
    );
    await _open(tester);
    expect(
      tester.widget<MenuItemButton>(_options.at(1)).focusNode!.hasFocus,
      isTrue,
    );
  });

  testWidgets('arrows and Tab wrap and skip disabled options', (
    WidgetTester tester,
  ) async {
    await pumpPure(tester, _dropdown());
    await _open(tester);
    expect(
      tester.widget<MenuItemButton>(_options.at(0)).focusNode!.hasFocus,
      isTrue,
    );
    final List<LogicalKeyboardKey> keys = <LogicalKeyboardKey>[
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.tab,
    ];
    for (int index = 0; index < keys.length; index++) {
      await tester.sendKeyEvent(keys[index]);
      await tester.pumpAndSettle();
      final int expected = <int>[2, 0, 2, 0][index];
      expect(
        tester
            .widget<MenuItemButton>(_options.at(expected))
            .focusNode!
            .hasFocus,
        isTrue,
        reason: 'Key ${keys[index]} should focus option $expected',
      );
      expect(
        tester.widget<MenuItemButton>(_options.at(1)).focusNode!.hasFocus,
        isFalse,
      );
    }
  });

  testWidgets('selection calls item onTap, closes, then reports the value', (
    WidgetTester tester,
  ) async {
    final List<String> log = <String>[];
    late MenuController controller;
    await pumpPure(
      tester,
      _dropdown(
        items: _items(log: log),
        onChanged: (String? value) => log.add('$value:${controller.isOpen}'),
      ),
    );
    controller = _controller(tester);
    await _open(tester);
    await tester.tap(_options.at(2));
    await tester.pumpAndSettle();
    expect(log, <String>['item three', 'three:false']);
    expect(_options, findsNothing);
    await _open(tester);
    await tester.tap(_options.at(0));
    await tester.pumpAndSettle();
    expect(log.last, 'one:false');
  });

  testWidgets('disabled options ignore selection', (WidgetTester tester) async {
    final List<String?> values = <String?>[];
    await pumpPure(tester, _dropdown(onChanged: values.add));
    await _open(tester);
    await tester.tap(_options.at(1));
    await tester.pumpAndSettle();
    expect(values, isEmpty);
    expect(_controller(tester).isOpen, isTrue);
  });

  testWidgets('Escape and outside taps dismiss silently and restore focus', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    final List<String?> values = <String?>[];
    await pumpPure(tester, _dropdown(focusNode: node, onChanged: values.add));
    await _open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(_controller(tester).isOpen, isFalse);
    expect(node.hasFocus, isTrue);
    await _open(tester);
    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(_controller(tester).isOpen, isFalse);
    expect(values, isEmpty);
  });

  testWidgets('ancestor scrolling dismisses silently', (
    WidgetTester tester,
  ) async {
    final ScrollController scroll = ScrollController();
    addTearDown(scroll.dispose);
    final List<String?> values = <String?>[];
    await pumpPure(
      tester,
      SizedBox(
        height: 250,
        child: SingleChildScrollView(
          controller: scroll,
          child: Column(
            children: <Widget>[
              _dropdown(onChanged: values.add),
              const SizedBox(height: 1000),
            ],
          ),
        ),
      ),
    );
    await _open(tester);
    final Future<void> scrolling = scroll.animateTo(
      50,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
    await tester.pumpAndSettle();
    await scrolling;
    expect(_controller(tester).isOpen, isFalse);
    expect(values, isEmpty);
  });

  testWidgets('option tokens resolve per state through every layer', (
    WidgetTester tester,
  ) async {
    const Decoration global = BoxDecoration(color: Color(0xFF112233));
    const Decoration component = BoxDecoration(color: Color(0xFF223344));
    const Decoration inline = BoxDecoration(color: Color(0xFF334455));
    const Decoration entry = BoxDecoration(color: Color(0xFF445566));
    for (int layer = 0; layer < 4; layer++) {
      await pumpPure(
        tester,
        DropdownButtonTheme(
          data: layer == 0
              ? const DropdownStyle()
              : const DropdownStyle(
                  itemStyle: ButtonStyle(
                    decoration: StateProperty<Decoration?>.all(component),
                  ),
                ),
          child: _dropdown(
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                value: 'one',
                style: layer >= 3
                    ? ButtonStyle(
                        decoration: StateProperty<Decoration?>.resolveWith(
                          (InteractionState state) =>
                              state.isHovered ? entry : null,
                        ),
                      )
                    : null,
                child: const Text('One'),
              ),
            ],
            style: layer >= 2
                ? const DropdownStyle(
                    itemStyle: ButtonStyle(
                      decoration: StateProperty<Decoration?>.all(inline),
                    ),
                  )
                : null,
          ),
        ),
        theme: const ThemeData(
          dropdownButtonStyle: DropdownStyle(
            itemStyle: ButtonStyle(
              decoration: StateProperty<Decoration?>.all(global),
            ),
          ),
        ),
      );
      await _open(tester);
      // Component themes replace the global slot, including an empty theme.
      expect(
        _optionContainer(tester, 0).decoration,
        <Decoration?>[null, component, inline, inline][layer],
      );
      if (layer == 3) {
        final TestGesture mouse = await hover(tester, _options.at(0));
        expect(_optionContainer(tester, 0).decoration, entry);
        await mouse.removePointer();
        await tester.pumpAndSettle();
      }
      _controller(tester).close();
      await tester.pumpAndSettle();
    }
    await pumpPure(
      tester,
      _dropdown(),
      theme: const ThemeData(
        dropdownButtonStyle: DropdownStyle(
          itemStyle: ButtonStyle(
            decoration: StateProperty<Decoration?>.all(global),
          ),
        ),
      ),
    );
    await _open(tester);
    expect(_optionContainer(tester, 0).decoration, global);
  });

  testWidgets('trigger and indicator tokens receive open and option states', (
    WidgetTester tester,
  ) async {
    InteractionState? trigger;
    await pumpPure(
      tester,
      _dropdown(
        style: DropdownStyle(
          buttonStyle: ButtonStyle(
            decoration: StateProperty<Decoration?>.resolveWith((
              InteractionState state,
            ) {
              trigger = state;
              return null;
            }),
          ),
          icon: StateProperty<Widget?>.resolveWith(
            (InteractionState state) =>
                Text(state.isSelected ? 'Open' : 'Closed'),
          ),
          selectedIndicator: StateProperty<Widget?>.resolveWith(
            (InteractionState state) =>
                state.isSelected ? const Text('Chosen') : null,
          ),
        ),
      ),
    );
    expect(trigger!.isSelected, isFalse);
    expect(find.text('Closed'), findsOneWidget);
    await _open(tester);
    expect(trigger!.isSelected, isTrue);
    expect(find.text('Open'), findsOneWidget);
    expect(find.text('Chosen'), findsOneWidget);
  });

  testWidgets('semantics expose expanded, selected, and disabled states', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await pumpPure(
      tester,
      DropdownButton<String>(
        key: _dropdownKey,
        items: _items(),
        value: 'one',
        semanticLabel: 'Pick a number',
        onChanged: (String? value) {},
      ),
    );
    expect(
      tester
          .getSemantics(
            find.byWidgetPredicate(
              (Widget widget) => widget is ButtonStyleButton,
            ),
          )
          .getSemanticsData()
          .flagsCollection
          .isExpanded,
      Tristate.isFalse,
    );
    await _open(tester);
    expect(
      tester
          .getSemantics(_options.at(0))
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    expect(
      tester
          .getSemantics(_options.at(1))
          .getSemanticsData()
          .flagsCollection
          .isEnabled,
      Tristate.isFalse,
    );
    semantics.dispose();
  });

  testWidgets('menu panel overrides retain component tokens', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      DropdownButtonTheme(
        data: const DropdownStyle(
          menuStyle: MenuStyle(padding: EdgeInsets.all(8)),
        ),
        child: _dropdown(
          style: const DropdownStyle(
            menuStyle: MenuStyle(maximumSize: Size(300, 200)),
          ),
        ),
      ),
    );
    await _open(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
