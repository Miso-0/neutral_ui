import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui_example/examples/tables/grouped_workstreams_example.dart';
import 'package:neutral_ui_example/examples/tables/project_table_example.dart';

void main() {
  testWidgets(
    'portfolio renders columns, totals and explicit selection controls',
    (WidgetTester tester) async {
      await _pump(tester, const ProjectTableExample());
      final DataTable table = tester.widget<DataTable>(find.byType(DataTable));
      expect(table.columns, hasLength(4));
      expect(table.style, isNotNull);
      for (final String header in <String>[
        'Project',
        'Owner',
        'Status',
        'Budget',
      ]) {
        expect(find.text(header), findsOneWidget);
      }
      expect(find.byType(Checkbox), findsNWidgets(5));
      expect(find.text('Portfolio total'), findsOneWidget);
      expect(find.text(r'$148,000'), findsOneWidget);
      expect(find.text('No projects selected'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('selection and expansion follow a project through sorting', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const ProjectTableExample());
    final Finder atlas = _row('Atlas website');
    final Finder checkbox = find.descendant(
      of: atlas,
      matching: find.byType(Checkbox),
    );
    await _tap(tester, checkbox);
    expect(find.text('1 project selected'), findsOneWidget);
    expect(tester.widget<Checkbox>(checkbox).value, isTrue);
    await _tap(tester, _expansion(atlas, 'Expand'));
    final Finder details = find.text(
      'A refreshed home for the brand, from discovery to launch.',
    );
    expect(details, findsOneWidget);
    _expectOrder(tester, <String>[
      'Atlas website',
      'Beacon mobile',
      'Canopy platform',
      'Delta research',
    ]);

    await _tap(tester, find.text('Project'));
    _expectOrder(tester, <String>[
      'Delta research',
      'Canopy platform',
      'Beacon mobile',
      'Atlas website',
    ]);
    expect(tester.widget<Checkbox>(checkbox).value, isTrue);
    expect(details, findsOneWidget);
    expect(
      tester
          .widget<Checkbox>(
            find.descendant(
              of: _row('Delta research'),
              matching: find.byType(Checkbox),
            ),
          )
          .value,
      isFalse,
    );

    await _tap(tester, find.text('Budget'));
    _expectOrder(tester, <String>[
      'Delta research',
      'Beacon mobile',
      'Atlas website',
      'Canopy platform',
    ]);
    expect(tester.widget<Checkbox>(checkbox).value, isTrue);
    expect(details, findsOneWidget);
    await _tap(tester, checkbox);
    expect(find.text('No projects selected'), findsOneWidget);
    await _tap(tester, _expansion(atlas, 'Collapse'));
    expect(details, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('select all and clear selection update portfolio state', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const ProjectTableExample());
    await _tap(tester, find.byType(Checkbox).first);
    expect(find.text('4 projects selected'), findsOneWidget);
    for (final Checkbox checkbox in tester.widgetList<Checkbox>(
      find.byType(Checkbox),
    )) {
      expect(checkbox.value, isTrue);
    }
    await _tap(tester, find.text('Clear selection'));
    expect(find.text('No projects selected'), findsOneWidget);
    expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, isFalse);
  });

  testWidgets('groups and nested tasks expand independently', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const GroupedWorkstreamsExample());
    expect(find.text('Design system'), findsOneWidget);
    expect(find.text('Team onboarding'), findsNothing);
    expect(find.text('Token audit'), findsNothing);
    await _tap(tester, find.text('Product / 2 workstreams'));
    expect(find.text('Design system'), findsNothing);
    expect(find.text('Website launch'), findsNothing);
    await _tap(tester, find.text('Operations / 2 workstreams'));
    expect(find.text('Team onboarding'), findsOneWidget);
    expect(find.text('Quarterly planning'), findsOneWidget);
    await _tap(tester, find.text('Product / 2 workstreams'));
    await _tap(tester, _expansion(_row('Design system'), 'Expand'));
    expect(find.text('Token audit'), findsOneWidget);
    expect(find.text('Component QA'), findsOneWidget);
    await _tap(tester, find.text('Product / 2 workstreams'));
    expect(find.text('Token audit'), findsNothing);
    expect(find.text('Team onboarding'), findsOneWidget);
    await _tap(tester, find.text('Product / 2 workstreams'));
    expect(find.text('Token audit'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final Widget example in <Widget>[
    const ProjectTableExample(),
    const GroupedWorkstreamsExample(),
  ]) {
    testWidgets('${example.runtimeType} scrolls horizontally at phone width', (
      WidgetTester tester,
    ) async {
      await _pump(tester, example, width: 390);
      final Finder horizontal = find.byWidgetPredicate(
        (Widget widget) =>
            widget is SingleChildScrollView &&
            widget.scrollDirection == Axis.horizontal,
      );
      final ScrollableState state = tester.state<ScrollableState>(
        find.descendant(of: horizontal, matching: find.byType(Scrollable)),
      );
      expect(state.position.maxScrollExtent, greaterThan(0));
      await tester.drag(horizontal, const Offset(-240, 0));
      await tester.pumpAndSettle();
      expect(state.position.pixels, greaterThan(0));
      expect(tester.takeException(), isNull);
    });
  }
}

Finder _row(String name) =>
    find.ancestor(of: find.text(name), matching: find.byType(Table)).first;

Finder _expansion(Finder row, String label) => find.descendant(
  of: row,
  matching: find.byWidgetPredicate(
    (Widget widget) => widget is Semantics && widget.properties.label == label,
  ),
);

void _expectOrder(WidgetTester tester, List<String> names) {
  for (int i = 1; i < names.length; i++) {
    expect(
      tester.getTopLeft(find.text(names[i - 1])).dy,
      lessThan(tester.getTopLeft(find.text(names[i])).dy),
    );
  }
}

Future<void> _pump(
  WidgetTester tester,
  Widget example, {
  double width = 1280,
}) async {
  tester.view.physicalSize = Size(width, 1100);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    NeutralApp(
      color: const Color(0xFFF4F7F3),
      theme: const ThemeData(),
      home: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(16), child: example),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}
