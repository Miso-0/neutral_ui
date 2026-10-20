import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

const BoxDecoration _track = BoxDecoration(color: Color(0xFF123456));
const BoxDecoration _active = BoxDecoration(color: Color(0xFF234567));
const BoxDecoration _secondary = BoxDecoration(color: Color(0xFF345678));
const BoxDecoration _thumb = BoxDecoration(
  color: Color(0xFF456789),
  shape: BoxShape.circle,
);
const BoxDecoration _tick = BoxDecoration(color: Color(0xFF56789A));
const BoxDecoration _activeTick = BoxDecoration(color: Color(0xFF6789AB));

const List<String> _parts = <String>[
  'trackDecoration',
  'activeTrackDecoration',
  'secondaryActiveTrackDecoration',
  'thumbDecoration',
  'tickMarkDecoration',
  'activeTickMarkDecoration',
];

SliderStyle _themeStyle() {
  final StateProperty<Decoration?> decoration =
      StateProperty<Decoration?>.resolveWith(
        (InteractionState state) => BoxDecoration(
          color: state.isDisabled
              ? const Color(0xFF111111)
              : state.isPressed
              ? const Color(0xFF222222)
              : state.isHovered
              ? const Color(0xFF333333)
              : state.isFocused
              ? const Color(0xFF444444)
              : const Color(0xFF555555),
        ),
      );
  return SliderStyle(
    trackHeight: const StateProperty<double?>.all(6),
    thumbSize: const StateProperty<Size?>.all(Size(20, 20)),
    tickMarkSize: const StateProperty<Size?>.all(Size(4, 4)),
    trackDecoration: decoration,
    activeTrackDecoration: decoration,
    secondaryActiveTrackDecoration: decoration,
    thumbDecoration: decoration,
    tickMarkDecoration: decoration,
    activeTickMarkDecoration: decoration,
    animationDuration: const Duration(milliseconds: 200),
    animationCurve: Curves.linear,
  );
}

Slider _decorated({
  double value = 0.5,
  bool enabled = true,
  FocusNode? focusNode,
  SliderStyle? style,
}) => Slider(
  value: value,
  secondaryTrackValue: 0.8,
  divisions: 2,
  onChanged: enabled ? (double value) {} : null,
  focusNode: focusNode,
  style: style,
  trackDecoration: _track,
  activeTrackDecoration: _active,
  secondaryActiveTrackDecoration: _secondary,
  thumbDecoration: _thumb,
  tickMarkDecoration: _tick,
  activeTickMarkDecoration: _activeTick,
);

List<Decoration> _painted(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(Slider),
        matching: find.byType(DecoratedBox),
      ),
    )
    .map((DecoratedBox widget) => widget.decoration)
    .toList();

void main() {
  for (final bool componentTheme in <bool>[false, true]) {
    testWidgets(
      'all slider parts override ${componentTheme ? 'component' : 'NeutralTheme'} decorations in every state',
      (WidgetTester tester) async {
        useTraditionalFocus();
        final FocusNode focus = FocusNode();
        addTearDown(focus.dispose);
        final Set<InteractionState> observed = <InteractionState>{};
        final SliderStyle inlineStyle = SliderStyle(
          mouseCursor: StateProperty<MouseCursor?>.resolveWith((
            InteractionState state,
          ) {
            observed.add(state);
            return null;
          }),
        );
        bool enabled = true;
        late StateSetter update;
        final Widget control = SizedBox(
          width: 240,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              update = setState;
              return _decorated(
                enabled: enabled,
                focusNode: focus,
                style: inlineStyle,
              );
            },
          ),
        );
        await pumpNeutral(
          tester,
          componentTheme
              ? SliderTheme(data: _themeStyle(), child: control)
              : control,
          theme: ThemeData(sliderStyle: _themeStyle()),
        );
        void expectDecorations() => expect(_painted(tester), <Decoration>[
          _track,
          _secondary,
          _active,
          _activeTick,
          _activeTick,
          _tick,
          _thumb,
        ]);
        expectDecorations();
        final TestGesture mouse = await hover(tester, find.byType(Slider));
        await tester.pump(const Duration(milliseconds: 100));
        expectDecorations();
        focus.requestFocus();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(focus.hasFocus, isTrue);
        expectDecorations();
        final TestGesture press = await tester.startGesture(
          tester.getCenter(find.byType(Slider)),
        );
        await tester.pump(const Duration(milliseconds: 100));
        expectDecorations();
        await press.cancel();
        await mouse.removePointer();
        await tester.pumpAndSettle();
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
          observed.any((InteractionState state) => state.isDisabled),
          isTrue,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final String part in _parts) {
    testWidgets('slider rejects $part with its inline token', (
      WidgetTester tester,
    ) async {
      const StateProperty<Decoration?> token = StateProperty<Decoration?>.all(
        _track,
      );
      final SliderStyle style = switch (part) {
        'trackDecoration' => const SliderStyle(trackDecoration: token),
        'activeTrackDecoration' => const SliderStyle(
          activeTrackDecoration: token,
        ),
        'secondaryActiveTrackDecoration' => const SliderStyle(
          secondaryActiveTrackDecoration: token,
        ),
        'thumbDecoration' => const SliderStyle(thumbDecoration: token),
        'tickMarkDecoration' => const SliderStyle(tickMarkDecoration: token),
        'activeTickMarkDecoration' => const SliderStyle(
          activeTickMarkDecoration: token,
        ),
        _ => throw StateError('Unknown part: $part'),
      };
      await pumpNeutral(tester, _decorated(style: style));
      expect(
        tester.takeException(),
        isA<FlutterError>().having(
          (FlutterError error) => error.toString(),
          'message',
          allOf(
            contains('Slider'),
            contains('`$part`'),
            contains('`style.$part`'),
          ),
        ),
      );
    });
  }

  test('tickMarkDecoration needs divisions at construction', () {
    expect(
      () => Slider(value: 0.5, onChanged: null, tickMarkDecoration: _tick),
      throwsAssertionError,
    );
  });

  test('activeTickMarkDecoration needs divisions at construction', () {
    expect(
      () => Slider(
        value: 0.5,
        onChanged: null,
        activeTickMarkDecoration: _activeTick,
      ),
      throwsAssertionError,
    );
  });

  test(
    'secondaryActiveTrackDecoration needs a secondary value at construction',
    () {
      expect(
        () => Slider(
          value: 0.5,
          onChanged: null,
          secondaryActiveTrackDecoration: _secondary,
        ),
        throwsAssertionError,
      );
    },
  );

  testWidgets(
    'const slider accepts applicable decorations and unrelated inline tokens',
    (WidgetTester tester) async {
      await pumpNeutral(
        tester,
        const Slider(
          value: 0.5,
          secondaryTrackValue: 0.8,
          divisions: 2,
          onChanged: null,
          thumbDecoration: _thumb,
          secondaryActiveTrackDecoration: _secondary,
          tickMarkDecoration: _tick,
          activeTickMarkDecoration: _activeTick,
          style: SliderStyle(
            trackDecoration: StateProperty<Decoration?>.all(_track),
          ),
        ),
      );
      expect(
        _painted(tester),
        containsAll(<Decoration>[
          _track,
          _thumb,
          _secondary,
          _tick,
          _activeTick,
        ]),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
