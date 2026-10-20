import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';
import 'package:neutral_ui/src/menus/menu_item_button.dart';
import 'package:neutral_ui/src/menus/menu_panel.dart';

import '../helpers/pump.dart';

const Key _anchorKey = Key('anchor');
const BoxDecoration _triggerDecoration = BoxDecoration(
  color: Color(0xFF123456),
);
const BoxDecoration _panelDecoration = BoxDecoration(color: Color(0xFF234567));
const BoxDecoration _rowDecoration = BoxDecoration(color: Color(0xFF345678));
const BoxDecoration _themeDecoration = BoxDecoration(color: Color(0xFF999999));
const ButtonStyle _themedButton = ButtonStyle(
  decoration: StateProperty<Decoration?>.all(_themeDecoration),
);
const MenuStyle _themedPanel = MenuStyle(decoration: _themeDecoration);
const DropdownStyle _dropdownTheme = DropdownStyle(
  buttonStyle: _themedButton,
  menuStyle: _themedPanel,
  itemStyle: _themedButton,
);
const PopupMenuStyle _popupTheme = PopupMenuStyle(
  buttonStyle: _themedButton,
  menuStyle: _themedPanel,
  itemStyle: _themedButton,
);
const ThemeData _globalTheme = ThemeData(
  dropdownButtonStyle: _dropdownTheme,
  dropdownMenuStyle: _dropdownTheme,
  popupMenuStyle: _popupTheme,
);

AnimatedSurface _surface(WidgetTester tester, Finder parent) {
  final Iterable<Element> elements = find
      .descendant(of: parent, matching: find.byType(AnimatedSurface))
      .evaluate();
  // RawMenuAnchor owns its overlay subtree too. Keep the anchor's surface
  // separate from its option surfaces once the panel is open.
  final Element surface = elements.length == 1
      ? elements.single
      : elements.firstWhere((Element element) {
          bool inPanel = false;
          element.visitAncestorElements((Element ancestor) {
            if (ancestor.widget is MenuPanel) {
              inPanel = true;
              return false;
            }
            return true;
          });
          return !inPanel;
        });
  return surface.widget as AnimatedSurface;
}

Finder get _anchor => find.byKey(_anchorKey);
Finder get _rows => find.descendant(
  of: find.byType(MenuPanel),
  matching: find.byType(MenuItemButton),
);

void _expectPanel(WidgetTester tester) {
  final Iterable<Container> containers = tester.widgetList<Container>(
    find.descendant(
      of: find.byType(MenuPanel),
      matching: find.byType(Container),
    ),
  );
  expect(
    containers.any((Container c) => c.decoration == _panelDecoration),
    isTrue,
  );
}

