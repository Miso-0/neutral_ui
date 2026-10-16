import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

const SliderStyle _style = SliderStyle(
  thumbSize: StateProperty<Size?>.all(Size(20, 20)),
  thumbDecoration: StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xFF111111)),
  ),
  trackHeight: StateProperty<double?>.all(4),
  trackDecoration: StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xFF222222)),
  ),
  activeTrackDecoration: StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xFF333333)),
  ),
);

Offset _at(WidgetTester tester, double fraction) {
  final Rect rect = tester.getRect(find.byType(Slider));
  return Offset(rect.left + 10 + fraction * (rect.width - 20), rect.center.dy);
}

Widget _sized(Slider slider) => SizedBox(width: 200, child: slider);

void main() {
  testWidgets('tap jumps with ordered start, changed, end callbacks', (
    WidgetTester tester,
  ) async {
    final List<String> events = <String>[];
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 0.25,
          style: _style,
          onChanged: (double value) => events.add('change:$value'),
          onChangeStart: (double value) => events.add('start:$value'),
          onChangeEnd: (double value) => events.add('end:$value'),
        ),
      ),
    );
    await tester.tapAt(_at(tester, 0.75));
    expect(events, <String>['start:0.25', 'change:0.75', 'end:0.75']);
  });

  testWidgets('range offset, divisions and clamping use track geometry', (
    WidgetTester tester,
  ) async {
    final List<double> values = <double>[];
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 10,
          min: 10,
          max: 30,
          divisions: 4,
          style: _style,
          onChanged: values.add,
        ),
      ),
    );
    await tester.tapAt(_at(tester, 0.36));
    expect(values.last, 15);
    final TestGesture gesture = await tester.startGesture(_at(tester, 0.5));
    await tester.pump(const Duration(milliseconds: 150));
    await gesture.moveBy(const Offset(500, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(10, 0));
    await gesture.up();
    await tester.pump();
    expect(values.last, 30);
    expect(values.every((double value) => value >= 10 && value <= 30), isTrue);
  });

  testWidgets('directional padding and RTL mirror value positions', (
    WidgetTester tester,
  ) async {
    double? found;
    final SliderStyle style = _style.copyWith(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 10),
    );
    await pumpPure(
      tester,
      _sized(
        Slider(value: 0, style: style, onChanged: (double v) => found = v),
      ),
      textDirection: TextDirection.rtl,
    );
    final Rect rect = tester.getRect(find.byType(Slider));
    await tester.tapAt(Offset(rect.left + 20 + 150 * 0.25, rect.center.dy));
    expect(found, 0.75);
  });

  testWidgets(
    'winning drag preserves one interaction and deduplicates values',
    (WidgetTester tester) async {
      int starts = 0;
      int ends = 0;
      final List<double> values = <double>[];
      await pumpPure(
        tester,
        _sized(
          Slider(
            value: 0,
            style: _style,
            onChanged: values.add,
            onChangeStart: (double value) => starts += 1,
            onChangeEnd: (double value) => ends += 1,
          ),
        ),
      );
      final TestGesture gesture = await tester.startGesture(_at(tester, 0.25));
      await tester.pump(const Duration(milliseconds: 150));
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump();
      expect(ends, 0);
      await gesture.moveBy(const Offset(30, 0));
      await gesture.moveBy(Offset.zero);
      await gesture.up();
      await tester.pump();
      expect(starts, 1);
      expect(ends, 1);
      expect(values.toSet().length, values.length);
      expect(values.last, greaterThan(0.25));
    },
  );

  testWidgets('tapOnly accepts taps and ends canceled taps', (
    WidgetTester tester,
  ) async {
    int starts = 0;
    int ends = 0;
    final List<double> values = <double>[];
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 0,
          style: _style,
          allowedInteraction: SliderInteraction.tapOnly,
          onChanged: values.add,
          onChangeStart: (double value) => starts += 1,
          onChangeEnd: (double value) => ends += 1,
        ),
      ),
    );
    await tester.tapAt(_at(tester, 0.75));
    expect(values.last, 0.75);
    final TestGesture gesture = await tester.startGesture(_at(tester, 0.5));
    await tester.pump(const Duration(milliseconds: 150));
    await gesture.cancel();
    expect(starts, 2);
    expect(ends, 2);
  });

  testWidgets('slideOnly ignores taps and begins dragging without jumping', (
    WidgetTester tester,
  ) async {
    final List<double> values = <double>[];
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 0.25,
          style: _style,
          allowedInteraction: SliderInteraction.slideOnly,
          onChanged: values.add,
        ),
      ),
    );
    await tester.tapAt(_at(tester, 0.75));
    expect(values, isEmpty);
    final TestGesture gesture = await tester.startGesture(_at(tester, 0.75));
    await gesture.moveBy(const Offset(30, 0));
    await tester.pump();
    expect(values.last, closeTo(0.25 + 30 / 180, 0.001));
    await gesture.moveBy(const Offset(18, 0));
    await gesture.up();
    expect(values.last, closeTo(0.25 + 48 / 180, 0.001));
  });

  testWidgets('slideThumb requires a drag starting in the thumb target', (
    WidgetTester tester,
  ) async {
    final List<double> values = <double>[];
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 0.25,
          style: _style,
          allowedInteraction: SliderInteraction.slideThumb,
          onChanged: values.add,
        ),
      ),
    );
    TestGesture gesture = await tester.startGesture(_at(tester, 0.75));
    await gesture.moveBy(const Offset(30, 0));
    await gesture.moveBy(const Offset(20, 0));
    await gesture.up();
    expect(values, isEmpty);
    gesture = await tester.startGesture(_at(tester, 0.25));
    await gesture.moveBy(const Offset(30, 0));
    await gesture.moveBy(const Offset(18, 0));
    await gesture.up();
    expect(values.last, closeTo(0.25 + 48 / 180, 0.001));
  });

  testWidgets('widget interaction overrides inline and inherited styles', (
    WidgetTester tester,
  ) async {
    int changes = 0;
    await pumpPure(
      tester,
      SliderTheme(
        data: const SliderStyle(allowedInteraction: SliderInteraction.tapOnly),
        child: _sized(
          Slider(
            value: 0,
            allowedInteraction: SliderInteraction.slideOnly,
            style: _style.copyWith(
              allowedInteraction: SliderInteraction.tapOnly,
            ),
            onChanged: (double value) => changes += 1,
          ),
        ),
      ),
    );
    await tester.tapAt(_at(tester, 0.75));
    expect(changes, 0);
  });

  testWidgets('disabled and empty ranges do not request changes', (
    WidgetTester tester,
  ) async {
    int changes = 0;
    await pumpPure(
      tester,
      _sized(Slider(value: 0.5, style: _style, onChanged: null)),
    );
    await tester.tapAt(_at(tester, 0.75));
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 2,
          min: 2,
          max: 2,
          style: _style,
          onChanged: (double value) => changes += 1,
        ),
      ),
    );
    await tester.tapAt(_at(tester, 0.75));
    expect(changes, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'unbounded width uses preferredWidth and compact height defaults',
    (WidgetTester tester) async {
      await pumpPure(
        tester,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[Slider(value: 0, onChanged: (double value) {})],
        ),
      );
      expect(tester.getSize(find.byType(Slider)), const Size(144, 48));
      await pumpPure(
        tester,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Slider(
              value: 0,
              onChanged: (double value) {},
              style: const SliderStyle(
                preferredWidth: 212,
                tapTargetSize: Size(4, 12),
              ),
            ),
          ],
        ),
      );
      expect(tester.getSize(find.byType(Slider)), const Size(212, 12));
    },
  );

  testWidgets('parent height constraints keep visual geometry centered', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      SizedBox(
        width: 200,
        height: 100,
        child: Slider(value: 0.5, style: _style, onChanged: (double value) {}),
      ),
    );
    expect(tester.getSize(find.byType(Slider)), const Size(200, 100));
    final Stack stack = tester.widget<Stack>(
      find.descendant(of: find.byType(Slider), matching: find.byType(Stack)),
    );
    expect((stack.children.first as Positioned).top, 48);
    expect((stack.children.last as Positioned).top, 50);
  });

  testWidgets('unbounded preferred width respects parent minimum width', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 220),
            child: Slider(
              value: 0.5,
              style: _style,
              onChanged: (double value) {},
            ),
          ),
        ],
      ),
    );
    expect(tester.getSize(find.byType(Slider)), const Size(220, 48));
    final Stack stack = tester.widget<Stack>(
      find.descendant(of: find.byType(Slider), matching: find.byType(Stack)),
    );
    expect((stack.children.last as Positioned).left, 110);
  });

  testWidgets('per-state inline null falls through to nearest SliderTheme', (
    WidgetTester tester,
  ) async {
    final SliderStyle inline = SliderStyle(
      thumbSize: StateProperty<Size?>.resolveWith(
        (InteractionState state) => state.isPressed ? const Size(30, 30) : null,
      ),
    );
    await pumpPure(
      tester,
      SliderTheme(
        data: const SliderStyle(
          thumbSize: StateProperty<Size?>.all(Size(20, 20)),
        ),
        child: _sized(
          Slider(value: 0, style: inline, onChanged: (double v) {}),
        ),
      ),
      theme: const ThemeData(
        sliderStyle: SliderStyle(
          thumbSize: StateProperty<Size?>.all(Size(10, 10)),
        ),
      ),
    );
    AnimatedSurface thumb = tester
        .widgetList<AnimatedSurface>(find.byType(AnimatedSurface))
        .last;
    expect(thumb.constraints!.maxWidth, 20);
    final TestGesture gesture = await tester.startGesture(_at(tester, 0.5));
    await tester.pump(const Duration(milliseconds: 150));
    thumb = tester
        .widgetList<AnimatedSurface>(find.byType(AnimatedSurface))
        .last;
    expect(thumb.constraints!.maxWidth, 30);
    await gesture.up();
  });

  testWidgets('SliderTheme.merge inherits global tokens', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      SliderTheme.merge(
        data: const SliderStyle(tapTargetSize: Size(48, 64)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[Slider(value: 0, onChanged: (double value) {})],
        ),
      ),
      theme: const ThemeData(sliderStyle: SliderStyle(preferredWidth: 210)),
    );
    expect(tester.getSize(find.byType(Slider)), const Size(210, 64));
  });

  testWidgets('arrow keys use inline step and mirror horizontal RTL', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    final List<double> values = <double>[];
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 0.5,
          focusNode: node,
          style: _style.copyWith(keyboardStep: 0.2),
          onChanged: values.add,
        ),
      ),
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    expect(values, <double>[0.7, 0.7, 0.3]);
    values.clear();
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 0.5,
          focusNode: node,
          style: _style,
          onChanged: values.add,
        ),
      ),
      textDirection: TextDirection.rtl,
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    expect(values, <double>[0.45, 0.55]);
  });

  testWidgets('discrete keyboard step uses divisions and ordered callbacks', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    final List<String> events = <String>[];
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 10,
          min: 10,
          max: 30,
          divisions: 4,
          focusNode: node,
          style: _style.copyWith(keyboardStep: 0.1),
          onChanged: (double v) => events.add('change:$v'),
          onChangeStart: (double v) => events.add('start:$v'),
          onChangeEnd: (double v) => events.add('end:$v'),
        ),
      ),
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    expect(events, <String>['start:10.0', 'change:15.0', 'end:15.0']);
  });

  testWidgets('semantics formats values and exposes increase and decrease', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    final List<double> values = <double>[];
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 15,
          min: 10,
          max: 30,
          divisions: 4,
          label: 'Volume',
          semanticFormatterCallback: (double value) => '$value units',
          style: _style,
          onChanged: values.add,
        ),
      ),
    );
    final SemanticsNode node = tester.getSemantics(find.byType(Slider));
    final SemanticsData data = node.getSemanticsData();
    expect(data.label, 'Volume');
    expect(data.value, '15.0 units');
    expect(data.increasedValue, '20.0 units');
    expect(data.decreasedValue, '10.0 units');
    expect(data.hasAction(SemanticsAction.increase), isTrue);
    expect(data.hasAction(SemanticsAction.decrease), isTrue);
    node.owner!.performAction(node.id, SemanticsAction.increase);
    node.owner!.performAction(node.id, SemanticsAction.decrease);
    expect(values, <double>[20, 10]);
    handle.dispose();
  });

  testWidgets('secondary track and tick activity match the controlled value', (
    WidgetTester tester,
  ) async {
    const BoxDecoration active = BoxDecoration(color: Color(0xFF444444));
    const BoxDecoration inactive = BoxDecoration(color: Color(0xFF555555));
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 0.5,
          secondaryTrackValue: 0.75,
          divisions: 4,
          onChanged: (double value) {},
          style: _style.copyWith(
            tickMarkSize: const StateProperty<Size?>.all(Size(2, 2)),
            tickMarkDecoration: const StateProperty<Decoration?>.all(inactive),
            activeTickMarkDecoration: const StateProperty<Decoration?>.all(
              active,
            ),
          ),
        ),
      ),
    );
    final Stack stack = tester.widget<Stack>(
      find.descendant(of: find.byType(Slider), matching: find.byType(Stack)),
    );
    expect(stack.children.length, 9);
    expect((stack.children[1] as Positioned).width, 135);
    expect((stack.children[2] as Positioned).width, 90);
    final List<AnimatedSurface> containers = tester
        .widgetList<AnimatedSurface>(find.byType(AnimatedSurface))
        .toList();
    expect(
      containers.where((AnimatedSurface c) => c.decoration == active).length,
      3,
    );
    expect(
      containers.where((AnimatedSurface c) => c.decoration == inactive).length,
      2,
    );
  });

  testWidgets(
    'value indicator receives current state, actual value and label',
    (WidgetTester tester) async {
      InteractionState? state;
      double? value;
      String? label;
      await pumpPure(
        tester,
        _sized(
          Slider(
            value: 12,
            min: 10,
            max: 20,
            label: 'Gain',
            onChanged: null,
            style: _style.copyWith(
              valueIndicatorBuilder:
                  (
                    BuildContext context,
                    InteractionState interaction,
                    double current,
                    String? currentLabel,
                  ) {
                    state = interaction;
                    value = current;
                    label = currentLabel;
                    return const Text('indicator');
                  },
            ),
          ),
        ),
      );
      expect(state!.isDisabled, isTrue);
      expect(value, 12);
      expect(label, 'Gain');
      expect(find.text('indicator'), findsOneWidget);
    },
  );

  testWidgets('disabling mid-gesture safely ends and permits parent setState', (
    WidgetTester tester,
  ) async {
    late StateSetter update;
    bool enabled = true;
    int ends = 0;
    await pumpPure(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return _sized(
            Slider(
              value: 0,
              style: _style,
              onChanged: enabled ? (double value) {} : null,
              onChangeEnd: (double value) => setState(() => ends += 1),
            ),
          );
        },
      ),
    );
    final TestGesture gesture = await tester.startGesture(_at(tester, 0.25));
    await tester.pump(const Duration(milliseconds: 150));
    update(() => enabled = false);
    await tester.pump();
    await tester.pump();
    expect(ends, 1);
    expect(tester.takeException(), isNull);
    await gesture.up();
    await tester.pump();
    expect(ends, 1);
  });

  for (final String source in <String>[
    'widget',
    'inline',
    'component',
    'global',
  ]) {
    testWidgets(
      'changing $source interaction mode safely ends an active gesture',
      (WidgetTester tester) async {
        late StateSetter update;
        SliderInteraction interaction = SliderInteraction.tapOnly;
        int starts = 0;
        int ends = 0;
        void onStart(double value) => starts += 1;
        void onEnd(double value) => update(() => ends += 1);
        final Widget fixedSlider = _sized(
          Slider(
            value: 0.5,
            style: _style,
            onChanged: (double value) {},
            onChangeStart: onStart,
            onChangeEnd: onEnd,
          ),
        );
        await pumpPure(
          tester,
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              update = setState;
              if (source == 'component') {
                return SliderTheme(
                  data: SliderStyle(allowedInteraction: interaction),
                  child: fixedSlider,
                );
              }
              if (source == 'global') {
                return PureTheme(
                  data: ThemeData(
                    sliderStyle: SliderStyle(allowedInteraction: interaction),
                  ),
                  child: fixedSlider,
                );
              }
              return _sized(
                Slider(
                  value: 0.5,
                  allowedInteraction: source == 'widget' ? interaction : null,
                  style: source == 'inline'
                      ? _style.copyWith(allowedInteraction: interaction)
                      : _style,
                  onChanged: (double value) {},
                  onChangeStart: onStart,
                  onChangeEnd: onEnd,
                ),
              );
            },
          ),
        );
        final TestGesture oldGesture = await tester.startGesture(
          _at(tester, 0.5),
        );
        await tester.pump(const Duration(milliseconds: 150));
        expect(starts, 1);
        expect(ends, 0);
        update(() => interaction = SliderInteraction.slideOnly);
        await tester.pump();
        await tester.pump();
        expect(ends, 1);
        expect(tester.takeException(), isNull);
        await oldGesture.up();
        final TestGesture newGesture = await tester.startGesture(
          _at(tester, 0.5),
        );
        await newGesture.moveBy(const Offset(30, 0));
        await newGesture.up();
        await tester.pump();
        expect(starts, 2);
        expect(ends, 2);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final bool upward in <bool>[true, false]) {
    testWidgets(
      'directional navigation moves focus ${upward ? 'up' : 'down'}',
      (WidgetTester tester) async {
        final FocusNode slider = FocusNode();
        final FocusNode above = FocusNode();
        final FocusNode below = FocusNode();
        addTearDown(slider.dispose);
        addTearDown(above.dispose);
        addTearDown(below.dispose);
        final List<double> values = <double>[];
        await pumpPure(
          tester,
          MediaQuery(
            data: const MediaQueryData(
              navigationMode: NavigationMode.directional,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Focus(
                  focusNode: above,
                  child: const SizedBox(width: 40, height: 40),
                ),
                _sized(
                  Slider(value: 0.5, focusNode: slider, onChanged: values.add),
                ),
                Focus(
                  focusNode: below,
                  child: const SizedBox(width: 40, height: 40),
                ),
              ],
            ),
          ),
        );
        slider.requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(
          upward ? LogicalKeyboardKey.arrowUp : LogicalKeyboardKey.arrowDown,
        );
        await tester.pump();
        expect((upward ? above : below).hasFocus, isTrue);
        expect(values, isEmpty);
      },
    );
  }

  testWidgets('ScrollIntent actions support web arrow shortcuts', (
    WidgetTester tester,
  ) async {
    final List<double> values = <double>[];
    await pumpPure(tester, _sized(Slider(value: 0.5, onChanged: values.add)));
    final BuildContext actionContext = tester.element(
      find.descendant(
        of: find.byType(Slider),
        matching: find.byType(LayoutBuilder),
      ),
    );
    Actions.invoke<ScrollIntent>(
      actionContext,
      const ScrollIntent(direction: AxisDirection.right),
    );
    Actions.invoke<ScrollIntent>(
      actionContext,
      const ScrollIntent(direction: AxisDirection.down),
    );
    expect(values, <double>[0.55, 0.45]);
  });

  testWidgets('controlled updates immediately move the thumb in RTL', (
    WidgetTester tester,
  ) async {
    double value = 0.5;
    await pumpPure(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _sized(
            Slider(
              value: value,
              style: _style,
              allowedInteraction: SliderInteraction.slideOnly,
              onChanged: (double requested) =>
                  setState(() => value = requested),
            ),
          );
        },
      ),
      textDirection: TextDirection.rtl,
    );
    final TestGesture gesture = await tester.startGesture(_at(tester, 0.5));
    await gesture.moveBy(const Offset(36, 0));
    await tester.pump();
    expect(value, closeTo(0.3, 0.001));
    await gesture.moveBy(const Offset(18, 0));
    await tester.pump();
    expect(value, closeTo(0.2, 0.001));
    final Stack stack = tester.widget<Stack>(
      find.descendant(of: find.byType(Slider), matching: find.byType(Stack)),
    );
    expect((stack.children.last as Positioned).left, closeTo(154, 0.001));
    await gesture.up();
  });

  testWidgets(
    'default semantics use percentages and disabled values omit actions',
    (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await pumpPure(
        tester,
        _sized(const Slider(value: 15, min: 10, max: 30, onChanged: null)),
      );
      final SemanticsData data = tester
          .getSemantics(find.byType(Slider))
          .getSemanticsData();
      expect(data.value, '25%');
      expect(data.hasAction(SemanticsAction.increase), isFalse);
      expect(data.hasAction(SemanticsAction.decrease), isFalse);
      handle.dispose();
    },
  );

  testWidgets('canceled and disposed interactions do not call after disposal', (
    WidgetTester tester,
  ) async {
    int ends = 0;
    await pumpPure(
      tester,
      _sized(
        Slider(
          value: 0,
          style: _style,
          onChanged: (double v) {},
          onChangeEnd: (double v) => ends += 1,
        ),
      ),
    );
    final TestGesture gesture = await tester.startGesture(_at(tester, 0.5));
    await tester.pump(const Duration(milliseconds: 150));
    await gesture.cancel();
    final int endedBeforeDisposal = ends;
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(ends, endedBeforeDisposal);
    expect(tester.takeException(), isNull);
  });
}
