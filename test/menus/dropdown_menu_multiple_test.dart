import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/menus/menu_panel.dart';

import '../helpers/pump.dart';

const List<DropdownMenuEntry<int>> _entries = <DropdownMenuEntry<int>>[
  DropdownMenuEntry<int>(value: 1, label: 'Apple'),
  DropdownMenuEntry<int>(value: 2, label: 'Banana'),
  DropdownMenuEntry<int>(value: 3, label: 'Cherry', enabled: false),
];

Finder _option(String label) =>
    find.descendant(of: find.byType(MenuPanel), matching: find.text(label));

void main() {
  testWidgets('toggles a controlled set and stays open', (
    WidgetTester tester,
  ) async {
    Set<int> selected = <int>{1};
    final MenuController menu = MenuController();
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return DropdownMenu<int>.multiple(
            dropdownMenuEntries: _entries,
            selected: selected,
            onSelectionChanged: (Set<int> values) =>
                setState(() => selected = values),
            menuController: menu,
            requestFocusOnTap: true,
          );
        },
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.pump();
    await tester.tap(_option('Banana'));
    await tester.pump();
    expect(selected, <int>{1, 2});
    expect(menu.isOpen, isTrue);
    await tester.tap(_option('Apple'));
    await tester.pump();
    expect(selected, <int>{2});
    expect(menu.isOpen, isTrue);
  });

  testWidgets(
    'does not remove the last value when empty selection is forbidden',
    (WidgetTester tester) async {
      final List<Set<int>> updates = <Set<int>>[];
      await pumpNeutral(
        tester,
        DropdownMenu<int>.multiple(
          dropdownMenuEntries: _entries,
          selected: const <int>{1},
          onSelectionChanged: updates.add,
          emptySelectionAllowed: false,
          requestFocusOnTap: true,
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await tester.tap(_option('Apple'));
      await tester.pump();
      expect(updates, isEmpty);
      await tester.tap(_option('Banana'));
      await tester.pump();
      expect(updates, <Set<int>>[
        <int>{1, 2},
      ]);
    },
  );

  testWidgets('query clears after a toggle and all options return', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    final List<Set<int>> updates = <Set<int>>[];
    await pumpNeutral(
      tester,
      DropdownMenu<int>.multiple(
        dropdownMenuEntries: _entries,
        selected: const <int>{},
        onSelectionChanged: updates.add,
        controller: controller,
        enableFilter: true,
        requestFocusOnTap: true,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Ban');
    await tester.pump();
    expect(_option('Apple'), findsNothing);
    await tester.tap(_option('Banana'));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(_option('Apple'), findsOneWidget);
    expect(updates.single, <int>{2});
  });

  testWidgets('Enter toggles the highlight while text remains a query', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    final List<Set<int>> updates = <Set<int>>[];
    await pumpNeutral(
      tester,
      DropdownMenu<int>.multiple(
        dropdownMenuEntries: _entries,
        selected: const <int>{1},
        onSelectionChanged: updates.add,
        controller: controller,
        requestFocusOnTap: true,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'Ban');
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(controller.text, 'Ban');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(updates.single, isEmpty);
    expect(controller.text, isEmpty);
  });

  testWidgets('selected labels form a summary in entry order', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      DropdownMenu<int>.multiple(
        dropdownMenuEntries: _entries,
        selected: const <int>{2, 1},
        onSelectionChanged: (Set<int> selected) {},
        requestFocusOnTap: true,
      ),
    );
    expect(find.text('Apple, Banana'), findsOneWidget);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      isEmpty,
    );
  });

  testWidgets('selectionBuilder replaces the summary with leading content', (
    WidgetTester tester,
  ) async {
    List<int>? received;
    await pumpNeutral(
      tester,
      DropdownMenu<int>.multiple(
        dropdownMenuEntries: _entries,
        selected: const <int>{2, 1},
        onSelectionChanged: (Set<int> selected) {},
        requestFocusOnTap: true,
        selectionBuilder:
            (BuildContext context, List<DropdownMenuEntry<int>> selected) {
              received = selected
                  .map((DropdownMenuEntry<int> entry) => entry.value)
                  .toList();
              return const Text('Custom chips');
            },
      ),
    );
    expect(received, <int>[1, 2]);
    expect(find.text('Custom chips'), findsOneWidget);
    expect(find.text('Apple, Banana'), findsNothing);
  });

  testWidgets(
    'options expose checked state and disabled options do not toggle',
    (WidgetTester tester) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      final List<Set<int>> updates = <Set<int>>[];
      await pumpNeutral(
        tester,
        DropdownMenu<int>.multiple(
          dropdownMenuEntries: _entries,
          selected: const <int>{1},
          onSelectionChanged: updates.add,
          requestFocusOnTap: true,
          semanticLabel: 'Fruit',
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(_option('Apple')),
        matchesSemantics(
          label: 'Apple',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasSelectedState: true,
          isSelected: true,
          hasCheckedState: true,
          isChecked: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
        ),
      );
      await tester.tap(_option('Cherry'));
      await tester.pump();
      expect(updates, isEmpty);
      semantics.dispose();
    },
  );

  testWidgets('an explicit close behavior closes after a toggle', (
    WidgetTester tester,
  ) async {
    final MenuController menu = MenuController();
    final List<Set<int>> updates = <Set<int>>[];
    await pumpNeutral(
      tester,
      DropdownMenu<int>.multiple(
        dropdownMenuEntries: _entries,
        selected: const <int>{},
        onSelectionChanged: updates.add,
        requestFocusOnTap: true,
        menuController: menu,
        closeBehavior: DropdownMenuCloseBehavior.self,
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.pump();
    await tester.tap(_option('Apple'));
    await tester.pump();
    expect(menu.isOpen, isFalse);
    expect(updates.single, <int>{1});
  });
}
