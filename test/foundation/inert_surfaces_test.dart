import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

const Color _idle = Color(0xFFFFFFFF);
const Color _hovered = Color(0xFF087F6D);

StateProperty<Decoration?> get _decoration =>
    StateProperty<Decoration?>.resolveWith(
      (InteractionState state) =>
          BoxDecoration(color: state.isHovered ? _hovered : _idle),
    );

void main() {
  testWidgets('a list tile without an action shows no hover', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      SizedBox(
        width: 200,
        child: ListTile(
          style: ListTileStyle(decoration: _decoration),
          title: const Text('Info'),
        ),
      ),
    );
    final TestGesture mouse = await hover(tester, find.byType(ListTile));
    await tester.pumpAndSettle();
    expect(paintedColor(tester, find.byType(ListTile)), _idle);
    await mouse.removePointer();
  });

  testWidgets('a chip without callbacks is not interactive', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      Chip(
        label: const Text('Info'),
        style: ChipStyle(buttonStyle: ButtonStyle(decoration: _decoration)),
      ),
    );
    final TestGesture mouse = await hover(tester, find.byType(Chip));
    await tester.pumpAndSettle();
    expect(paintedColor(tester, find.byType(Chip)), _idle);
    final Focus focus = tester.widget<Focus>(
      find
          .descendant(of: find.byType(Chip), matching: find.byType(Focus))
          .first,
    );
    expect(focus.focusNode?.canRequestFocus, isFalse);
    await mouse.removePointer();
  });

  testWidgets('an inert surface does not take hover from its control', (
    WidgetTester tester,
  ) async {
    InteractionState outer = const InteractionState();
    await pumpNeutral(
      tester,
      InteractionDetector(
        onTap: () {},
        builder: (BuildContext context, InteractionState state) {
          outer = state;
          return const SizedBox(
            width: 200,
            child: ListTile(title: Text('Inside')),
          );
        },
      ),
    );
    final TestGesture mouse = await hover(tester, find.byType(ListTile));
    await tester.pumpAndSettle();
    expect(outer.isHovered, isTrue);
    await mouse.removePointer();
  });
}
