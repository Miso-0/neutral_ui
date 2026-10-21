import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/interaction_detector.dart'
    show InteractionBoundary;

import '../helpers/pump.dart';

const Key _outerKey = Key('outer');
const Key _innerKey = Key('inner');

/// A 200 by 100 detector with a 40 by 40 detector at its end.
Widget _nested({
  required List<InteractionState> outer,
  required List<InteractionState> inner,
  FocusNode? outerFocus,
  FocusNode? innerFocus,
  ValueChanged<bool>? outerHover,
  ValueChanged<bool>? outerFocusChange,
  bool boundary = false,
}) {
  final Widget child = InteractionDetector(
    key: _innerKey,
    focusNode: innerFocus,
    onTap: () {},
    builder: (BuildContext context, InteractionState state) {
      inner.add(state);
      return const SizedBox(width: 40, height: 40);
    },
  );
  return InteractionDetector(
    key: _outerKey,
    focusNode: outerFocus,
    onTap: () {},
    onHover: outerHover,
    onFocusChange: outerFocusChange,
    builder: (BuildContext context, InteractionState state) {
      outer.add(state);
      return SizedBox(
        width: 200,
        height: 100,
        child: Align(
          alignment: Alignment.centerRight,
          child: boundary ? InteractionBoundary(child: child) : child,
        ),
      );
    },
  );
}

Offset _outerSpot(WidgetTester tester) =>
    tester.getTopLeft(find.byKey(_outerKey)) + const Offset(20, 50);

void main() {
  testWidgets('only the innermost hovered control shows hover', (
    WidgetTester tester,
  ) async {
    final List<InteractionState> outer = <InteractionState>[];
    final List<InteractionState> inner = <InteractionState>[];
    final List<bool> outerHovers = <bool>[];
    await pumpNeutral(
      tester,
      _nested(outer: outer, inner: inner, outerHover: outerHovers.add),
    );
    final TestGesture mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(_outerSpot(tester));
    await tester.pump();
    expect(outer.last.isHovered, isTrue);

    await mouse.moveTo(tester.getCenter(find.byKey(_innerKey)));
    await tester.pump();
    expect(inner.last.isHovered, isTrue);
    expect(outer.last.isHovered, isFalse);
    // The callback still reports that the pointer is over the outer control.
    expect(outerHovers, <bool>[true]);

    await mouse.moveTo(_outerSpot(tester));
    await tester.pump();
    expect(inner.last.isHovered, isFalse);
    expect(outer.last.isHovered, isTrue);
    await mouse.removePointer();
  });

  testWidgets('pressing a nested control never shows the outer one pressed', (
    WidgetTester tester,
  ) async {
    final List<InteractionState> outer = <InteractionState>[];
    final List<InteractionState> inner = <InteractionState>[];
    await pumpNeutral(tester, _nested(outer: outer, inner: inner));
    final TestGesture press = await tester.startGesture(
      tester.getCenter(find.byKey(_innerKey)),
    );
    await tester.pump(kPressTimeout + const Duration(milliseconds: 50));
    expect(inner.last.isPressed, isTrue);
    await press.up();
    await tester.pump();
    await tester.pumpAndSettle();
    expect(inner.last.isPressed, isFalse);
    expect(
      outer.any((InteractionState state) => state.isPressed),
      isFalse,
      reason: 'no frame painted the outer control pressed',
    );

    // A press on the outer control alone still shows.
    await tester.startGesture(_outerSpot(tester));
    await tester.pump(kPressTimeout + const Duration(milliseconds: 50));
    expect(outer.last.isPressed, isTrue);
  });

  testWidgets('a focused descendant does not show focus on its ancestor', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    final FocusNode outerFocus = FocusNode();
    final FocusNode innerFocus = FocusNode();
    addTearDown(outerFocus.dispose);
    addTearDown(innerFocus.dispose);
    final List<InteractionState> outer = <InteractionState>[];
    final List<InteractionState> inner = <InteractionState>[];
    final List<bool> focusEvents = <bool>[];
    await pumpNeutral(
      tester,
      _nested(
        outer: outer,
        inner: inner,
        outerFocus: outerFocus,
        innerFocus: innerFocus,
        outerFocusChange: focusEvents.add,
      ),
    );
    outerFocus.requestFocus();
    await tester.pumpAndSettle();
    expect(outer.last.isFocused, isTrue);

    innerFocus.requestFocus();
    await tester.pumpAndSettle();
    expect(inner.last.isFocused, isTrue);
    expect(outer.last.isFocused, isFalse);
    // Raw focus still includes the descendant.
    expect(outerFocus.hasFocus, isTrue);
    expect(focusEvents.last, isTrue);

    outerFocus.requestFocus();
    await tester.pumpAndSettle();
    expect(outer.last.isFocused, isTrue);
    expect(inner.last.isFocused, isFalse);
  });

  testWidgets('a boundary separates nesting contexts', (
    WidgetTester tester,
  ) async {
    final List<InteractionState> outer = <InteractionState>[];
    final List<InteractionState> inner = <InteractionState>[];
    await pumpNeutral(
      tester,
      _nested(outer: outer, inner: inner, boundary: true),
    );
    final TestGesture mouse = await hover(tester, find.byKey(_innerKey));
    expect(inner.last.isHovered, isTrue);
    expect(outer.last.isHovered, isTrue);
    await mouse.removePointer();
  });

  testWidgets('a frozen boundary keeps the hover look when pointers stop', (
    WidgetTester tester,
  ) async {
    final List<InteractionState> states = <InteractionState>[];
    bool frozen = false;
    late StateSetter setFrozen;
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          setFrozen = setState;
          return InteractionBoundary(
            frozen: frozen,
            child: IgnorePointer(
              ignoring: frozen,
              child: InteractionDetector(
                onTap: () {},
                builder: (BuildContext context, InteractionState state) {
                  states.add(state);
                  return const SizedBox(width: 80, height: 40);
                },
              ),
            ),
          );
        },
      ),
    );
    final TestGesture mouse = await hover(
      tester,
      find.byType(InteractionDetector),
    );
    expect(states.last.isHovered, isTrue);
    setFrozen(() => frozen = true);
    await tester.pump();
    await tester.pump();
    expect(states.last.isHovered, isTrue);
    await mouse.removePointer();
  });
}
