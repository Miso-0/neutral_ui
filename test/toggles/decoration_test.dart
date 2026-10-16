import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

const Key _controlKey = ValueKey<String>('decorated-toggle');
const BoxDecoration _box = BoxDecoration(
  color: Color(0xFF2468AC),
  border: Border.fromBorderSide(BorderSide(color: Color(0xFF123456), width: 2)),
  borderRadius: BorderRadius.all(Radius.circular(5)),
);
const BoxDecoration _thumb = BoxDecoration(
  color: Color(0xFFAC6824),
  shape: BoxShape.circle,
);

typedef _ControlBuilder = Widget Function({
  required bool? value,
  required bool enabled,
  FocusNode? focusNode,
  ToggleStyle? style,
  BoxDecoration? decoration,
  BoxDecoration? thumbDecoration,
});

class _ToggleCase {
  const _ToggleCase(this.name, this.control, this.theme, this.global);

  final String name;
  final _ControlBuilder control;
  final Widget Function(ToggleStyle style, Widget child) theme;
  final ThemeData Function(ToggleStyle style) global;

  bool get paintsThumb => name != 'Checkbox';
}

List<Decoration?> _painted(WidgetTester tester) {
  return tester
      .widgetList<AnimatedSurface>(
        find.descendant(
          of: find.byKey(_controlKey),
          matching: find.byType(AnimatedSurface),
        ),
      )
      .map((AnimatedSurface container) {
        final Finder finder = find.byWidget(container);
        return tester
            .widget<DecoratedBox>(
              find
                  .descendant(of: finder, matching: find.byType(DecoratedBox))
                  .first,
            )
            .decoration;
      })
      .toList();
}

ToggleStyle _themeStyle() => ToggleStyle(
  size: StateProperty<Size?>.resolveWith(
    (InteractionState state) =>
        state.isSelected ? const Size(48, 32) : const Size(40, 24),
  ),
  thumbSize: const StateProperty<Size?>.all(Size(16, 16)),
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isDisabled
          ? const Color(0xFF111111)
          : state.isPressed
          ? const Color(0xFF222222)
          : state.isHovered
          ? const Color(0xFF333333)
          : state.isFocused
          ? const Color(0xFF444444)
          : state.isSelected
          ? const Color(0xFF555555)
          : const Color(0xFF666666),
    ),
  ),
  thumbDecoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isSelected
          ? const Color(0xFF777777)
          : const Color(0xFF888888),
    ),
  ),
  animationDuration: const Duration(milliseconds: 200),
  animationCurve: Curves.linear,
);

