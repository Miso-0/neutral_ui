import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/foundation/decoration_override.dart';

void main() {
  const BoxDecoration decoration = BoxDecoration(color: Color(0xFF112233));
  test(
    'decorationLayer preserves absence and returns a constant state token',
    () {
      expect(decorationLayer(null), isNull);
      final StateProperty<Decoration?> layer = decorationLayer(decoration)!;
      for (final InteractionState state in <InteractionState>[
        const InteractionState(),
        const InteractionState(isPressed: true),
        const InteractionState(isHovered: true),
        const InteractionState(isFocused: true),
        const InteractionState(isSelected: true),
        const InteractionState(isDisabled: true),
      ]) {
        expect(layer.resolve(state), same(decoration));
      }
    },
  );
  test('validation allows either input alone and no inputs', () {
    for (final bool widgetInput in <bool>[false, true]) {
      for (final bool styleInput in <bool>[false, true]) {
        if (widgetInput && styleInput) continue;
        expect(
          debugCheckDecorationOverride(
            widget: 'Example',
            parameter: 'decoration',
            styleToken: 'style.decoration',
            value: widgetInput ? decoration : null,
            styleValue: styleInput
                ? const StateProperty<Decoration?>.all(decoration)
                : null,
          ),
          isTrue,
        );
      }
    }
  });
  test(
    'conflicts name the widget and both inputs even for a null resolver',
    () {
      expect(
        () => debugCheckDecorationOverride(
          widget: 'Example',
          parameter: 'decoration',
          styleToken: 'style.decoration',
          value: decoration,
          styleValue: const StateProperty<Decoration?>.all(null),
        ),
        throwsA(
          isA<FlutterError>().having(
            (FlutterError error) => error.toString(),
            'message',
            allOf(
              contains('Example'),
              contains('`decoration`'),
              contains('`style.decoration`'),
              contains('every interaction state'),
            ),
          ),
        ),
      );
    },
  );
}
