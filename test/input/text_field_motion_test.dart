import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

Color? _textColor(WidgetTester tester, String text) => tester
    .widgetList<RichText>(find.byType(RichText))
    .firstWhere((RichText rich) => rich.text.toPlainText() == text)
    .text
    .style
    ?.color;

void main() {
  testWidgets('the label color fades with focus', (WidgetTester tester) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    await pumpNeutral(
      tester,
      SizedBox(
        width: 240,
        child: TextField(
          focusNode: node,
          labelText: 'Name',
          style: TextFieldStyle(
            animationDuration: const Duration(milliseconds: 200),
            animationCurve: Curves.linear,
            labelStyle: StateProperty<TextStyle?>.resolveWith(
              (InteractionState state) => TextStyle(
                color: state.isFocused
                    ? const Color(0xFF000000)
                    : const Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
    expect(_textColor(tester, 'Name'), const Color(0xFFFFFFFF));
    node.requestFocus();
    // Focus applies after the first pump; the fade starts on the next frame.
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(_textColor(tester, 'Name')!.r, closeTo(0.5, 0.05));
    await tester.pumpAndSettle();
    expect(_textColor(tester, 'Name'), const Color(0xFF000000));
  });

  testWidgets('a validation message appearing keeps the field mounted', (
    WidgetTester tester,
  ) async {
    String? error;
    late StateSetter update;
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return SizedBox(
            width: 240,
            child: TextField(focusNode: node, errorText: error),
          );
        },
      ),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    final State surface = tester.state(find.byType(AnimatedSurface).first);
    update(() => error = 'Required');
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsOneWidget);
    expect(
      identical(tester.state(find.byType(AnimatedSurface).first), surface),
      isTrue,
    );
    expect(node.hasFocus, isTrue);
  });
}
