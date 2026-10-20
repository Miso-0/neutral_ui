import 'dart:ui' show Tristate;

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

void main() {
  test('range tick decorations require divisions', () {
    const BoxDecoration decoration = BoxDecoration(color: Color(0xff123456));
    expect(
      () => RangeSlider(
        values: const RangeValues(0.2, 0.8),
        onChanged: null,
        tickMarkDecoration: decoration,
      ),
      throwsAssertionError,
    );
    expect(
      () => RangeSlider(
        values: const RangeValues(0.2, 0.8),
        onChanged: null,
        activeTickMarkDecoration: decoration,
      ),
      throwsAssertionError,
    );
    expect(
      () => RangeSlider(
        values: const RangeValues(0.2, 0.8),
        onChanged: null,
        divisions: 10,
        tickMarkDecoration: decoration,
        activeTickMarkDecoration: decoration,
      ),
      returnsNormally,
    );
  });

  testWidgets(
    'selected disabled chips retain the check and selection semantics',
    (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await pumpPure(
        tester,
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ChoiceChip(label: Text('Choice'), selected: true),
            FilterChip(label: Text('Filter'), selected: true, onSelected: null),
          ],
        ),
      );
      expect(find.byType(CheckGlyph), findsNWidgets(2));
      for (final String label in <String>['Choice', 'Filter']) {
        final SemanticsData data = tester
            .getSemantics(find.bySemanticsLabel(label))
            .getSemanticsData();
        expect(data.flagsCollection.isSelected, Tristate.isTrue);
        expect(data.hasAction(SemanticsAction.tap), isFalse);
      }
      handle.dispose();
    },
  );

  testWidgets(
    'filter check width moves monotonically between selection states',
    (WidgetTester tester) async {
      bool selected = false;
      await pumpPure(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => FilterChip(
            label: const Text('Filter'),
            selected: selected,
            onSelected: (bool next) => setState(() => selected = next),
          ),
        ),
      );
      final Finder check = find.descendant(
        of: find.byType(FilterChip),
        matching: find.byType(AnimatedSize),
      );
      final double initial = tester.getSize(check).width;
      await tester.tap(find.text('Filter'));
      await tester.pump();
      final List<double> increasing = await sampleValues(
        tester,
        () => tester.getSize(check).width,
      );
      final double finalWidth = tester.getSize(check).width;
      expect(finalWidth, greaterThan(initial));
      expectMonotonicValues(increasing, from: initial, to: finalWidth);
      expect(
        increasing.any((double value) => value > initial && value < finalWidth),
        isTrue,
      );
      await tester.tap(find.text('Filter'));
      await tester.pump();
      final List<double> decreasing = await sampleValues(
        tester,
        () => tester.getSize(check).width,
      );
      expectMonotonicValues(decreasing, from: finalWidth, to: initial);
    },
  );

  testWidgets('chip decoration shortcut overrides the component theme', (
    WidgetTester tester,
  ) async {
    const BoxDecoration inherited = BoxDecoration(color: Color(0xff112233));
    const BoxDecoration inline = BoxDecoration(color: Color(0xffabcdef));
    await pumpPure(
      tester,
      const ChipTheme(
        data: ChipStyle(
          buttonStyle: ButtonStyle(
            decoration: StateProperty<Decoration?>.all(inherited),
          ),
        ),
        child: Chip(label: Text('Chip'), decoration: inline),
      ),
    );
    expect(tester.takeException(), isNull);
    final Finder surface = find.descendant(
      of: find.byType(Chip),
      matching: find.byType(AnimatedSurface),
    );
    expect(tester.widget<AnimatedSurface>(surface).decoration, inline);
  });

  testWidgets('segment tooltip displays a visible tooltip', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      SegmentedButton<int>(
        segments: const <ButtonSegment<int>>[
          ButtonSegment<int>(
            value: 1,
            label: Text('One'),
            tooltip: 'First option',
          ),
          ButtonSegment<int>(value: 2, label: Text('Two')),
        ],
        selected: const <int>{1},
        onSelectionChanged: (Set<int> _) {},
      ),
    );
    expect(
      tester.widget<Tooltip>(find.byType(Tooltip)).message,
      'First option',
    );
    final TooltipState tooltip = tester.state<TooltipState>(
      find.byType(Tooltip),
    );
    tooltip.ensureTooltipVisible();
    await tester.pumpAndSettle();
    expect(find.text('First option'), findsOneWidget);
    tooltip.dismiss();
    await tester.pumpAndSettle();
  });

  testWidgets(
    'segmented values must be unique and selected values must exist',
    (WidgetTester tester) async {
      await pumpPure(
        tester,
        SegmentedButton<int>(
          segments: const <ButtonSegment<int>>[
            ButtonSegment<int>(value: 1),
            ButtonSegment<int>(value: 1),
          ],
          selected: const <int>{1},
        ),
      );
      expect(tester.takeException(), isAssertionError);
      await pumpPure(
        tester,
        SegmentedButton<int>(
          segments: const <ButtonSegment<int>>[
            ButtonSegment<int>(value: 1),
            ButtonSegment<int>(value: 2),
          ],
          selected: const <int>{3},
        ),
      );
      expect(tester.takeException(), isAssertionError);
    },
  );

  testWidgets(
    'FAB variants size their visual content and share a 48 pixel target',
    (WidgetTester tester) async {
      await pumpPure(
        tester,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton.small(
              key: const ValueKey<String>('small'),
              onPressed: () {},
              heroTag: null,
            ),
            FloatingActionButton(
              key: const ValueKey<String>('normal'),
              onPressed: () {},
              heroTag: null,
            ),
            FloatingActionButton.large(
              key: const ValueKey<String>('large'),
              onPressed: () {},
              heroTag: null,
            ),
          ],
        ),
      );
      expect(
        tester.getSize(find.byKey(const ValueKey<String>('small'))),
        const Size(48, 48),
      );
      expect(
        tester.getSize(find.byKey(const ValueKey<String>('normal'))),
        const Size(56, 56),
      );
      expect(
        tester.getSize(find.byKey(const ValueKey<String>('large'))),
        const Size(96, 96),
      );
    },
  );

  testWidgets(
    'range thumb semantics expose independent formatted adjustments',
    (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      final List<RangeValues> values = <RangeValues>[];
      await pumpPure(
        tester,
        SizedBox(
          width: 240,
          child: RangeSlider(
            values: const RangeValues(2, 8),
            min: 0,
            max: 10,
            divisions: 10,
            labels: const RangeLabels('Minimum', 'Maximum'),
            semanticFormatterCallback: (double value) =>
                '${value.toInt()} units',
            onChanged: values.add,
          ),
        ),
      );
      final SemanticsNode low = tester.getSemantics(
        find.bySemanticsLabel('Minimum'),
      );
      final SemanticsNode high = tester.getSemantics(
        find.bySemanticsLabel('Maximum'),
      );
      expect(low.getSemanticsData().value, '2 units');
      expect(high.getSemanticsData().value, '8 units');
      expect(low.getSemanticsData().increasedValue, '3 units');
      expect(high.getSemanticsData().decreasedValue, '7 units');
      low.owner!.performAction(low.id, SemanticsAction.increase);
      high.owner!.performAction(high.id, SemanticsAction.decrease);
      expect(values, const <RangeValues>[RangeValues(3, 8), RangeValues(2, 7)]);
      handle.dispose();
    },
  );

  testWidgets('TabController settles to the selected tab from an offset', (
    WidgetTester tester,
  ) async {
    final TabController controller = TabController(length: 2, vsync: tester);
    addTearDown(controller.dispose);
    controller.offset = 0.3;
    controller.animateTo(0);
    expect(controller.animation.value, closeTo(0.3, 0.00000001));
    await tester.pumpAndSettle();
    expect(controller.animation.value, closeTo(0, 0.001));
  });

  testWidgets('TabBarView synchronizes a replacement controller', (
    WidgetTester tester,
  ) async {
    final TabController first = TabController(length: 2, vsync: tester);
    final TabController second = TabController(
      length: 2,
      initialIndex: 1,
      vsync: tester,
    );
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    TabController current = first;
    late StateSetter update;
    await pumpPure(
      tester,
      SizedBox(
        width: 200,
        height: 100,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            update = setState;
            return TabBarView(
              controller: current,
              children: const <Widget>[Text('First page'), Text('Second page')],
            );
          },
        ),
      ),
    );
    update(() => current = second);
    await tester.pumpAndSettle();
    expect(
      tester.getCenter(find.text('Second page')).dx,
      closeTo(tester.getCenter(find.byType(TabBarView)).dx, 0.01),
    );
  });

  testWidgets('NavigationTheme inherits through the bar component theme', (
    WidgetTester tester,
  ) async {
    const NavigationStyle style = NavigationStyle(spacing: 9);
    late NavigationStyle found;
    await pumpPure(
      tester,
      NavigationTheme(
        data: style,
        child: Builder(
          builder: (BuildContext context) {
            found = NavigationBarTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(found, style);
  });
}
