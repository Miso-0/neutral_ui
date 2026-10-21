import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui_example/main.dart';
import 'package:neutral_ui_example/sections/table_section.dart';

void main() {
  testWidgets('table gallery renders the project and grouped examples', (
    WidgetTester tester,
  ) async {
    await _pumpGallery(tester);
    expect(find.text('14 / Tables'), findsOneWidget);
    final Finder projects = find.byKey(
      const ValueKey<String>('table-projects'),
    );
    final Finder groups = find.byKey(const ValueKey<String>('table-groups'));
    await tester.ensureVisible(projects);
    await tester.pumpAndSettle();

    expect(tester.widget<DataTable>(projects).columns, hasLength(4));
    for (final String header in <String>[
      'Project',
      'Owner',
      'Status',
      'Budget',
    ]) {
      expect(
        find.descendant(of: projects, matching: find.text(header)),
        findsOneWidget,
      );
    }
    for (final String project in <String>[
      'atlas',
      'beacon',
      'canopy',
      'delta',
    ]) {
      expect(_projectRow(project), findsOneWidget);
    }
    expect(find.text('No projects selected'), findsOneWidget);
    expect(tester.widget<DataTable>(groups).groups, hasLength(2));
    expect(find.text('Product / 2 workstreams'), findsOneWidget);
    expect(find.text('Operations / 2 workstreams'), findsOneWidget);
    expect(find.text('Portfolio total'), findsOneWidget);
    expect(find.text('\$148,000'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'project selection and expansion follow the project after sorting',
    (WidgetTester tester) async {
      await _pumpGallery(tester);
      final Finder atlas = _projectRow('atlas');
      final Finder checkbox = find.descendant(
        of: atlas,
        matching: find.byType(Checkbox),
      );
      await _tap(tester, checkbox);
      expect(find.text('1 project selected'), findsOneWidget);
      expect(tester.widget<Checkbox>(checkbox).value, isTrue);

      await _tap(
        tester,
        find.descendant(
          of: atlas,
          matching: find.byWidgetPredicate(
            (Widget widget) =>
                widget is Semantics && widget.properties.label == 'Expand',
          ),
        ),
      );
      final Finder details = find.byKey(
        const ValueKey<String>('table-details-atlas'),
      );
      expect(details, findsOneWidget);
      expect(
        tester.getTopLeft(atlas).dy,
        lessThan(tester.getTopLeft(_projectRow('delta')).dy),
      );

      await _tap(
        tester,
        find.byKey(const ValueKey<String>('table-sort-project')),
      );
      expect(
        tester.getTopLeft(_projectRow('delta')).dy,
        lessThan(tester.getTopLeft(atlas).dy),
      );
      expect(tester.widget<Checkbox>(checkbox).value, isTrue);
      expect(
        tester
            .widget<Checkbox>(
              find.descendant(
                of: _projectRow('delta'),
                matching: find.byType(Checkbox),
              ),
            )
            .value,
        isFalse,
      );
      expect(details, findsOneWidget);
      expect(find.text('1 project selected'), findsOneWidget);

      await _tap(
        tester,
        find.byKey(const ValueKey<String>('table-sort-budget')),
      );
      _expectProjectOrder(tester, <String>[
        'delta',
        'beacon',
        'atlas',
        'canopy',
      ]);
      expect(tester.widget<Checkbox>(checkbox).value, isTrue);
      expect(details, findsOneWidget);

      await _tap(tester, checkbox);
      expect(find.text('No projects selected'), findsOneWidget);
      expect(tester.widget<Checkbox>(checkbox).value, isFalse);
      await _tap(
        tester,
        find.descendant(
          of: atlas,
          matching: find.byWidgetPredicate(
            (Widget widget) =>
                widget is Semantics && widget.properties.label == 'Collapse',
          ),
        ),
      );
      expect(details, findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('workstream groups and nested tasks expand independently', (
    WidgetTester tester,
  ) async {
    await _pumpGallery(tester);
    expect(find.text('Design system'), findsOneWidget);
    expect(find.text('Team onboarding'), findsNothing);
    expect(find.text('Token audit'), findsNothing);

    await _tap(tester, find.text('Product / 2 workstreams'));
    expect(find.text('Design system'), findsNothing);
    expect(find.text('Website launch'), findsNothing);
    await _tap(tester, find.text('Operations / 2 workstreams'));
    expect(find.text('Team onboarding'), findsOneWidget);
    expect(find.text('Quarterly planning'), findsOneWidget);
    expect(find.text('Design system'), findsNothing);

    await _tap(tester, find.text('Product / 2 workstreams'));
    final Finder designSystem = find
        .ancestor(of: find.text('Design system'), matching: find.byType(Table))
        .first;
    await _tap(tester, _expandControl(designSystem));
    expect(find.text('Token audit'), findsOneWidget);
    expect(find.text('Component QA'), findsOneWidget);
    expect(find.text('Team onboarding'), findsOneWidget);

    await _tap(tester, find.text('Product / 2 workstreams'));
    expect(find.text('Token audit'), findsNothing);
    expect(find.text('Team onboarding'), findsOneWidget);
    await _tap(tester, find.text('Product / 2 workstreams'));
    expect(find.text('Token audit'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('table examples scroll horizontally on a narrow screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const NeutralApp(
        color: Color(0xFFF4F7F3),
        home: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(16), child: TableSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (final String key in <String>['table-projects', 'table-groups']) {
      final Finder table = find.byKey(ValueKey<String>(key));
      final Finder horizontal = find.ancestor(
        of: table,
        matching: find.byWidgetPredicate(
          (Widget widget) =>
              widget is SingleChildScrollView &&
              widget.scrollDirection == Axis.horizontal,
        ),
      );
      final Finder scrollable = find.descendant(
        of: horizontal,
        matching: find.byType(Scrollable),
      );
      final ScrollableState state = tester.state<ScrollableState>(scrollable);
      expect(state.position.maxScrollExtent, greaterThan(0));
      await tester.ensureVisible(horizontal);
      await tester.pumpAndSettle();
      final double before = state.position.pixels;
      await tester.drag(horizontal, const Offset(-240, 0));
      await tester.pumpAndSettle();
      expect(state.position.pixels, greaterThan(before));
    }
    expect(tester.takeException(), isNull);
  });
}

Finder _projectRow(String id) =>
    find.byKey(ValueKey<String>('table-project-$id'));

Finder _expandControl(Finder row) => find.descendant(
  of: row,
  matching: find.byWidgetPredicate(
    (Widget widget) =>
        widget is Semantics && widget.properties.label == 'Expand',
  ),
);

void _expectProjectOrder(WidgetTester tester, List<String> ids) {
  for (int i = 1; i < ids.length; i++) {
    expect(
      tester.getTopLeft(_projectRow(ids[i - 1])).dy,
      lessThan(tester.getTopLeft(_projectRow(ids[i])).dy),
    );
  }
}

Future<void> _pumpGallery(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1280, 1100);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const GalleryApp());
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}
