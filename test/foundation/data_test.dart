import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_icon_theme.dart';
import 'package:neutral_ui/src/foundation/style_resolution.dart';
import 'package:neutral_ui/src/foundation/tap_target.dart';

void main() {
  group('InteractionState', () {
    test('defaults are enabled and inactive', () {
      const InteractionState state = InteractionState();
      expect(state.isEnabled, isTrue);
      expect(state.toWidgetStates(), isEmpty);
      expect(state.copyWith(), state);
    });

    test('copies every flag and supports value equality', () {
      const InteractionState all = InteractionState(
        isPressed: true,
        isHovered: true,
        isFocused: true,
        isSelected: true,
        isDisabled: true,
        isDragged: true,
        isError: true,
      );
      final InteractionState copy = const InteractionState().copyWith(
        isPressed: true,
        isHovered: true,
        isFocused: true,
        isSelected: true,
        isDisabled: true,
        isDragged: true,
        isError: true,
      );
      expect(copy, all);
      expect(copy.hashCode, all.hashCode);
      expect(copy.isEnabled, isFalse);
      expect(
        copy.copyWith(
          isPressed: false,
          isHovered: false,
          isFocused: false,
          isSelected: false,
          isDisabled: false,
          isDragged: false,
          isError: false,
        ),
        const InteractionState(),
      );
      expect(copy.toString(), contains('isDragged: true'));
    });

    test('each flag participates in equality and WidgetState conversion', () {
      for (final WidgetState flag in <WidgetState>[
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
        WidgetState.selected,
        WidgetState.disabled,
        WidgetState.dragged,
        WidgetState.error,
      ]) {
        final Set<WidgetState> flags = <WidgetState>{flag};
        final InteractionState state = InteractionState.fromWidgetStates(flags);
        expect(state, isNot(const InteractionState()));
        expect(state.toWidgetStates(), flags);
        expect(
          InteractionState.fromWidgetStates(state.toWidgetStates()),
          state,
        );
      }
    });

    test('unrepresented WidgetState values are safely ignored', () {
      expect(
        InteractionState.fromWidgetStates(<WidgetState>{
          WidgetState.scrolledUnder,
        }),
        const InteractionState(),
      );
    });
  });

  group('StateProperty', () {
    test('all resolves in every state with value equality', () {
      const StateProperty<int> first = StateProperty<int>.all(42);
      const StateProperty<int> second = StateProperty<int>.all(42);
      expect(first.resolve(const InteractionState()), 42);
      expect(first.resolve(const InteractionState(isDisabled: true)), 42);
      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(const StateProperty<int>.all(43)));
      expect(first.toString(), contains('42'));
      expect(
        const StateProperty<String?>.all(null)
            .resolve(const InteractionState()),
        isNull,
      );
    });

    test('resolveWith invokes and compares the resolver', () {
      String resolver(InteractionState state) =>
          state.isPressed ? 'pressed' : 'rest';
      final StateProperty<String> first = StateProperty<String>.resolveWith(
        resolver,
      );
      final StateProperty<String> second = StateProperty<String>.resolveWith(
        resolver,
      );
      expect(first.resolve(const InteractionState()), 'rest');
      expect(first.resolve(const InteractionState(isPressed: true)), 'pressed');
      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(
        first,
        isNot(
          StateProperty<String>.resolveWith(
            (InteractionState state) => 'different',
          ),
        ),
      );
      expect(first.toString(), contains('resolveWith'));
    });
  });

  group('Style resolution', () {
    test('stateful values fall through null resolvers per state', () {
      final ButtonStyle inline = ButtonStyle(
        textStyle: StateProperty<TextStyle?>.resolveWith(
          (InteractionState state) =>
              state.isPressed ? const TextStyle(fontSize: 20) : null,
        ),
      );
      const ButtonStyle theme = ButtonStyle(
        textStyle: StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
      final List<ButtonStyle?> layers = <ButtonStyle?>[null, inline, theme];
      expect(
        resolveStateful<ButtonStyle, TextStyle>(
          const InteractionState(),
          layers,
          (ButtonStyle style) => style.textStyle,
        ),
        const TextStyle(fontSize: 10),
      );
      expect(
        resolveStateful<ButtonStyle, TextStyle>(
          const InteractionState(isPressed: true),
          layers,
          (ButtonStyle style) => style.textStyle,
        ),
        const TextStyle(fontSize: 20),
      );
      expect(
        resolveStateful<ButtonStyle, Size>(
          const InteractionState(),
          layers,
          (ButtonStyle style) => style.minimumSize,
        ),
        isNull,
      );
    });

    test('plain values use the first non-null token', () {
      final List<ButtonStyle?> layers = <ButtonStyle?>[
        null,
        const ButtonStyle(),
        const ButtonStyle(spacing: 5),
        const ButtonStyle(spacing: 9),
      ];
      expect(
        resolvePlain<ButtonStyle, double>(
          layers,
          (ButtonStyle style) => style.spacing,
        ),
        5,
      );
      expect(
        resolvePlain<ButtonStyle, Size>(
          layers,
          (ButtonStyle style) => style.tapTargetSize,
        ),
        isNull,
      );
    });
  });

  testWidgets('TapTarget sizes to its child when no minimum is supplied', (
    WidgetTester tester,
  ) async {
    const Key target = ValueKey<String>('target');
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: TapTarget(key: target, child: SizedBox(width: 8, height: 12)),
        ),
      ),
    );
    expect(tester.getSize(find.byKey(target)), const Size(8, 12));
  });

  testWidgets('TapTarget corners remain interactive and hoverable', (
    WidgetTester tester,
  ) async {
    const Key target = ValueKey<String>('target');
    int taps = 0;
    int hovers = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: MouseRegion(
            onEnter: (_) => hovers += 1,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => taps += 1,
              child: const TapTarget(
                key: target,
                minSize: Size(48, 48),
                child: SizedBox(width: 8, height: 12),
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byKey(target)), const Size(48, 48));
    final Rect rect = tester.getRect(find.byKey(target));
    await tester.tapAt(rect.topLeft + const Offset(1, 1));
    await tester.tapAt(rect.bottomRight - const Offset(1, 1));
    expect(taps, 2);
    final TestGesture mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(rect.topRight + const Offset(-1, 1));
    await tester.pump();
    expect(hovers, 1);
    await mouse.removePointer();
  });

  testWidgets('AnimatedIconTheme interpolates and merges inherited values', (
    WidgetTester tester,
  ) async {
    IconThemeData? found;
    final Widget probe = Builder(
      builder: (BuildContext context) {
        found = IconTheme.of(context);
        return const SizedBox();
      },
    );
    Widget tree(double size) => IconTheme(
      data: const IconThemeData(color: Color(0xFF123456)),
      child: AnimatedIconTheme(
        data: IconThemeData(size: size),
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
        child: probe,
      ),
    );
    await tester.pumpWidget(tree(10));
    expect(found!.size, 10);
    expect(found!.color, const Color(0xFF123456));
    await tester.pumpWidget(tree(30));
    await tester.pump(const Duration(milliseconds: 100));
    expect(found!.size, closeTo(20, 0.001));
    expect(found!.color, const Color(0xFF123456));
    await tester.pumpAndSettle();
    expect(found!.size, 30);
  });
}
