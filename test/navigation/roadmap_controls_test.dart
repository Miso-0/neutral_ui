import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/buttons/selection_button.dart';
import 'package:pure_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

const SliderStyle _rangeStyle = SliderStyle(
  thumbSize: StateProperty<Size?>.all(Size(20, 20)),
  trackHeight: StateProperty<double?>.all(4),
  thumbDecoration: StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xff000000)),
  ),
  trackDecoration: StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xffaaaaaa)),
  ),
  activeTrackDecoration: StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xff444444)),
  ),
);
void main() {
  testWidgets('FilledButton variants activate and FAB has a 48 pixel target', (
    WidgetTester tester,
  ) async {
    int calls = 0;
    await pumpPure(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FilledButton(onPressed: () => calls++, child: const Text('Filled')),
          FilledButton.icon(
            onPressed: () => calls++,
            icon: const SizedBox.square(dimension: 12),
            label: const Text('Icon'),
          ),
          FilledButton.tonal(
            onPressed: () => calls++,
            child: const Text('Tonal'),
          ),
          FilledButton.tonalIcon(
            onPressed: () => calls++,
            label: const Text('Tonal icon'),
          ),
          FloatingActionButton.small(
            onPressed: () => calls++,
            heroTag: null,
            child: const Text('+'),
          ),
        ],
      ),
    );
    for (final String label in <String>[
      'Filled',
      'Icon',
      'Tonal',
      'Tonal icon',
      '+',
    ]) {
      await tester.tap(find.text(label));
    }
    expect(calls, 5);
    expect(
      tester.getSize(find.byType(FloatingActionButton)).width,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSize(find.byType(FloatingActionButton)).height,
      greaterThanOrEqualTo(48),
    );
  });

  testWidgets(
    'segmented selection preserves required value and skips disabled segments with keyboard',
    (WidgetTester tester) async {
      Set<int> selected = <int>{0};
      final FocusNode first = FocusNode(), last = FocusNode();
      addTearDown(first.dispose);
      addTearDown(last.dispose);
      await pumpPure(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) =>
              SegmentedButton<int>(
                segments: const <ButtonSegment<int>>[
                  ButtonSegment<int>(value: 0, label: Text('One')),
                  ButtonSegment<int>(
                    value: 1,
                    label: Text('Disabled'),
                    enabled: false,
                  ),
                  ButtonSegment<int>(value: 2, label: Text('Three')),
                ],
                focusNodes: <FocusNode>[
                  first,
                  FocusNode(skipTraversal: true),
                  last,
                ],
                selected: selected,
                onSelectionChanged: (Set<int> next) =>
                    setState(() => selected = next),
              ),
        ),
      );
      await tester.tap(find.text('One'));
      await tester.pump();
      expect(selected, <int>{0});
      first.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(last.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(selected, <int>{2});
    },
  );

  testWidgets('toggle buttons honor supplied focus nodes and RTL traversal', (
    WidgetTester tester,
  ) async {
    final FocusNode first = FocusNode(), second = FocusNode();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    int? pressed;
    await pumpPure(
      tester,
      ToggleButtons(
        isSelected: const <bool>[false, true],
        focusNodes: <FocusNode>[first, second],
        onPressed: (int index) => pressed = index,
        children: const <Widget>[Text('A'), Text('B')],
      ),
      textDirection: TextDirection.rtl,
    );
    first.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(second.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(pressed, 1);
  });

  testWidgets(
    'chip selection animates its check and deletion remains independent',
    (WidgetTester tester) async {
      bool selected = false;
      int deleted = 0;
      await pumpPure(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => InputChip(
            label: const Text('Chip'),
            selected: selected,
            onSelected: (bool value) => setState(() => selected = value),
            onDeleted: () => deleted++,
          ),
        ),
      );
      final Finder checks = find.byType(CheckGlyph);
      expect(checks, findsNothing);
      await tester.tap(find.text('Chip'));
      await tester.pump();
      expect(selected, isTrue);
      expect(checks, findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        tester
            .widget<AnimatedSize>(
              find
                  .ancestor(of: checks, matching: find.byType(AnimatedSize))
                  .first,
            )
            .duration,
        const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CloseGlyph));
      await tester.pump();
      expect(deleted, 1);
      expect(selected, isTrue);
    },
  );

  testWidgets(
    'disabled choice chips cannot select and delete tooltip is localized',
    (WidgetTester tester) async {
      await pumpPure(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ChoiceChip(label: Text('Disabled'), selected: true),
            Chip(label: const Text('Delete me'), onDeleted: () {}),
          ],
        ),
      );
      final Tooltip tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, 'Delete');
      expect(
        tester
            .widget<SelectionButton>(
              find.descendant(
                of: find.byType(ChoiceChip),
                matching: find.byType(SelectionButton),
              ),
            )
            .enabled,
        isFalse,
      );
    },
  );

  testWidgets(
    'TabController retargeting preserves the current position and settles',
    (WidgetTester tester) async {
      final TabController controller = TabController(length: 3, vsync: tester);
      addTearDown(controller.dispose);
      controller.animateTo(2);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 70));
      final double before = controller.animation.value;
      expect(before, greaterThan(0));
      expect(before, lessThan(2));
      controller.animateTo(1);
      expect(controller.animation.value, before);
      await tester.pumpAndSettle();
      expect(controller.animation.value, closeTo(1, 0.001));
      expect(controller.indexIsChanging, isFalse);
    },
  );

  testWidgets(
    'tab indicator and controller follow page drags and keyboard selects tabs',
    (WidgetTester tester) async {
      final TabController controller = TabController(length: 3, vsync: tester);
      addTearDown(controller.dispose);
      await pumpPure(
        tester,
        SizedBox(
          width: 300,
          height: 240,
          child: Column(
            children: <Widget>[
              TabBar(
                controller: controller,
                tabs: const <Widget>[
                  Tab(text: 'One'),
                  Tab(text: 'Two'),
                  Tab(text: 'Three'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: controller,
                  children: const <Widget>[
                    Text('Page1'),
                    Text('Page2'),
                    Text('Page3'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      await tester.pump();
      final TestGesture drag = await tester.startGesture(
        tester.getCenter(find.byType(TabBarView)),
      );
      await drag.moveBy(const Offset(-30, 0));
      await tester.pump();
      final double start = controller.animation.value;
      await drag.moveBy(const Offset(-60, 0));
      await tester.pump();
      expect(controller.animation.value - start, closeTo(0.2, 0.025));
      await drag.up();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Three'));
      await tester.pumpAndSettle();
      expect(controller.index, 2);
      expect(find.text('Page3'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(controller.index, 1);
    },
  );

  testWidgets('scrollable tab bar reveals the last tab', (
    WidgetTester tester,
  ) async {
    final TabController controller = TabController(length: 12, vsync: tester);
    addTearDown(controller.dispose);
    await pumpPure(
      tester,
      SizedBox(
        width: 220,
        child: TabBar(
          controller: controller,
          isScrollable: true,
          tabs: <Widget>[
            for (int i = 0; i < 12; i++)
              SizedBox(width: 90, child: Tab(text: 'Tab$i')),
          ],
        ),
      ),
    );
    controller.animateTo(11);
    await tester.pumpAndSettle();
    final Rect viewport = tester.getRect(find.byType(TabBar));
    expect(
      tester.getCenter(find.text('Tab11')).dx,
      inInclusiveRange(viewport.left, viewport.right),
    );
  });

  testWidgets('navigation bar selects via pointer and RTL keyboard', (
    WidgetTester tester,
  ) async {
    int selected = 0;
    await pumpPure(
      tester,
      SizedBox(
        width: 240,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) =>
              NavigationBar(
                selectedIndex: selected,
                onDestinationSelected: (int index) =>
                    setState(() => selected = index),
                destinations: const <Widget>[
                  NavigationDestination(
                    icon: SizedBox.square(dimension: 20),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: SizedBox.square(dimension: 20),
                    label: 'Settings',
                  ),
                ],
              ),
        ),
      ),
      textDirection: TextDirection.rtl,
    );
    await tester.pump();
    await tester.tap(find.text('Home'));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(selected, 1);
  });

  testWidgets('drawer heading does not count as a destination', (
    WidgetTester tester,
  ) async {
    int? selected;
    await pumpPure(
      tester,
      NavigationDrawer(
        onDestinationSelected: (int value) => selected = value,
        children: const <Widget>[
          Text('Heading'),
          NavigationDrawerDestination(
            icon: SizedBox.square(dimension: 20),
            label: Text('First'),
          ),
          Text('Separator'),
          NavigationDrawerDestination(
            icon: SizedBox.square(dimension: 20),
            label: Text('Second'),
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Second'));
    expect(selected, 1);
  });

  testWidgets('expansion tile controller preserves maintained children', (
    WidgetTester tester,
  ) async {
    final ExpansibleController controller = ExpansibleController();
    addTearDown(controller.dispose);
    final List<bool> changes = <bool>[];
    await pumpPure(
      tester,
      SizedBox(
        width: 240,
        child: ExpansionTile(
          controller: controller,
          title: const Text('Expand'),
          maintainState: true,
          onExpansionChanged: changes.add,
          children: const <Widget>[Text('Body')],
        ),
      ),
    );
    expect(find.text('Body'), findsNothing);
    await tester.tap(find.text('Expand'));
    await tester.pumpAndSettle();
    expect(find.text('Body'), findsOneWidget);
    controller.collapse();
    await tester.pumpAndSettle();
    expect(find.text('Body'), findsNothing);
    expect(find.text('Body', skipOffstage: false), findsOneWidget);
    expect(changes, <bool>[true, false]);
  });

  for (final TextDirection direction in TextDirection.values) {
    testWidgets(
      'range slider $direction tracks drags and thumbs do not cross',
      (WidgetTester tester) async {
        RangeValues values = const RangeValues(0.25, 0.75);
        await pumpPure(
          tester,
          SizedBox(
            width: 220,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  RangeSlider(
                    values: values,
                    style: _rangeStyle,
                    onChanged: (RangeValues next) =>
                        setState(() => values = next),
                  ),
            ),
          ),
          textDirection: direction,
        );
        final Rect rect = tester.getRect(find.byType(RangeSlider));
        final bool rtl = direction == TextDirection.rtl;
        final Offset start = Offset(
          rect.left + 10 + (rtl ? 0.75 : 0.25) * 200,
          rect.center.dy,
        );
        final TestGesture gesture = await tester.startGesture(start);
        await gesture.moveBy(Offset(rtl ? -30 : 30, 0));
        await tester.pump();
        final double before = values.start;
        await gesture.moveBy(Offset(rtl ? -20 : 20, 0));
        await tester.pump();
        expect(values.start - before, closeTo(0.1, 0.001));
        await gesture.moveBy(Offset(rtl ? -200 : 200, 0));
        await tester.pump();
        expect(values.start, values.end);
        await gesture.up();
        await tester.pump();
      },
    );
  }

  testWidgets('range slider independently focuses and adjusts each thumb', (
    WidgetTester tester,
  ) async {
    RangeValues values = const RangeValues(0.2, 0.8);
    final FocusNode start = FocusNode(), end = FocusNode();
    addTearDown(start.dispose);
    addTearDown(end.dispose);
    await pumpPure(
      tester,
      SizedBox(
        width: 220,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => RangeSlider(
            values: values,
            divisions: 10,
            style: _rangeStyle,
            startFocusNode: start,
            endFocusNode: end,
            onChanged: (RangeValues next) => setState(() => values = next),
          ),
        ),
      ),
    );
    start.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(values, const RangeValues(0.3, 0.8));
    end.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(values, const RangeValues(0.3, 0.7));
  });

  testWidgets(
    'discrete range thumb follows raw drag then springs to its division',
    (WidgetTester tester) async {
      RangeValues values = const RangeValues(0.2, 0.8);
      await pumpPure(
        tester,
        SizedBox(
          width: 220,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) =>
                RangeSlider(
                  values: values,
                  divisions: 10,
                  style: _rangeStyle,
                  onChanged: (RangeValues next) =>
                      setState(() => values = next),
                ),
          ),
        ),
      );
      final Rect rect = tester.getRect(find.byType(RangeSlider));
      final Finder thumb = find
          .byWidgetPredicate(
            (Widget widget) =>
                widget is AnimatedSurface && widget.constraints?.minWidth == 20,
          )
          .first;
      final TestGesture drag = await tester.startGesture(
        Offset(rect.left + 50, rect.center.dy),
      );
      await drag.moveBy(const Offset(28, 0));
      await tester.pump();
      expect(values.start, 0.3);
      expect(tester.getCenter(thumb).dx, closeTo(rect.left + 78, 0.01));
      await drag.up();
      await tester.pump();
      final double released = tester.getCenter(thumb).dx;
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.getCenter(thumb).dx, isNot(released));
      await tester.pumpAndSettle();
      expect(tester.getCenter(thumb).dx, closeTo(rect.left + 70, 0.1));
    },
  );

  testWidgets('Badge.count caps and paints using ambient tokens', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      const IconTheme(
        data: IconThemeData(color: Color(0xff123456)),
        child: Badge.count(count: 105, child: SizedBox.square(dimension: 32)),
      ),
    );
    expect(find.text('99+'), findsOneWidget);
    final Finder surface = find.descendant(
      of: find.byType(Badge),
      matching: find.byType(AnimatedSurface),
    );
    expect(
      tester.widget<AnimatedSurface>(surface).decoration,
      const BoxDecoration(color: Color(0xff123456)),
    );
  });

  testWidgets(
    'determinate progress animates through intermediate values and exposes semantics',
    (WidgetTester tester) async {
      double value = 0.2;
      late StateSetter update;
      await pumpPure(
        tester,
        SizedBox(
          width: 200,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              update = setState;
              return LinearProgressIndicator(
                value: value,
                semanticsLabel: 'Uploading',
              );
            },
          ),
        ),
      );
      final SemanticsHandle handle = tester.ensureSemantics();

      final Finder paint = find.descendant(
        of: find.byType(LinearProgressIndicator),
        matching: find.byType(CustomPaint),
      );
      final CustomPainter initial = tester.widget<CustomPaint>(paint).painter!;
      update(() => value = 0.8);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final CustomPainter midway = tester.widget<CustomPaint>(paint).painter!;
      expect(midway.shouldRepaint(initial), isTrue);
      expect(find.bySemanticsLabel('Uploading'), findsOneWidget);
      await tester.pumpAndSettle();
      handle.dispose();
    },
  );

  testWidgets('reduced motion pauses indeterminate progress and snaps tabs', (
    WidgetTester tester,
  ) async {
    final TabController controller = TabController(length: 2, vsync: tester);
    addTearDown(controller.dispose);
    await pumpPureApp(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TabBar(
            controller: controller,
            tabs: const <Widget>[
              Tab(text: 'First'),
              Tab(text: 'Second'),
            ],
          ),
          const CircularProgressIndicator(),
        ],
      ),
      disableAnimations: true,
    );
    controller.animateTo(1);
    expect(controller.animation.value, 1);
    expect(
      tester
          .widget<RepeatingAnimationBuilder<double>>(
            find.byType(RepeatingAnimationBuilder<double>),
          )
          .paused,
      isTrue,
    );
  });
}
