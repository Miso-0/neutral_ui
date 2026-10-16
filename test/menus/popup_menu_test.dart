import 'dart:ui' show CheckedState;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/foundation/animated_surface.dart';
import 'package:pure_ui/src/menus/menu_item_button.dart';

import '../helpers/pump.dart';

const List<PopupMenuEntry<int>> _items = <PopupMenuEntry<int>>[
  PopupMenuItem<int>(value: 1, child: Text('First')),
  PopupMenuItem<int>(value: 2, enabled: false, child: Text('Disabled')),
  PopupMenuDivider(),
  CheckedPopupMenuItem<int>(value: 3, checked: true, child: Text('Last')),
];

void main() {
  Future<void> open(WidgetTester tester) async {
    await tester.tap(find.text('Actions'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'builds on each open, callbacks close before item and selection',
    (WidgetTester tester) async {
      final GlobalKey<PopupMenuButtonState<int>> key =
          GlobalKey<PopupMenuButtonState<int>>();
      final List<String> calls = <String>[];
      int builds = 0;
      await pumpPure(
        tester,
        PopupMenuButton<int>(
          key: key,
          itemBuilder: (BuildContext context) {
            builds++;
            return <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 4,
                onTap: () {
                  expect(
                    MenuController.maybeOf(tester.element(find.text('Actions')))
                        ?.isOpen,
                    isFalse,
                  );
                  calls.add('item');
                },
                child: const Text('Choose'),
              ),
            ];
          },
          onOpened: () => calls.add('open'),
          onSelected: (int value) => calls.add('selected $value'),
          onCanceled: () => calls.add('cancel'),
          child: const Text('Actions'),
        ),
      );
      await open(tester);
      expect(builds, 1);
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      expect(calls, <String>['open', 'item', 'selected 4']);
      key.currentState!.showButtonMenu();
      await tester.pumpAndSettle();
      expect(builds, 2);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(calls.last, 'cancel');
    },
  );
  testWidgets('empty and disabled menus never open or call onOpened', (
    WidgetTester tester,
  ) async {
    int opened = 0;
    await pumpPure(
      tester,
      PopupMenuButton<int>(
        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[],
        onOpened: () => opened++,
        child: const Text('Actions'),
      ),
    );
    await open(tester);
    expect(opened, 0);
    final GlobalKey<PopupMenuButtonState<int>> key =
        GlobalKey<PopupMenuButtonState<int>>();
    await pumpPure(
      tester,
      PopupMenuButton<int>(
        key: key,
        enabled: false,
        itemBuilder: (BuildContext context) => _items,
        onOpened: () => opened++,
        child: const Text('Actions'),
      ),
    );
    key.currentState!.showButtonMenu();
    await tester.pump();
    expect(find.text('First'), findsNothing);
    expect(opened, 0);
  });
  testWidgets(
    'null values run only item callback and disabled items do nothing',
    (WidgetTester tester) async {
      final List<String> calls = <String>[];
      await pumpPure(
        tester,
        PopupMenuButton<int>(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            PopupMenuItem<int>(
              onTap: () => calls.add('item'),
              child: const Text('Null'),
            ),
            const PopupMenuItem<int>(
              value: 1,
              enabled: false,
              child: Text('Disabled'),
            ),
          ],
          onSelected: (int value) => calls.add('selected'),
          onCanceled: () => calls.add('cancel'),
          child: const Text('Actions'),
        ),
      );
      await open(tester);
      await tester.tap(find.text('Disabled'));
      await tester.pump();
      expect(calls, isEmpty);
      await tester.tap(find.text('Null'));
      await tester.pumpAndSettle();
      expect(calls, <String>['item']);
    },
  );
  testWidgets(
    'initial value receives selected state and focus, arrows skip disabled and wrap',
    (WidgetTester tester) async {
      useTraditionalFocus();
      await pumpPure(
        tester,
        PopupMenuButton<int>(
          initialValue: 3,
          itemBuilder: (BuildContext context) => _items,
          child: const Text('Actions'),
        ),
      );
      await open(tester);
      MenuItemButton button(String label) => tester.widget<MenuItemButton>(
        find
            .ancestor(
              of: find.text(label),
              matching: find.byType(MenuItemButton),
            )
            .first,
      );
      expect(button('Last').focusNode!.hasFocus, isTrue);
      expect(button('Last').selected, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(button('First').focusNode!.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(button('Last').focusNode!.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(button('Actions').focusNode!.hasFocus, isTrue);
    },
  );
  testWidgets(
    'outside taps cancel and requestFocus false leaves focus on trigger',
    (WidgetTester tester) async {
      int canceled = 0;
      await pumpPure(
        tester,
        PopupMenuButton<int>(
          requestFocus: false,
          itemBuilder: (BuildContext context) => _items,
          onCanceled: () => canceled++,
          child: const Text('Actions'),
        ),
      );
      await open(tester);
      final MenuItemButton trigger = tester.widget<MenuItemButton>(
        find.ancestor(
          of: find.text('Actions'),
          matching: find.byType(MenuItemButton),
        ),
      );
      expect(trigger.focusNode!.hasFocus, isTrue);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(canceled, 1);
      expect(find.text('First'), findsNothing);
    },
  );
  testWidgets('checked indicator, divider and panel inherit component tokens', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await pumpPure(
      tester,
      PopupMenuTheme(
        data: const PopupMenuStyle(
          checkIndicator: StateProperty<Widget?>.all(Text('check')),
          dividerHeight: 11,
          dividerDecoration: BoxDecoration(color: Color(0xFF112233)),
          menuStyle: MenuStyle(padding: EdgeInsets.all(6)),
        ),
        child: PopupMenuButton<int>(
          itemBuilder: (BuildContext context) => _items,
          child: const Text('Actions'),
        ),
      ),
    );
    await open(tester);
    expect(find.text('check'), findsOneWidget);
    expect(tester.getSize(find.byType(PopupMenuDivider)).height, 11);
    expect(
      tester
          .getSemantics(find.text('Last'))
          .getSemanticsData()
          .flagsCollection
          .isChecked,
      CheckedState.isTrue,
    );
    expect(
      tester
          .getSemantics(find.text('Actions'))
          .getSemanticsData()
          .hasAction(SemanticsAction.collapse),
      isTrue,
    );
    handle.dispose();
  });
  testWidgets(
    'icon trigger has 48 square target and child trigger remains content sized',
    (WidgetTester tester) async {
      await pumpPure(
        tester,
        PopupMenuButton<int>(
          itemBuilder: (BuildContext context) => _items,
          icon: const SizedBox(width: 10, height: 10),
        ),
      );
      expect(
        tester.getSize(find.byType(PopupMenuButton<int>)),
        const Size(48, 48),
      );
      await pumpPure(
        tester,
        PopupMenuButton<int>(
          itemBuilder: (BuildContext context) => _items,
          child: const SizedBox(width: 10, height: 10),
        ),
      );
      expect(
        tester.getSize(find.byType(PopupMenuButton<int>)),
        const Size(10, 10),
      );
    },
  );
  testWidgets('position and offset use overlay geometry', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      PopupMenuButton<int>(
        position: PopupMenuPosition.under,
        offset: const Offset(7, 9),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
          const PopupMenuItem<int>(
            value: 1,
            child: SizedBox(width: 60, height: 20),
          ),
        ],
        child: const Text('Actions'),
      ),
    );
    final Rect anchor = tester.getRect(find.byType(PopupMenuButton<int>));
    await open(tester);
    expect(
      tester.getTopLeft(find.byType(PopupMenuItem<int>)),
      Offset(anchor.left + 7, anchor.bottom + 9),
    );
  });
  testWidgets('transition keeps overlay visible until reverse completes', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      PopupMenuButton<int>(
        style: MenuStyleTest.popup,
        itemBuilder: (BuildContext context) => _items,
        child: const Text('Actions'),
      ),
    );
    await open(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump(const Duration(milliseconds: 30));
    expect(find.text('First'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('First'), findsNothing);
  });

  testWidgets(
    'initial selection scrolls into view without scrolling the page',
    (WidgetTester tester) async {
      final ScrollController page = ScrollController();
      addTearDown(page.dispose);
      await pumpPure(
        tester,
        SizedBox(
          height: 350,
          child: SingleChildScrollView(
            controller: page,
            child: Column(
              children: <Widget>[
                PopupMenuButton<int>(
                  initialValue: 35,
                  style: const PopupMenuStyle(
                    menuStyle: MenuStyle(maximumSize: Size(200, 90)),
                  ),
                  itemBuilder: (BuildContext context) =>
                      List<PopupMenuEntry<int>>.generate(
                        40,
                        (int index) => PopupMenuItem<int>(
                          value: index,
                          child: SizedBox(
                            width: 70,
                            height: 30,
                            child: Text('$index'),
                          ),
                        ),
                      ),
                  child: const Text('Actions'),
                ),
                const SizedBox(height: 1000),
              ],
            ),
          ),
        ),
      );
      await open(tester);
      final Finder selected = find.ancestor(
        of: find.text('35'),
        matching: find.byType(MenuItemButton),
      );
      expect(
        tester.widget<MenuItemButton>(selected).focusNode!.hasFocus,
        isTrue,
      );
      final Finder panel = find.byType(SingleChildScrollView).last;
      final Rect viewport = tester.getRect(panel);
      final Rect row = tester.getRect(selected);
      expect(row.top, greaterThanOrEqualTo(viewport.top));
      expect(row.bottom, lessThanOrEqualTo(viewport.bottom));
      expect(page.offset, 0);
    },
  );

  testWidgets('outside taps activate underlying controls and cancel once', (
    WidgetTester tester,
  ) async {
    final List<String> calls = <String>[];
    await pumpPure(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => calls.add('underlying'),
            child: const Text('Other control'),
          ),
          const SizedBox(height: 40),
          PopupMenuButton<int>(
            itemBuilder: (BuildContext context) => _items,
            onCanceled: () => calls.add('cancel'),
            child: const Text('Actions'),
          ),
        ],
      ),
    );
    await open(tester);
    await tester.tap(find.text('Other control'));
    await tester.pumpAndSettle();
    expect(calls, <String>['cancel', 'underlying']);
  });

  testWidgets('item styles fall through per state and preserve all layers', (
    WidgetTester tester,
  ) async {
    const Decoration global = BoxDecoration(color: Color(0xFF112233));
    const Decoration component = BoxDecoration(color: Color(0xFF223344));
    const Decoration inline = BoxDecoration(color: Color(0xFF334455));
    const Decoration entry = BoxDecoration(color: Color(0xFF445566));
    Finder option() => find.ancestor(
      of: find.text('Choose'),
      matching: find.byType(MenuItemButton),
    );
    AnimatedSurface container() => tester.widget<AnimatedSurface>(
      find.descendant(of: option(), matching: find.byType(AnimatedSurface)),
    );
    await pumpPure(
      tester,
      PopupMenuButton<int>(
        itemBuilder: (BuildContext context) => const <PopupMenuEntry<int>>[
          PopupMenuItem<int>(value: 1, child: Text('Choose')),
        ],
        child: const Text('Actions'),
      ),
      theme: const ThemeData(
        popupMenuStyle: PopupMenuStyle(
          itemStyle: ButtonStyle(
            decoration: StateProperty<Decoration?>.all(global),
          ),
        ),
      ),
    );
    await open(tester);
    expect(container().decoration, global);
    await pumpPure(
      tester,
      PopupMenuTheme(
        data: const PopupMenuStyle(
          itemStyle: ButtonStyle(
            decoration: StateProperty<Decoration?>.all(component),
            padding: StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(3)),
          ),
        ),
        child: PopupMenuButton<int>(
          style: PopupMenuStyle(
            itemStyle: ButtonStyle(
              decoration: StateProperty<Decoration?>.resolveWith(
                (InteractionState state) => state.isPressed ? inline : null,
              ),
              padding: const StateProperty<EdgeInsetsGeometry?>.all(
                EdgeInsets.all(5),
              ),
            ),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            PopupMenuItem<int>(
              value: 1,
              style: ButtonStyle(
                decoration: StateProperty<Decoration?>.resolveWith(
                  (InteractionState state) => state.isHovered ? entry : null,
                ),
              ),
              child: const Text('Choose'),
            ),
          ],
          child: const Text('Actions'),
        ),
      ),
      theme: const ThemeData(
        popupMenuStyle: PopupMenuStyle(
          itemStyle: ButtonStyle(
            decoration: StateProperty<Decoration?>.all(global),
          ),
        ),
      ),
    );
    await open(tester);
    expect(container().decoration, component);
    expect(container().padding, const EdgeInsets.all(5));
    final TestGesture mouse = await hover(tester, option());
    expect(container().decoration, entry);
    await mouse.removePointer();
    await tester.pumpAndSettle();
    final TestGesture touch = await tester.startGesture(
      tester.getCenter(option()),
    );
    await tester.pump(kPressTimeout);
    expect(container().decoration, inline);
    await touch.cancel();
    await tester.pumpAndSettle();
  });

  testWidgets('position widget overrides inline and component positions', (
    WidgetTester tester,
  ) async {
    for (final PopupMenuPosition? position in <PopupMenuPosition?>[
      null,
      PopupMenuPosition.under,
    ]) {
      await pumpPure(
        tester,
        PopupMenuTheme(
          data: const PopupMenuStyle(position: PopupMenuPosition.under),
          child: PopupMenuButton<int>(
            position: position,
            style: const PopupMenuStyle(position: PopupMenuPosition.over),
            itemBuilder: (BuildContext context) => const <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 1,
                child: SizedBox(width: 60, height: 20),
              ),
            ],
            child: const Text('Actions'),
          ),
        ),
      );
      final Rect anchor = tester.getRect(find.byType(PopupMenuButton<int>));
      await open(tester);
      expect(
        tester.getTopLeft(find.byType(PopupMenuItem<int>)).dy,
        position == null ? anchor.top : anchor.bottom,
      );
    }
  });

  testWidgets('disabling an open popup closes it with one cancellation', (
    WidgetTester tester,
  ) async {
    bool enabled = true;
    int canceled = 0;
    late StateSetter update;
    await pumpPure(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return PopupMenuButton<int>(
            enabled: enabled,
            itemBuilder: (BuildContext context) => _items,
            onCanceled: () => canceled++,
            child: const Text('Actions'),
          );
        },
      ),
    );
    await open(tester);
    update(() => enabled = false);
    await tester.pumpAndSettle();
    expect(find.text('First'), findsNothing);
    expect(canceled, 1);
  });

  testWidgets('custom entries participate in initial focus and navigation', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      PopupMenuButton<int>(
        initialValue: 7,
        itemBuilder: (BuildContext context) => const <PopupMenuEntry<int>>[
          PopupMenuItem<int>(value: 1, child: Text('First')),
          _CustomEntry(value: 7),
        ],
        child: const Text('Actions'),
      ),
    );
    await open(tester);
    expect(
      Focus.of(tester.element(find.text('Custom'))).hasPrimaryFocus,
      isTrue,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    final MenuItemButton first = tester.widget<MenuItemButton>(
      find.ancestor(
        of: find.text('First'),
        matching: find.byType(MenuItemButton),
      ),
    );
    expect(first.focusNode!.hasPrimaryFocus, isTrue);
  });

  testWidgets('a null checked indicator adds no slot or spacing', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      PopupMenuButton<int>(
        style: const PopupMenuStyle(
          itemStyle: ButtonStyle(spacing: 9),
          checkIndicator: StateProperty<Widget?>.all(null),
        ),
        itemBuilder: (BuildContext context) => const <PopupMenuEntry<int>>[
          CheckedPopupMenuItem<int>(
            value: 1,
            child: SizedBox(width: 20, height: 10),
          ),
        ],
        child: const Text('Actions'),
      ),
    );
    await open(tester);
    expect(tester.getSize(find.byType(CheckedPopupMenuItem<int>)).width, 20);
  });
}

class _CustomEntry extends PopupMenuEntry<int> {
  const _CustomEntry({required this.value});

  final int value;

  @override
  bool represents(int? value) => value == this.value;

  @override
  State<_CustomEntry> createState() => _CustomEntryState();
}

class _CustomEntryState extends State<_CustomEntry> {
  @override
  Widget build(BuildContext context) => const Text('Custom');
}

class MenuStyleTest {
  static const PopupMenuStyle popup = PopupMenuStyle(
    menuStyle: MenuStyle(transitionDuration: Duration(milliseconds: 100)),
  );
}
