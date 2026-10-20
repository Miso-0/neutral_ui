import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

const ToggleStyle _dragStyle = ToggleStyle(
  size: StateProperty<Size?>.all(Size(80.0, 24.0)),
  thumbSize: StateProperty<Size?>.all(Size(20.0, 20.0)),
  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
);

AlignmentGeometry _thumbAlignment(WidgetTester tester) {
  final Finder track = find.byType(AnimatedSurface).first;
  return tester
      .widget<Align>(
        find.descendant(of: track, matching: find.byType(Align)).first,
      )
      .alignment;
}

Future<TestGesture> _startDrag(WidgetTester tester, double direction) async {
  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.byType(Switch)),
  );
  await gesture.moveBy(Offset(20.0 * direction, 0.0));
  await tester.pump();
  return gesture;
}

void main() {
  testWidgets('switch requests the opposite value when tapped', (
    WidgetTester tester,
  ) async {
    bool? requested;
    await pumpNeutral(
      tester,
      Switch(value: false, onChanged: (bool next) => requested = next),
    );
    await tester.tap(find.byType(Switch));
    expect(requested, isTrue);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
  });

  testWidgets('switch track size falls back to thumb plus travel and padding', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      const Switch(
        value: false,
        onChanged: null,
        style: ToggleStyle(
          thumbSize: StateProperty<Size?>.all(Size(18.0, 14.0)),
          padding: EdgeInsets.fromLTRB(3.0, 2.0, 5.0, 4.0),
        ),
      ),
    );
    expect(tester.getSize(find.byType(Switch)), const Size(48.0, 48.0));
    expect(
      tester.getSize(find.byType(AnimatedSurface).first),
      const Size(44.0, 20.0),
    );
  });

  testWidgets(
    'drag past halfway requests selection and settles at the new value',
    (WidgetTester tester) async {
      bool value = false;
      final List<bool> changes = <bool>[];
      await pumpNeutral(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Switch(
            value: value,
            onChanged: (bool next) {
              changes.add(next);
              setState(() => value = next);
            },
            style: _dragStyle,
          ),
        ),
      );
      final TestGesture gesture = await _startDrag(tester, 1.0);
      await gesture.moveBy(const Offset(36.0, 0.0));
      await tester.pump();
      expect(
        _thumbAlignment(tester),
        const AlignmentDirectional(36.0 / 26.0 - 1.0, 0.0),
      );
      await gesture.up();
      await tester.pumpAndSettle();
      expect(changes, <bool>[true]);
      expect(_thumbAlignment(tester), AlignmentDirectional.centerEnd);
    },
  );

  testWidgets('a short drag reverts without requesting a selection change', (
    WidgetTester tester,
  ) async {
    int calls = 0;
    await pumpNeutral(
      tester,
      Switch(
        value: false,
        onChanged: (bool next) => calls += 1,
        style: _dragStyle,
      ),
    );
    final TestGesture gesture = await _startDrag(tester, 1.0);
    await gesture.moveBy(const Offset(8.0, 0.0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(_thumbAlignment(tester), AlignmentDirectional.centerStart);
  });

  testWidgets('RTL drags toward the left to select', (
    WidgetTester tester,
  ) async {
    bool value = false;
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Switch(
          value: value,
          onChanged: (bool next) => setState(() => value = next),
          style: _dragStyle,
        ),
      ),
      textDirection: TextDirection.rtl,
    );
    final TestGesture gesture = await _startDrag(tester, -1.0);
    await gesture.moveBy(const Offset(-36.0, 0.0));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(value, isTrue);
    final Finder thumb = find.byType(AnimatedSurface).last;
    final Finder track = find.byType(AnimatedSurface).first;
    expect(tester.getTopLeft(thumb).dx, tester.getTopLeft(track).dx + 4.0);
  });

  testWidgets('cancelled drag returns to the controlled value', (
    WidgetTester tester,
  ) async {
    int calls = 0;
    await pumpNeutral(
      tester,
      Switch(
        value: false,
        onChanged: (bool next) => calls += 1,
        style: _dragStyle,
      ),
    );
    final TestGesture gesture = await _startDrag(tester, 1.0);
    await gesture.moveBy(const Offset(40.0, 0.0));
    await tester.pump();
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(_thumbAlignment(tester), AlignmentDirectional.centerStart);
  });

  testWidgets('switch without travel ignores drag updates', (
    WidgetTester tester,
  ) async {
    int calls = 0;
    await pumpNeutral(
      tester,
      Switch(value: false, onChanged: (bool next) => calls += 1),
    );
    final TestGesture gesture = await _startDrag(tester, 1.0);
    await gesture.moveBy(const Offset(50.0, 0.0));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('drag remains linear after reaching an endpoint and reversing', (
    WidgetTester tester,
  ) async {
    int calls = 0;
    await pumpNeutral(
      tester,
      Switch(
        value: false,
        onChanged: (bool next) => calls += 1,
        style: _dragStyle,
      ),
    );
    final TestGesture gesture = await _startDrag(tester, 1.0);
    await gesture.moveBy(const Offset(100.0, 0.0));
    await tester.pump();
    await gesture.moveBy(const Offset(-39.0, 0.0));
    await tester.pump();
    expect(_thumbAlignment(tester), const AlignmentDirectional(-0.5, 0.0));
    await gesture.up();
    await tester.pump();
    expect(_thumbAlignment(tester), const AlignmentDirectional(-0.5, 0.0));
    await tester.pumpAndSettle();
    expect(calls, 0);
    expect(_thumbAlignment(tester), AlignmentDirectional.centerStart);
  });

  testWidgets(
    'disabling a switch during a drag restores its controlled value',
    (WidgetTester tester) async {
      bool enabled = true;
      int calls = 0;
      late StateSetter update;
      await pumpNeutral(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            update = setState;
            return Switch(
              value: false,
              onChanged: enabled ? (bool next) => calls += 1 : null,
              style: _dragStyle,
            );
          },
        ),
      );
      final TestGesture gesture = await _startDrag(tester, 1.0);
      await gesture.moveBy(const Offset(40.0, 0.0));
      await tester.pump();
      update(() => enabled = false);
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(_thumbAlignment(tester), AlignmentDirectional.centerStart);
    },
  );

  testWidgets('disabled switch exposes its value and excludes drag semantics', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await pumpNeutral(
      tester,
      const Switch(value: true, onChanged: null, semanticLabel: 'Power'),
    );
    expect(
      tester.getSemantics(find.byType(Switch)),
      isSemantics(
        label: 'Power',
        hasToggledState: true,
        isToggled: true,
        isEnabled: false,
        hasTapAction: false,
        hasScrollLeftAction: false,
        hasScrollRightAction: false,
      ),
    );
    semantics.dispose();
  });

  testWidgets('enabled switch semantics expose only a toggle tap', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await pumpNeutral(tester, Switch(value: false, onChanged: (bool next) {}));
    expect(
      tester.getSemantics(find.byType(Switch)),
      isSemantics(
        hasToggledState: true,
        isToggled: false,
        isEnabled: true,
        hasTapAction: true,
        hasScrollLeftAction: false,
        hasScrollRightAction: false,
      ),
    );
    semantics.dispose();
  });
}
