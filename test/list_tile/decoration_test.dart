import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

import '../helpers/pump.dart';

const BoxDecoration _background = BoxDecoration(color: Color(0xFF123456));
const BoxDecoration _foreground = BoxDecoration(
  border: Border.fromBorderSide(BorderSide(color: Color(0xFFABCDEF))),
);
const ListTileStyle _theme = ListTileStyle(
  decoration: StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xFF654321)),
  ),
  foregroundDecoration: StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xFF765432)),
  ),
);

void main() {
  testWidgets(
    'tile decorations override theme tokens in every interaction state',
    (WidgetTester tester) async {
      useTraditionalFocus();
      final FocusNode focus = FocusNode();
      final WidgetStatesController states = WidgetStatesController();
      addTearDown(focus.dispose);
      addTearDown(states.dispose);
      void verify() {
        final AnimatedContainer container = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );
        expect(container.decoration, _background);
        expect(container.foregroundDecoration, _foreground);
        expect(
          tester
              .widgetList<DecoratedBox>(find.byType(DecoratedBox))
              .map((DecoratedBox box) => box.decoration),
          containsAll(<Decoration>[_background, _foreground]),
        );
      }

      await pumpPure(
        tester,
        const ListTile(
          title: Text('Tile'),
          decoration: _background,
          foregroundDecoration: _foreground,
        ),
        theme: const ThemeData(listTileStyle: _theme),
      );
      verify();
      bool selected = false;
      bool enabled = true;
      late StateSetter update;
      await pumpPure(
        tester,
        ListTileTheme(
          data: _theme,
          child: SizedBox(
            width: 240,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                update = setState;
                return ListTile(
                  title: const Text('Tile'),
                  decoration: _background,
                  foregroundDecoration: _foreground,
                  selected: selected,
                  enabled: enabled,
                  focusNode: focus,
                  statesController: states,
                  onTap: () {},
                  style: const ListTileStyle(contentPadding: EdgeInsets.all(8)),
                );
              },
            ),
          ),
        ),
        theme: const ThemeData(listTileStyle: _theme),
      );
      verify();
      final TestGesture mouse = await hover(tester, find.byType(ListTile));
      expect(states.value, contains(WidgetState.hovered));
      verify();
      focus.requestFocus();
      await tester.pumpAndSettle();
      expect(states.value, contains(WidgetState.focused));
      verify();
      update(() => selected = true);
      await tester.pumpAndSettle();
      expect(states.value, contains(WidgetState.selected));
      verify();
      final TestGesture press = await tester.startGesture(
        tester.getCenter(find.byType(ListTile)),
      );
      await tester.pump(kPressTimeout);
      expect(states.value, contains(WidgetState.pressed));
      verify();
      await press.cancel();
      update(() => enabled = false);
      await tester.pumpAndSettle();
      expect(states.value, contains(WidgetState.disabled));
      verify();
      expect(tester.takeException(), isNull);
      await mouse.removePointer();
    },
  );

  for (final bool foreground in <bool>[false, true]) {
    final String token = foreground ? 'foregroundDecoration' : 'decoration';
    testWidgets('ListTile rejects inline $token conflicts', (
      WidgetTester tester,
    ) async {
      await pumpPure(
        tester,
        ListTile(
          title: const Text('Tile'),
          decoration: foreground ? null : _background,
          foregroundDecoration: foreground ? _foreground : null,
          style: ListTileStyle(
            decoration: foreground
                ? null
                : const StateProperty<Decoration?>.all(null),
            foregroundDecoration: foreground
                ? const StateProperty<Decoration?>.all(null)
                : null,
          ),
        ),
      );
      final Object? error = tester.takeException();
      expect(error, isA<FlutterError>());
      expect(error.toString(), contains('ListTile'));
      expect(error.toString(), contains('`$token`'));
      expect(error.toString(), contains('`style.$token`'));
    });
  }
}
