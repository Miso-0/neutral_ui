import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

const Key _key = Key('decorated-button');
const BoxDecoration _background = BoxDecoration(color: Color(0xFF123456));
const BoxDecoration _foreground = BoxDecoration(
  border: Border.fromBorderSide(BorderSide(color: Color(0xFFABCDEF))),
);
const ButtonStyle _theme = ButtonStyle(
  decoration: StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xFF654321)),
  ),
  foregroundDecoration: StateProperty<Decoration?>.all(
    BoxDecoration(color: Color(0xFF765432)),
  ),
);

class _Options {
  const _Options({
    this.decoration,
    this.foregroundDecoration,
    this.style,
    this.focusNode,
    this.states,
    this.enabled = true,
  });
  final BoxDecoration? decoration;
  final BoxDecoration? foregroundDecoration;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final WidgetStatesController? states;
  final bool enabled;
}

class _Variant {
  const _Variant(this.name, this.create, this.wrap, this.global);
  final String name;
  final Widget Function(_Options) create;
  final Widget Function(Widget) wrap;
  final ThemeData global;
}

final List<_Variant> _variants = <_Variant>[
  _Variant(
    'ElevatedButton',
    (_Options o) => ElevatedButton(
      key: _key,
      onPressed: o.enabled ? () {} : null,
      decoration: o.decoration,
      foregroundDecoration: o.foregroundDecoration,
      style: o.style,
      focusNode: o.focusNode,
      statesController: o.states,
      child: const Text('Action'),
    ),
    (Widget child) => ElevatedButtonTheme(data: _theme, child: child),
    const ThemeData(elevatedButtonStyle: _theme),
  ),
  _Variant(
    'ElevatedButton.icon',
    (_Options o) => ElevatedButton.icon(
      key: _key,
      onPressed: o.enabled ? () {} : null,
      decoration: o.decoration,
      foregroundDecoration: o.foregroundDecoration,
      style: o.style,
      focusNode: o.focusNode,
      statesController: o.states,
      icon: const Text('+'),
      label: const Text('Action'),
    ),
    (Widget child) => ElevatedButtonTheme(data: _theme, child: child),
    const ThemeData(elevatedButtonStyle: _theme),
  ),
  _Variant(
    'OutlinedButton',
    (_Options o) => OutlinedButton(
      key: _key,
      onPressed: o.enabled ? () {} : null,
      decoration: o.decoration,
      foregroundDecoration: o.foregroundDecoration,
      style: o.style,
      focusNode: o.focusNode,
      statesController: o.states,
      child: const Text('Action'),
    ),
    (Widget child) => OutlinedButtonTheme(data: _theme, child: child),
    const ThemeData(outlinedButtonStyle: _theme),
  ),
  _Variant(
    'OutlinedButton.icon',
    (_Options o) => OutlinedButton.icon(
      key: _key,
      onPressed: o.enabled ? () {} : null,
      decoration: o.decoration,
      foregroundDecoration: o.foregroundDecoration,
      style: o.style,
      focusNode: o.focusNode,
      statesController: o.states,
      icon: const Text('+'),
      label: const Text('Action'),
    ),
    (Widget child) => OutlinedButtonTheme(data: _theme, child: child),
    const ThemeData(outlinedButtonStyle: _theme),
  ),
  _Variant(
    'TextButton',
    (_Options o) => TextButton(
      key: _key,
      onPressed: o.enabled ? () {} : null,
      decoration: o.decoration,
      foregroundDecoration: o.foregroundDecoration,
      style: o.style,
      focusNode: o.focusNode,
      statesController: o.states,
      child: const Text('Action'),
    ),
    (Widget child) => TextButtonTheme(data: _theme, child: child),
    const ThemeData(textButtonStyle: _theme),
  ),
  _Variant(
    'TextButton.icon',
    (_Options o) => TextButton.icon(
      key: _key,
      onPressed: o.enabled ? () {} : null,
      decoration: o.decoration,
      foregroundDecoration: o.foregroundDecoration,
      style: o.style,
      focusNode: o.focusNode,
      statesController: o.states,
      icon: const Text('+'),
      label: const Text('Action'),
    ),
    (Widget child) => TextButtonTheme(data: _theme, child: child),
    const ThemeData(textButtonStyle: _theme),
  ),
  _Variant(
    'IconButton',
    (_Options o) => IconButton(
      key: _key,
      onPressed: o.enabled ? () {} : null,
      decoration: o.decoration,
      foregroundDecoration: o.foregroundDecoration,
      style: o.style,
      focusNode: o.focusNode,
      statesController: o.states,
      icon: const Text('+'),
    ),
    (Widget child) => IconButtonTheme(data: _theme, child: child),
    const ThemeData(iconButtonStyle: _theme),
  ),
];

void main() {
  for (final _Variant variant in _variants) {
    testWidgets(
      '${variant.name} decorations override inherited styles in every state',
      (WidgetTester tester) async {
        useTraditionalFocus();
        final FocusNode focus = FocusNode();
        final WidgetStatesController states = WidgetStatesController();
        addTearDown(focus.dispose);
        addTearDown(states.dispose);
        void verify() {
          final AnimatedSurface container = tester.widget<AnimatedSurface>(
            find.descendant(
              of: find.byKey(_key),
              matching: find.byType(AnimatedSurface),
            ),
          );
          expect(container.decoration, _background);
          expect(container.foregroundDecoration, _foreground);
          expect(
            tester
                .widgetList<DecoratedBox>(
                  find.descendant(
                    of: find.byKey(_key),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .map((DecoratedBox box) => box.decoration),
            containsAll(<Decoration>[_background, _foreground]),
          );
        }

        _Options options({bool enabled = true}) => _Options(
          decoration: _background,
          foregroundDecoration: _foreground,
          focusNode: focus,
          states: states,
          enabled: enabled,
          style: const ButtonStyle(spacing: 3),
        );
        await pumpPure(
          tester,
          variant.create(options()),
          theme: variant.global,
        );
        verify();
        bool enabled = true;
        late StateSetter update;
        await pumpPure(
          tester,
          variant.wrap(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                update = setState;
                return variant.create(options(enabled: enabled));
              },
            ),
          ),
          theme: variant.global,
        );
        verify();
        final TestGesture mouse = await hover(tester, find.byKey(_key));
        expect(states.value, contains(WidgetState.hovered));
        verify();
        focus.requestFocus();
        await tester.pumpAndSettle();
        expect(states.value, contains(WidgetState.focused));
        verify();
        states.update(WidgetState.selected, true);
        await tester.pumpAndSettle();
        expect(states.value, contains(WidgetState.selected));
        verify();
        final TestGesture press = await tester.startGesture(
          tester.getCenter(find.byKey(_key)),
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
      testWidgets('${variant.name} rejects inline $token conflicts', (
        WidgetTester tester,
      ) async {
        await pumpPure(
          tester,
          variant.create(
            _Options(
              decoration: foreground ? null : _background,
              foregroundDecoration: foreground ? _foreground : null,
              style: ButtonStyle(
                decoration: foreground
                    ? null
                    : const StateProperty<Decoration?>.all(null),
                foregroundDecoration: foreground
                    ? const StateProperty<Decoration?>.all(null)
                    : null,
              ),
            ),
          ),
        );
        final Object? error = tester.takeException();
        expect(error, isA<FlutterError>());
        expect(error.toString(), contains(variant.name.split('.').first));
        expect(error.toString(), contains('`$token`'));
        expect(error.toString(), contains('`style.$token`'));
      });
    }
  }
}
