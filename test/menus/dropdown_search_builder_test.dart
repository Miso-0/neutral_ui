import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/menus/menu_panel.dart';

import '../helpers/pump.dart';

Finder _option(String label) =>
    find.descendant(of: find.byType(MenuPanel), matching: find.text(label));

Finder _visibleText(String label) => find.byElementPredicate((Element element) {
  if (element.widget is! Text || (element.widget as Text).data != label) {
    return false;
  }
  bool visible = true;
  element.visitAncestorElements((Element ancestor) {
    if (ancestor.widget case Visibility(visible: false)) {
      visible = false;
      return false;
    }
    return true;
  });
  return visible;
});

Future<void> _submit(WidgetTester tester) async {
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
}

void main() {
  testWidgets('the builder supplies entries without label filtering', (
    WidgetTester tester,
  ) async {
    final List<String> queries = <String>[];
    await pumpNeutral(
      tester,
      DropdownMenu<int>(
        requestFocusOnTap: true,
        enableFilter: true,
        searchBuilder: (BuildContext context, String query) {
          queries.add(query);
          return query == 'animal'
              ? const <DropdownMenuEntry<int>>[
                  DropdownMenuEntry<int>(value: 1, label: 'Cat'),
                  DropdownMenuEntry<int>(value: 2, label: 'Dog'),
                ]
              : const <DropdownMenuEntry<int>>[];
        },
      ),
    );
    await tester.enterText(find.byType(EditableText), 'animal');
    await tester.pump();

    expect(queries, contains('animal'));
    expect(_option('Cat'), findsOneWidget);
    expect(_option('Dog'), findsOneWidget);
  });

  testWidgets('Enter selects the first enabled widget-only builder result', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    final List<int?> selections = <int?>[];
    await pumpNeutral(
      tester,
      DropdownMenu<int>(
        controller: controller,
        requestFocusOnTap: true,
        searchBuilder: (BuildContext context, String query) =>
            const <DropdownMenuEntry<int>>[
              DropdownMenuEntry<int>(
                value: 1,
                labelWidget: Text('Unavailable account'),
                enabled: false,
              ),
              DropdownMenuEntry<int>(value: 2, labelWidget: Text('Account 2')),
            ],
        onSelected: selections.add,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'account-id:2');
    await tester.pump();
    expect(_option('Account 2'), findsOneWidget);
    await _submit(tester);
    await tester.pumpAndSettle();

    expect(selections, <int?>[2]);
    expect(controller.text, isEmpty);
    expect(_visibleText('Account 2'), findsOneWidget);
    expect(find.byType(MenuPanel), findsNothing);
  });

  testWidgets('custom highlighting receives the builder results and query', (
    WidgetTester tester,
  ) async {
    const List<DropdownMenuEntry<int>> results = <DropdownMenuEntry<int>>[
      DropdownMenuEntry<int>(value: 1, labelWidget: Text('First account')),
      DropdownMenuEntry<int>(value: 2, labelWidget: Text('Second account')),
    ];
    final List<int?> selections = <int?>[];
    String? receivedQuery;
    await pumpNeutral(
      tester,
      DropdownMenu<int>(
        requestFocusOnTap: true,
        searchBuilder: (BuildContext context, String query) => results,
        searchCallback: (List<DropdownMenuEntry<int>> entries, String query) {
          expect(entries, results);
          receivedQuery = query;
          return 1;
        },
        onSelected: selections.add,
      ),
    );
    await tester.enterText(find.byType(EditableText), 'custom account search');
    await tester.pump();
    await _submit(tester);

    expect(receivedQuery, 'custom account search');
    expect(selections, <int?>[2]);
  });

  testWidgets(
    'a builder-only selection survives changing and reopening results',
    (WidgetTester tester) async {
      const DropdownMenuEntry<int> alpha = DropdownMenuEntry<int>(
        value: 1,
        labelWidget: Text('Alpha account'),
      );
      const DropdownMenuEntry<int> beta = DropdownMenuEntry<int>(
        value: 2,
        labelWidget: Text('Beta account'),
      );
      final MenuController menu = MenuController();
      final List<String> queries = <String>[];
      await pumpNeutral(
        tester,
        DropdownMenu<int>(
          requestFocusOnTap: true,
          menuController: menu,
          searchBuilder: (BuildContext context, String query) {
            queries.add(query);
            return <DropdownMenuEntry<int>>[query == 'alpha' ? alpha : beta];
          },
        ),
      );
      await tester.enterText(find.byType(EditableText), 'alpha');
      await tester.pump();
      await tester.tap(_option('Alpha account'));
      await tester.pumpAndSettle();
      expect(_visibleText('Alpha account'), findsOneWidget);

      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(_option('Beta account'), findsOneWidget);
      expect(_visibleText('Alpha account'), findsOneWidget);

      await tester.enterText(find.byType(EditableText), 'beta');
      await tester.pump();
      expect(_option('Beta account'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), '');
      await tester.pump();
      expect(_visibleText('Alpha account'), findsOneWidget);

      menu.close();
      await tester.pump();
      queries.clear();
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(queries, isNotEmpty);
      expect(queries.last, isEmpty);
      expect(_option('Beta account'), findsOneWidget);
      expect(_visibleText('Alpha account'), findsOneWidget);
    },
  );

  testWidgets(
    'multiple selection retains entries outside new builder results',
    (WidgetTester tester) async {
      const DropdownMenuEntry<int> alpha = DropdownMenuEntry<int>(
        value: 1,
        labelWidget: Text('Alpha account'),
      );
      const DropdownMenuEntry<int> beta = DropdownMenuEntry<int>(
        value: 2,
        labelWidget: Text('Beta account'),
      );
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);
      Set<int> selected = <int>{};
      List<DropdownMenuEntry<int>> selectedEntries = <DropdownMenuEntry<int>>[];
      final List<String> queries = <String>[];
      await pumpNeutral(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DropdownMenu<int>.multiple(
              controller: controller,
              requestFocusOnTap: true,
              selected: selected,
              onSelectionChanged: (Set<int> values) =>
                  setState(() => selected = values),
              searchBuilder: (BuildContext context, String query) {
                queries.add(query);
                return <DropdownMenuEntry<int>>[
                  query == 'alpha' ? alpha : beta,
                ];
              },
              selectionBuilder:
                  (BuildContext context, List<DropdownMenuEntry<int>> entries) {
                    selectedEntries = entries;
                    return Text('Selected: ${entries.length}');
                  },
            );
          },
        ),
      );
      await tester.enterText(find.byType(EditableText), 'alpha');
      await tester.pump();
      await tester.tap(_option('Alpha account'));
      await tester.pump();

      expect(selected, <int>{1});
      expect(controller.text, isEmpty);
      expect(queries.last, isEmpty);
      expect(_option('Beta account'), findsOneWidget);
      expect(selectedEntries, <DropdownMenuEntry<int>>[alpha]);

      await tester.enterText(find.byType(EditableText), 'beta');
      await tester.pump();
      await tester.tap(_option('Beta account'));
      await tester.pump();

      expect(selected, <int>{1, 2});
      expect(controller.text, isEmpty);
      expect(
        selectedEntries,
        unorderedEquals(<DropdownMenuEntry<int>>[alpha, beta]),
      );
      expect(find.text('Selected: 2'), findsOneWidget);
    },
  );

  testWidgets('replacing a builder refreshes results for the current query', (
    WidgetTester tester,
  ) async {
    late StateSetter rebuild;
    DropdownSearchBuilder<int> builder = (BuildContext context, String query) =>
        const <DropdownMenuEntry<int>>[
          DropdownMenuEntry<int>(value: 1, label: 'Old result'),
        ];
    final List<int?> selections = <int?>[];
    final List<String> replacementQueries = <String>[];
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          rebuild = setState;
          return DropdownMenu<int>(
            requestFocusOnTap: true,
            searchBuilder: builder,
            onSelected: selections.add,
          );
        },
      ),
    );
    await tester.enterText(find.byType(EditableText), 'lookup');
    await tester.pump();
    expect(_option('Old result'), findsOneWidget);

    rebuild(() {
      builder = (BuildContext context, String query) {
        replacementQueries.add(query);
        return const <DropdownMenuEntry<int>>[
          DropdownMenuEntry<int>(value: 2, label: 'New result'),
        ];
      };
    });
    await tester.pump();
    expect(replacementQueries, contains('lookup'));
    expect(_option('Old result'), findsNothing);
    expect(_option('New result'), findsOneWidget);
    await _submit(tester);
    expect(selections, <int?>[2]);
  });

  testWidgets(
    'reopening cannot submit a selection absent from builder results',
    (WidgetTester tester) async {
      final List<int?> selections = <int?>[];
      await pumpNeutral(
        tester,
        DropdownMenu<int>(
          requestFocusOnTap: true,
          searchBuilder: (BuildContext context, String query) =>
              <DropdownMenuEntry<int>>[
                if (query == 'alpha')
                  const DropdownMenuEntry<int>(value: 1, label: 'Alpha')
                else
                  const DropdownMenuEntry<int>(value: 2, label: 'Beta'),
              ],
          onSelected: selections.add,
        ),
      );
      await tester.enterText(find.byType(EditableText), 'alpha');
      await tester.pump();
      await _submit(tester);
      await tester.pumpAndSettle();
      expect(selections, <int?>[1]);

      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(_option('Alpha'), findsNothing);
      expect(_option('Beta'), findsOneWidget);
      await _submit(tester);

      expect(selections, <int?>[1, null]);
    },
  );

  testWidgets('Enter cannot toggle a result removed when a query clears', (
    WidgetTester tester,
  ) async {
    Set<int> selected = <int>{};
    final List<Set<int>> updates = <Set<int>>[];
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return DropdownMenu<int>.multiple(
            requestFocusOnTap: true,
            selected: selected,
            onSelectionChanged: (Set<int> values) {
              updates.add(values);
              setState(() => selected = values);
            },
            searchBuilder: (BuildContext context, String query) =>
                <DropdownMenuEntry<int>>[
                  if (query == 'alpha')
                    const DropdownMenuEntry<int>(value: 1, label: 'Alpha')
                  else
                    const DropdownMenuEntry<int>(value: 2, label: 'Beta'),
                ],
          );
        },
      ),
    );
    await tester.enterText(find.byType(EditableText), 'alpha');
    await tester.pump();
    await _submit(tester);
    expect(selected, <int>{1});
    expect(_option('Alpha'), findsNothing);
    expect(_option('Beta'), findsOneWidget);
    await _submit(tester);

    expect(selected, <int>{1});
    expect(updates, <Set<int>>[
      <int>{1},
    ]);
  });

  testWidgets('keyboard highlights use replacement builder entries by value', (
    WidgetTester tester,
  ) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    final List<int?> selections = <int?>[];
    late StateSetter rebuild;
    String label = 'Old result';
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          rebuild = setState;
          return DropdownMenu<int>(
            controller: controller,
            requestFocusOnTap: true,
            searchBuilder: (BuildContext context, String query) =>
                <DropdownMenuEntry<int>>[
                  DropdownMenuEntry<int>(value: 1, label: label),
                ],
            onSelected: selections.add,
          );
        },
      ),
    );
    await tester.enterText(find.byType(EditableText), 'lookup');
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(controller.text, 'Old result');

    rebuild(() => label = 'New result');
    await tester.pump();
    expect(_option('Old result'), findsNothing);
    expect(_option('New result'), findsOneWidget);
    await _submit(tester);

    expect(selections, <int?>[1]);
    expect(controller.text, 'New result');
  });
}
