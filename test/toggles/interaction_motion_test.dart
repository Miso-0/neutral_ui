import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

const Color _pressed = Color(0xFF000000);
const Color _idle = Color(0xFFFFFFFF);

void main() {
  testWidgets('a press released as selection starts still fades', (
    WidgetTester tester,
  ) async {
    bool value = false;
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Checkbox(
          value: value,
          onChanged: (bool? next) => setState(() => value = next!),
          style: ToggleStyle(
            animationDuration: const Duration(milliseconds: 200),
            animationCurve: Curves.linear,
            decoration: StateProperty<Decoration?>.resolveWith(
              (InteractionState state) =>
                  BoxDecoration(color: state.isPressed ? _pressed : _idle),
            ),
          ),
        ),
      ),
    );
    final Finder checkbox = find.byType(Checkbox);
    final TestGesture press = await tester.startGesture(
      tester.getCenter(checkbox),
    );
    await tester.pump(kPressTimeout);
    await tester.pumpAndSettle();
    expect(paintedColor(tester, checkbox), _pressed);

    await press.up();
    await tester.pump();
    expect(value, isTrue);
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      brightnessOverWhite(paintedColor(tester, checkbox)),
      inExclusiveRange(0.2, 0.8),
      reason: 'the release fades while the selection animates',
    );
    await tester.pumpAndSettle();
    expect(paintedColor(tester, checkbox), _idle);
  });
}