Future<void> _exerciseSurface(WidgetTester tester, Finder finder) async {
  expect(_surface(tester, finder).decoration, _triggerDecoration);
  final TestGesture mouse = await hover(tester, finder);
  await tester.pumpAndSettle();
  expect(_surface(tester, finder).decoration, _triggerDecoration);
  final TestGesture touch = await tester.startGesture(tester.getCenter(finder));
  await tester.pump(kPressTimeout);
  expect(_surface(tester, finder).decoration, _triggerDecoration);
  await touch.cancel();
  await mouse.removePointer();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'classic dropdown overrides trigger, panel and row theme layers',
    (WidgetTester tester) async {
      useTraditionalFocus();
      final FocusNode focus = FocusNode();
      addTearDown(focus.dispose);
      for (final bool componentTheme in <bool>[false, true]) {
        final Widget dropdown = DropdownButton<int>(
          key: _anchorKey,
          focusNode: focus,
          value: 1,
          onChanged: (int? value) {},
          decoration: _triggerDecoration,
          menuDecoration: _panelDecoration,
          style: const DropdownStyle(itemStyle: _themedButton),
          items: const <DropdownMenuItem<int>>[
            DropdownMenuItem<int>(
              value: 1,
              decoration: _rowDecoration,
              child: Text('Selected row'),
            ),
            DropdownMenuItem<int>(
              value: 2,
              decoration: _rowDecoration,
              enabled: false,
              child: Text('Disabled row'),
            ),
          ],
        );
        await pumpNeutral(
          tester,
          componentTheme
              ? DropdownButtonTheme(data: _dropdownTheme, child: dropdown)
              : dropdown,
          theme: _globalTheme,
        );
        await _exerciseSurface(tester, _anchor);
        focus.requestFocus();
        await tester.pumpAndSettle();
        expect(_surface(tester, _anchor).decoration, _triggerDecoration);
        await tester.tap(_anchor);
        await tester.pumpAndSettle();
        _expectPanel(tester);
        expect(_surface(tester, _anchor).decoration, _triggerDecoration);
        for (int i = 0; i < 2; i++) {
          expect(_surface(tester, _rows.at(i)).decoration, _rowDecoration);
        }
        final TestGesture mouse = await hover(tester, _rows.first);
        await tester.pumpAndSettle();
        expect(_surface(tester, _rows.first).decoration, _rowDecoration);
        final TestGesture touch = await tester.startGesture(
          tester.getCenter(_rows.first),
        );
        await tester.pump(kPressTimeout);
        expect(_surface(tester, _rows.first).decoration, _rowDecoration);
        await touch.cancel();
        await mouse.removePointer();
        expect(tester.takeException(), isNull);
      }
    },
  );

  for (final (String, bool, bool) variant in <(String, bool, bool)>[
    ('editable', false, false),
    ('select only', true, false),
    ('multiple', false, true),
    ('multiple select only', true, true),
  ]) {
    testWidgets('${variant.$1} dropdown decorates field, panel and entries', (
      WidgetTester tester,
    ) async {
      const List<DropdownMenuEntry<int>> entries = <DropdownMenuEntry<int>>[
        DropdownMenuEntry<int>(
          value: 1,
          label: 'Selected row',
          decoration: _rowDecoration,
        ),
        DropdownMenuEntry<int>(
          value: 2,
          label: 'Disabled row',
          enabled: false,
          decoration: _rowDecoration,
        ),
      ];
      final Widget dropdown = variant.$3
          ? DropdownMenu<int>.multiple(
              key: _anchorKey,
              dropdownMenuEntries: entries,
              selected: const <int>{1},
              onSelectionChanged: (Set<int> values) {},
              selectOnly: variant.$2,
              requestFocusOnTap: true,
              decoration: _triggerDecoration,
              menuDecoration: _panelDecoration,
              style: const DropdownStyle(itemStyle: _themedButton),
            )
          : DropdownMenu<int>(
              key: _anchorKey,
              dropdownMenuEntries: entries,
              initialSelection: 1,
              selectOnly: variant.$2,
              requestFocusOnTap: true,
              decoration: _triggerDecoration,
              menuDecoration: _panelDecoration,
              style: const DropdownStyle(itemStyle: _themedButton),
            );
      await pumpNeutral(
        tester,
        DropdownMenuTheme(data: _dropdownTheme, child: dropdown),
        theme: _globalTheme,
      );
      await _exerciseSurface(tester, _anchor);
      await tester.tap(_anchor);
      await tester.pumpAndSettle();
      _expectPanel(tester);
      expect(_surface(tester, _anchor).decoration, _triggerDecoration);
      expect(_rows, findsNWidgets(2));
      for (int i = 0; i < 2; i++) {
        expect(_surface(tester, _rows.at(i)).decoration, _rowDecoration);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('popup decorates trigger, panel, regular and checked rows', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      PopupMenuTheme(
        data: _popupTheme,
        child: PopupMenuButton<int>(
          key: _anchorKey,
          decoration: _triggerDecoration,
          menuDecoration: _panelDecoration,
          style: const PopupMenuStyle(itemStyle: _themedButton),
          itemBuilder: (BuildContext context) => const <PopupMenuEntry<int>>[
            PopupMenuItem<int>(
              value: 1,
              decoration: _rowDecoration,
              child: Text('Regular row'),
            ),
            CheckedPopupMenuItem<int>(
              value: 2,
              checked: true,
              decoration: _rowDecoration,
              child: Text('Checked row'),
            ),
            PopupMenuItem<int>(
              value: 3,
              enabled: false,
              decoration: _rowDecoration,
              child: Text('Disabled row'),
            ),
          ],
          child: const Text('Actions'),
        ),
      ),
      theme: _globalTheme,
    );
    await _exerciseSurface(tester, _anchor);
    await tester.tap(_anchor);
    await tester.pumpAndSettle();
    _expectPanel(tester);
    for (int i = 0; i < 3; i++) {
      expect(_surface(tester, _rows.at(i)).decoration, _rowDecoration);
    }
    expect(tester.takeException(), isNull);
  });

  for (final String kind in <String>['classic', 'editable', 'popup']) {
    testWidgets('$kind disabled trigger retains its widget decoration', (
      WidgetTester tester,
    ) async {
      final Widget dropdown = switch (kind) {
        'classic' => DropdownButton<int>(
          key: _anchorKey,
          decoration: _triggerDecoration,
          items: const <DropdownMenuItem<int>>[
            DropdownMenuItem<int>(value: 1, child: Text('One')),
          ],
          onChanged: null,
        ),
        'editable' => const DropdownMenu<int>(
          key: _anchorKey,
          decoration: _triggerDecoration,
          enabled: false,
          dropdownMenuEntries: <DropdownMenuEntry<int>>[
            DropdownMenuEntry<int>(value: 1, label: 'One'),
          ],
        ),
        _ => PopupMenuButton<int>(
          key: _anchorKey,
          decoration: _triggerDecoration,
          enabled: false,
          itemBuilder: (BuildContext context) => const <PopupMenuEntry<int>>[],
          child: const Text('Actions'),
        ),
      };
      await pumpNeutral(tester, dropdown, theme: _globalTheme);
      expect(_surface(tester, _anchor).decoration, _triggerDecoration);
      expect(tester.takeException(), isNull);
    });
  }

  for (final String kind in <String>[
    'classic',
    'single',
    'multiple',
    'popup',
  ]) {
    for (final bool panel in <bool>[false, true]) {
      testWidgets(
        '$kind rejects conflicting inline ${panel ? 'panel' : 'trigger'}',
        (WidgetTester tester) async {
          final DropdownStyle dropdownStyle = DropdownStyle(
            buttonStyle: panel ? null : _themedButton,
            menuStyle: panel ? _themedPanel : null,
          );
          final BoxDecoration? decoration = panel ? null : _triggerDecoration;
          final BoxDecoration? menuDecoration = panel ? _panelDecoration : null;
          final Widget dropdown = switch (kind) {
            'classic' => DropdownButton<int>(
              decoration: decoration,
              menuDecoration: menuDecoration,
              style: dropdownStyle,
              items: const <DropdownMenuItem<int>>[],
              onChanged: null,
            ),
            'single' => DropdownMenu<int>(
              decoration: decoration,
              menuDecoration: menuDecoration,
              style: dropdownStyle,
              dropdownMenuEntries: const <DropdownMenuEntry<int>>[],
            ),
            'multiple' => DropdownMenu<int>.multiple(
              decoration: decoration,
              menuDecoration: menuDecoration,
              style: dropdownStyle,
              selected: const <int>{},
              onSelectionChanged: (Set<int> values) {},
              dropdownMenuEntries: const <DropdownMenuEntry<int>>[],
            ),
            _ => PopupMenuButton<int>(
              decoration: decoration,
              menuDecoration: menuDecoration,
              style: PopupMenuStyle(
                buttonStyle: panel ? null : _themedButton,
                menuStyle: panel ? _themedPanel : null,
              ),
              itemBuilder: (BuildContext context) =>
                  const <PopupMenuEntry<int>>[],
            ),
          };
          await pumpNeutral(tester, dropdown);
          final Object? error = tester.takeException();
          expect(error, isA<FlutterError>());
          expect(
            error.toString(),
            contains(switch (kind) {
              'classic' => 'DropdownButton',
              'popup' => 'PopupMenuButton',
              _ => 'DropdownMenu',
            }),
          );
          expect(
            error.toString(),
            contains(panel ? '`menuDecoration`' : '`decoration`'),
          );
          expect(
            error.toString(),
            contains(
              panel
                  ? 'style.menuStyle.decoration'
                  : 'style.buttonStyle.decoration',
            ),
          );
        },
      );
    }
  }

  for (final String kind in <String>['classic', 'entry', 'popup', 'checked']) {
    testWidgets('$kind row rejects its own inline decoration', (
      WidgetTester tester,
    ) async {
      final Widget dropdown = switch (kind) {
        'classic' => DropdownButton<int>(
          items: const <DropdownMenuItem<int>>[
            DropdownMenuItem<int>(
              value: 1,
              decoration: _rowDecoration,
              style: _themedButton,
              child: Text('One'),
            ),
          ],
          onChanged: (int? value) {},
        ),
        'entry' => const DropdownMenu<int>(
          dropdownMenuEntries: <DropdownMenuEntry<int>>[
            DropdownMenuEntry<int>(
              value: 1,
              label: 'One',
              decoration: _rowDecoration,
              style: _themedButton,
            ),
          ],
        ),
        _ => PopupMenuButton<int>(
          key: _anchorKey,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            if (kind == 'checked')
              const CheckedPopupMenuItem<int>(
                value: 1,
                decoration: _rowDecoration,
                style: _themedButton,
                child: Text('One'),
              )
            else
              const PopupMenuItem<int>(
                value: 1,
                decoration: _rowDecoration,
                style: _themedButton,
                child: Text('One'),
              ),
          ],
          child: const Text('Actions'),
        ),
      };
      await pumpNeutral(tester, dropdown);
      if (kind == 'popup' || kind == 'checked') {
        await tester.tap(_anchor);
        await tester.pump();
      }
      final Object? error = tester.takeException();
      expect(error, isA<FlutterError>());
      expect(
        error.toString(),
        contains(switch (kind) {
          'classic' => 'DropdownMenuItem',
          'entry' => 'DropdownMenuEntry',
          'checked' => 'CheckedPopupMenuItem',
          _ => 'PopupMenuItem',
        }),
      );
      expect(error.toString(), contains('`decoration`'));
      expect(error.toString(), contains('style.decoration'));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
}
