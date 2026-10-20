import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

class _ToggleCase {
  const _ToggleCase({
    required this.name,
    required this.control,
    required this.theme,
    required this.global,
    required this.unrelatedTheme,
  });

  final String name;
  final Widget Function(ToggleStyle? style) control;
  final Widget Function(ToggleStyle style, Widget child) theme;
  final ThemeData Function(ToggleStyle style) global;
  final Widget Function(ToggleStyle style, Widget child) unrelatedTheme;
}

ToggleStyle _sized(double size) => ToggleStyle(
  size: StateProperty<Size?>.all(Size(size, size)),
  animationDuration: Duration.zero,
);

void main() {
  final List<_ToggleCase> cases = <_ToggleCase>[
    _ToggleCase(
      name: 'Checkbox',
      control: (ToggleStyle? style) =>
          Checkbox(value: false, onChanged: (bool? next) {}, style: style),
      theme: (ToggleStyle style, Widget child) =>
          CheckboxTheme(data: style, child: child),
      global: (ToggleStyle style) => ThemeData(checkboxStyle: style),
      unrelatedTheme: (ToggleStyle style, Widget child) =>
          SwitchTheme(data: style, child: child),
    ),
    _ToggleCase(
      name: 'Switch',
      control: (ToggleStyle? style) =>
          Switch(value: false, onChanged: (bool next) {}, style: style),
      theme: (ToggleStyle style, Widget child) =>
          SwitchTheme(data: style, child: child),
      global: (ToggleStyle style) => ThemeData(switchStyle: style),
      unrelatedTheme: (ToggleStyle style, Widget child) =>
          RadioTheme(data: style, child: child),
    ),
    _ToggleCase(
      name: 'Radio',
      control: (ToggleStyle? style) => Radio<int>(
        value: 1,
        groupValue: 2,
        onChanged: (int? next) {},
        style: style,
      ),
      theme: (ToggleStyle style, Widget child) =>
          RadioTheme(data: style, child: child),
      global: (ToggleStyle style) => ThemeData(radioStyle: style),
      unrelatedTheme: (ToggleStyle style, Widget child) =>
          CheckboxTheme(data: style, child: child),
    ),
  ];

  for (final _ToggleCase component in cases) {
    testWidgets(
      '${component.name} resolves inline, component, then global tokens',
      (WidgetTester tester) async {
        await pumpNeutral(
          tester,
          component.theme(_sized(30.0), component.control(_sized(36.0))),
          theme: component.global(_sized(24.0)),
        );
        expect(
          tester.getSize(find.byType(AnimatedSurface).first),
          const Size(36.0, 36.0),
        );
        await pumpNeutral(
          tester,
          component.theme(_sized(30.0), component.control(null)),
          theme: component.global(_sized(24.0)),
        );
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byType(AnimatedSurface).first),
          const Size(30.0, 30.0),
        );
        await pumpNeutral(
          tester,
          component.control(null),
          theme: component.global(_sized(24.0)),
        );
        expect(
          tester.getSize(find.byType(AnimatedSurface).first),
          const Size(24.0, 24.0),
        );
      },
    );

    testWidgets(
      '${component.name} falls through null resolved tokens per state',
      (WidgetTester tester) async {
        final List<InteractionState> states = <InteractionState>[];
        await pumpNeutral(
          tester,
          component.theme(
            _sized(24.0),
            component.control(
              ToggleStyle(
                size: StateProperty<Size?>.resolveWith((
                  InteractionState state,
                ) {
                  states.add(state);
                  return state.isPressed ? const Size(36.0, 36.0) : null;
                }),
                animationDuration: Duration.zero,
              ),
            ),
          ),
        );
        expect(
          tester.getSize(find.byType(AnimatedSurface).first),
          const Size(24.0, 24.0),
        );
        final TestGesture gesture = await tester.startGesture(
          tester.getCenter(find.byType(AnimatedSurface).first),
        );
        await tester.pump(const Duration(milliseconds: 150));
        expect(states.any((InteractionState state) => state.isPressed), isTrue);
        expect(
          tester.getSize(find.byType(AnimatedSurface).first),
          const Size(36.0, 36.0),
        );
        await gesture.cancel();
        await tester.pumpAndSettle();
      },
    );

    testWidgets('${component.name} ignores other component themes', (
      WidgetTester tester,
    ) async {
      await pumpNeutral(
        tester,
        component.unrelatedTheme(_sized(40.0), component.control(null)),
        theme: component.global(_sized(20.0)),
      );
      expect(
        tester.getSize(find.byType(AnimatedSurface).first),
        const Size(20.0, 20.0),
      );
    });

    testWidgets(
      '${component.name} inline structural token overrides touch target',
      (WidgetTester tester) async {
        await pumpNeutral(
          tester,
          component.theme(
            const ToggleStyle(tapTargetSize: Size(60.0, 60.0)),
            component.control(
              const ToggleStyle(tapTargetSize: Size(28.0, 28.0)),
            ),
          ),
        );
        final Finder detector = find.byType(InteractionDetector);
        expect(tester.getSize(detector), const Size(28.0, 28.0));
      },
    );
  }
}
