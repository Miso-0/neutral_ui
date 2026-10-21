import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

class _OwnFocus extends StatefulWidget {
  const _OwnFocus({super.key});

  @override
  State<_OwnFocus> createState() => _OwnFocusState();
}

class _OwnFocusState extends State<_OwnFocus> {
  final FocusNode node = FocusNode();

  @override
  void dispose() {
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Focus(focusNode: node, child: const Text('Anchor'));
}

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
  testWidgets('Escape closes an enclosing dialog when no tooltip is shown', (
    WidgetTester tester,
  ) async {
    late BuildContext launch;
    await pumpNeutralApp(
      tester,
      Builder(
        builder: (BuildContext context) {
          launch = context;
          return const Text('Launch');
        },
      ),
    );
    bool closed = false;
    showDialog<void>(
      context: launch,
      builder: (BuildContext context) => Dialog(
        child: Tooltip(
          message: 'Hint',
          child: TextButton(
            onPressed: () {},
            autofocus: true,
            child: const Text('Inside'),
          ),
        ),
      ),
    ).then((_) => closed = true);
    await tester.pumpAndSettle();
    expect(find.text('Hint'), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(closed, isTrue);
    expect(find.text('Hint'), findsNothing);
  });

  testWidgets('dismissing keeps a child that owns its focus mounted', (
    WidgetTester tester,
  ) async {
    final GlobalKey<TooltipState> tooltip = GlobalKey<TooltipState>();
    final GlobalKey<_OwnFocusState> child = GlobalKey<_OwnFocusState>();
    await pumpNeutralApp(
      tester,
      Tooltip(
        key: tooltip,
        message: 'Hint',
        child: _OwnFocus(key: child),
      ),
    );
    final _OwnFocusState state = child.currentState!;
    state.node.requestFocus();
    tooltip.currentState!.ensureTooltipVisible();
    await tester.pumpAndSettle();
    expect(find.text('Hint'), findsOneWidget);
    tooltip.currentState!.dismiss();
    await tester.pumpAndSettle();
    expect(find.text('Hint'), findsNothing);
    expect(identical(child.currentState, state), isTrue);
    expect(state.node.hasPrimaryFocus, isTrue);
  });

  testWidgets('a pointer press closes a tooltip opened by keyboard focus', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    await pumpNeutralApp(
      tester,
      Tooltip(
        message: 'Hint',
        child: Focus(focusNode: node, child: const Text('Anchor')),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(find.text('Hint'), findsOneWidget);
    await _mouseClick(tester, const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(node.hasPrimaryFocus, isTrue);
    expect(find.text('Hint'), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));

  testWidgets(
    'a tooltip dismissed under a resting pointer waits for it to leave',
    (WidgetTester tester) async {
      final GlobalKey<TooltipState> tooltip = GlobalKey<TooltipState>();
      await pumpNeutralApp(
        tester,
        Tooltip(key: tooltip, message: 'Hint', child: const Text('Anchor')),
      );
      final TestGesture mouse = await hover(tester, find.text('Anchor'));
      await tester.pumpAndSettle();
      expect(find.text('Hint'), findsOneWidget);
      tooltip.currentState!.dismiss();
      for (int frame = 0; frame < 5; frame++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.text('Hint'), findsNothing);
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      await mouse.moveTo(tester.getCenter(find.text('Anchor')));
      await tester.pumpAndSettle();
      expect(find.text('Hint'), findsOneWidget);
      await mouse.removePointer();
    },
  );
}
