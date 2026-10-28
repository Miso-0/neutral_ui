import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui_example/examples/chips/choice_chip_example.dart';
import 'package:neutral_ui_example/examples/chips/filter_chip_example.dart';
import 'package:neutral_ui_example/examples/chips/input_chip_example.dart';
import 'package:neutral_ui_example/examples/navigation/expansion_tile_example.dart';
import 'package:neutral_ui_example/examples/navigation/navigation_bar_example.dart';
import 'package:neutral_ui_example/examples/navigation/navigation_drawer_example.dart';
import 'package:neutral_ui_example/examples/navigation/navigation_rail_example.dart';
import 'package:neutral_ui_example/examples/navigation/tab_bar_example.dart';

void main() {
  testWidgets('tabs change their view in a narrow preview', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const TabBarExample());
    expect(find.text('Swipe to explore each tab'), findsOneWidget);
    await tester.tap(find.text('Activity'));
    await tester.pumpAndSettle();
    expect(find.text('Activity appears here'), findsOneWidget);
    expect(find.text('Swipe to explore each tab'), findsNothing);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Your preferences'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expansion tile opens, closes and reopens its content', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const ExpansionTileExample());
    final Finder content = find.text(
      'This content stays mounted while collapsed.',
    );
    expect(content, findsNothing);
    await tester.tap(find.text('Project details'));
    await tester.pumpAndSettle();
    expect(content, findsOneWidget);
    final Element child = content.evaluate().single;
    await tester.tap(find.text('Project details'));
    await tester.pumpAndSettle();
    expect(content, findsNothing);
    expect(child.mounted, isTrue);
    await tester.tap(find.text('Project details'));
    await tester.pumpAndSettle();
    expect(content.evaluate().single, same(child));
    expect(tester.takeException(), isNull);
  });

  testWidgets('filter chip toggles while the disabled filter stays inert', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const FilterChipExample());
    expect(
      tester.widget<FilterChip>(find.byType(FilterChip).first).selected,
      isTrue,
    );
    await tester.tap(find.text('Available'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilterChip>(find.byType(FilterChip).first).selected,
      isFalse,
    );
    await tester.tap(find.text('Unavailable'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilterChip>(find.byType(FilterChip).last).onSelected,
      isNull,
    );
    expect(
      tester.widget<FilterChip>(find.byType(FilterChip).last).selected,
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('choice chips maintain one selected choice', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const ChoiceChipExample());
    await tester.tap(find.text('Recent'));
    await tester.pumpAndSettle();
    final List<ChoiceChip> choices = tester
        .widgetList<ChoiceChip>(find.byType(ChoiceChip))
        .toList();
    expect(choices.map((ChoiceChip chip) => chip.selected), <bool>[
      false,
      true,
      false,
    ]);
    await tester.tap(find.text('Recent'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<ChoiceChip>(find.byType(ChoiceChip).at(1)).selected,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('input chip can select, delete and restore its label', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const InputChipExample());
    await tester.tap(find.text('Remove me'));
    await tester.pumpAndSettle();
    expect(tester.widget<InputChip>(find.byType(InputChip)).selected, isTrue);
    await tester.tap(find.byType(CloseGlyph));
    await tester.pumpAndSettle();
    expect(find.byType(InputChip), findsNothing);
    await tester.tap(find.text('Add a label'));
    await tester.pumpAndSettle();
    expect(find.byType(InputChip), findsOneWidget);
    expect(tester.widget<InputChip>(find.byType(InputChip)).selected, isTrue);
    expect(tester.takeException(), isNull);
  });

  for (final Widget example in <Widget>[
    const NavigationBarExample(),
    const NavigationRailExample(),
    const NavigationDrawerExample(),
  ]) {
    testWidgets(
      '${example.runtimeType} changes destination in a narrow preview',
      (WidgetTester tester) async {
        await _pump(tester, example);
        await tester.tap(find.text('Schedule'));
        await tester.pumpAndSettle();
        expect(_selectedIndex(tester, example), 1);
        await tester.tap(find.text('Recent'));
        await tester.pumpAndSettle();
        expect(_selectedIndex(tester, example), 2);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

int? _selectedIndex(WidgetTester tester, Widget example) {
  if (example is NavigationBarExample) {
    return tester
        .widget<NavigationBar>(find.byType(NavigationBar))
        .selectedIndex;
  }
  if (example is NavigationRailExample) {
    return tester
        .widget<NavigationRail>(find.byType(NavigationRail))
        .selectedIndex;
  }
  return tester
      .widget<NavigationDrawer>(find.byType(NavigationDrawer))
      .selectedIndex;
}

Future<void> _pump(WidgetTester tester, Widget example) async {
  // At a 390px viewport, the library card supplies 294px to its preview.
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    NeutralApp(
      color: const Color(0xFFFFFFFF),
      theme: const ThemeData(),
      home: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(48), child: example),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}
