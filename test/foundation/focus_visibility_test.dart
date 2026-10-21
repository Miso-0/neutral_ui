import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

Future<void> _mouseClick(WidgetTester tester, Offset location) async {
  final TestGesture mouse = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await mouse.addPointer(location: location);
  await mouse.down(location);
  await mouse.up();
  await mouse.removePointer();
  await tester.pump();
}

void main() {
  // Desktop platforms start in traditional highlight mode, which Flutter keeps
  // through mouse input.
  testWidgets('focus moved after a pointer press shows no ring until a key', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    InteractionState state = const InteractionState();
    await pumpNeutral(
      tester,
      InteractionDetector(
        focusNode: node,
        onTap: () {},
        builder: (BuildContext context, InteractionState current) {
          state = current;
          return const SizedBox(width: 100, height: 100);
        },
      ),
    );
    // Click away from the control, as when a mouse opens a menu.
    await _mouseClick(tester, const Offset(5, 5));
    expect(FocusManager.instance.highlightMode, FocusHighlightMode.traditional);
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(node.hasPrimaryFocus, isTrue);
    expect(state.isFocused, isFalse);

    // Modifier keys alone do not reveal focus; other keys do.
    await tester.sendKeyEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    expect(state.isFocused, isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();
    expect(state.isFocused, isTrue);

    // Another pointer press hides it again while focus stays.
    await _mouseClick(tester, const Offset(5, 5));
    expect(node.hasPrimaryFocus, isTrue);
    expect(state.isFocused, isFalse);
  }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));

  testWidgets('alwaysTraditional keeps focus visible after pointer input', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    InteractionState state = const InteractionState();
    await pumpNeutral(
      tester,
      InteractionDetector(
        focusNode: node,
        onTap: () {},
        builder: (BuildContext context, InteractionState current) {
          state = current;
          return const SizedBox(width: 100, height: 100);
        },
      ),
    );
    await _mouseClick(tester, const Offset(5, 5));
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(state.isFocused, isTrue);
  });

  testWidgets('unfocused controls do not rebuild when input modality changes', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    int unfocusedBuilds = 0;
    await pumpNeutral(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InteractionDetector(
            focusNode: node,
            onTap: () {},
            builder: (BuildContext context, InteractionState state) =>
                const SizedBox(width: 100, height: 40),
          ),
          InteractionDetector(
            onTap: () {},
            builder: (BuildContext context, InteractionState state) {
              unfocusedBuilds++;
              return const SizedBox(width: 100, height: 40);
            },
          ),
        ],
      ),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    final int before = unfocusedBuilds;
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();
    await _mouseClick(tester, const Offset(5, 5));
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();
    expect(unfocusedBuilds, before);
  });
}