void main() {
  final List<_ToggleCase> cases = <_ToggleCase>[
    _ToggleCase(
      'Checkbox',
      ({
        required bool? value,
        required bool enabled,
        FocusNode? focusNode,
        ToggleStyle? style,
        BoxDecoration? decoration,
        BoxDecoration? thumbDecoration,
      }) => Checkbox(
        key: _controlKey,
        value: value,
        tristate: true,
        onChanged: enabled ? (bool? value) {} : null,
        focusNode: focusNode,
        style: style,
        decoration: decoration,
      ),
      (ToggleStyle style, Widget child) =>
          CheckboxTheme(data: style, child: child),
      (ToggleStyle style) => ThemeData(checkboxStyle: style),
    ),
    _ToggleCase(
      'Switch',
      ({
        required bool? value,
        required bool enabled,
        FocusNode? focusNode,
        ToggleStyle? style,
        BoxDecoration? decoration,
        BoxDecoration? thumbDecoration,
      }) => Switch(
        key: _controlKey,
        value: value ?? false,
        onChanged: enabled ? (bool value) {} : null,
        focusNode: focusNode,
        style: style,
        decoration: decoration,
        thumbDecoration: thumbDecoration,
      ),
      (ToggleStyle style, Widget child) =>
          SwitchTheme(data: style, child: child),
      (ToggleStyle style) => ThemeData(switchStyle: style),
    ),
    _ToggleCase(
      'Radio',
      ({
        required bool? value,
        required bool enabled,
        FocusNode? focusNode,
        ToggleStyle? style,
        BoxDecoration? decoration,
        BoxDecoration? thumbDecoration,
      }) => Radio<int>(
        key: _controlKey,
        value: 1,
        groupValue: value == true ? 1 : 2,
        onChanged: enabled ? (int? value) {} : null,
        focusNode: focusNode,
        style: style,
        decoration: decoration,
        thumbDecoration: thumbDecoration,
      ),
      (ToggleStyle style, Widget child) =>
          RadioTheme(data: style, child: child),
      (ToggleStyle style) => ThemeData(radioStyle: style),
    ),
  ];

  for (final _ToggleCase component in cases) {
    for (final bool componentTheme in <bool>[false, true]) {
      testWidgets(
        '${component.name} decorations override ${componentTheme ? 'component' : 'PureTheme'} in every state and selection frame',
        (WidgetTester tester) async {
          useTraditionalFocus();
          final FocusNode focus = FocusNode();
          addTearDown(focus.dispose);
          final Set<InteractionState> observed = <InteractionState>{};
          final ToggleStyle inlineStyle = ToggleStyle(
            mouseCursor: StateProperty<MouseCursor?>.resolveWith((
              InteractionState state,
            ) {
              observed.add(state);
              return null;
            }),
          );
          bool? selected = false;
          bool enabled = true;
          late StateSetter update;
          final Widget control = StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              update = setState;
              return component.control(
                value: selected,
                enabled: enabled,
                focusNode: focus,
                style: inlineStyle,
                decoration: _box,
                thumbDecoration: component.paintsThumb ? _thumb : null,
              );
            },
          );
          await pumpPure(
            tester,
            componentTheme ? component.theme(_themeStyle(), control) : control,
            theme: component.global(_themeStyle()),
          );
          void expectDecorations() => expect(
            _painted(tester),
            component.paintsThumb
                ? <Decoration>[_box, _thumb]
                : <Decoration>[_box],
          );
          expectDecorations();
          final TestGesture mouse = await hover(
            tester,
            find.byKey(_controlKey),
          );
          await tester.pump(const Duration(milliseconds: 100));
          expectDecorations();
          focus.requestFocus();
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
          expect(focus.hasFocus, isTrue);
          expectDecorations();
          final TestGesture press = await tester.startGesture(
            tester.getCenter(find.byKey(_controlKey)),
          );
          await tester.pump(const Duration(milliseconds: 100));
          expectDecorations();
          await press.cancel();
          await mouse.removePointer();
          await tester.pumpAndSettle();
          final Size offSize = tester.getSize(
            find.byType(AnimatedSurface).first,
          );
          update(() => selected = true);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
          final Size middleSize = tester.getSize(
            find.byType(AnimatedSurface).first,
          );
          expect(middleSize.width, greaterThan(offSize.width));
          expect(middleSize.width, lessThan(48));
          expectDecorations();
          await tester.pumpAndSettle();
          expectDecorations();
          if (component.name == 'Checkbox') {
            update(() => selected = null);
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 100));
            expectDecorations();
            await tester.pumpAndSettle();
          }
          update(() => enabled = false);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
          expectDecorations();
          await tester.pumpAndSettle();
          expectDecorations();
          expect(
            observed.any((InteractionState state) => state.isHovered),
            isTrue,
          );
          expect(
            observed.any((InteractionState state) => state.isFocused),
            isTrue,
          );
          expect(
            observed.any((InteractionState state) => state.isPressed),
            isTrue,
          );
          expect(
            observed.any((InteractionState state) => state.isSelected),
            isTrue,
          );
          expect(
            observed.any((InteractionState state) => state.isDisabled),
            isTrue,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }

    for (final String part in <String>[
      'decoration',
      if (component.paintsThumb) 'thumbDecoration',
    ]) {
      testWidgets('${component.name} rejects $part with its inline token', (
        WidgetTester tester,
      ) async {
        final bool body = part == 'decoration';
        await pumpPure(
          tester,
          component.control(
            value: false,
            enabled: true,
            decoration: body ? _box : null,
            thumbDecoration: body ? null : _thumb,
            style: ToggleStyle(
              decoration: body
                  ? const StateProperty<Decoration?>.all(_box)
                  : null,
              thumbDecoration: body
                  ? null
                  : const StateProperty<Decoration?>.all(_thumb),
            ),
          ),
        );
        expect(
          tester.takeException(),
          isA<FlutterError>().having(
            (FlutterError error) => error.toString(),
            'message',
            allOf(
              contains(component.name),
              contains('`$part`'),
              contains('`style.$part`'),
            ),
          ),
        );
      });
    }
  }

  testWidgets(
    'selection still interpolates style decorations without an override',
    (WidgetTester tester) async {
      bool selected = false;
      late StateSetter update;
      await pumpPure(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            update = setState;
            return Switch(
              key: _controlKey,
              value: selected,
              onChanged: (bool value) {},
              style: _themeStyle(),
            );
          },
        ),
      );
      final List<Decoration?> off = _painted(tester);
      update(() => selected = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final List<Decoration?> middle = _painted(tester);
      await tester.pumpAndSettle();
      final List<Decoration?> on = _painted(tester);
      expect(middle, isNot(off));
      expect(middle, isNot(on));
      for (int i = 0; i < middle.length; i += 1) {
        expect(middle[i], Decoration.lerp(off[i], on[i], 0.5));
      }
    },
  );

  testWidgets(
    'checkbox only paints its box even when the style defines a thumb',
    (WidgetTester tester) async {
      await pumpPure(
        tester,
        const Checkbox(
          key: _controlKey,
          value: true,
          onChanged: null,
          decoration: _box,
          style: ToggleStyle(
            thumbDecoration: StateProperty<Decoration?>.all(_thumb),
          ),
        ),
      );
      expect(_painted(tester), <Decoration>[_box]);
      expect(tester.takeException(), isNull);
    },
  );
}
