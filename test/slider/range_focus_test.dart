import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

const Color _focusedTrack = Color(0xFFAA0000);
const Color _track = Color(0xFFCCCCCC);

void main() {
  testWidgets('a focused range thumb grows alone and lights the track', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    await pumpNeutral(
      tester,
      SizedBox(
        width: 300,
        child: RangeSlider(
          values: const RangeValues(0.2, 0.8),
          autofocus: true,
          onChanged: (RangeValues values) {},
          style: SliderStyle(
            thumbSize: StateProperty<Size?>.resolveWith(
              (InteractionState state) =>
                  state.isFocused ? const Size(30, 30) : const Size(20, 20),
            ),
            trackDecoration: StateProperty<Decoration?>.resolveWith(
              (InteractionState state) => BoxDecoration(
                color: state.isFocused ? _focusedTrack : _track,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final Iterable<double?> thumbWidths = tester
        .widgetList<AnimatedSurface>(
          find.descendant(
            of: find.byType(RangeSlider),
            matching: find.byType(AnimatedSurface),
          ),
        )
        .where(
          (AnimatedSurface surface) => surface.constraints?.isTight ?? false,
        )
        .map((AnimatedSurface surface) => surface.constraints!.maxWidth);
    expect(thumbWidths.where((double? width) => width == 30), hasLength(1));
    expect(thumbWidths.where((double? width) => width == 20), hasLength(1));
    expect(
      tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(RangeSlider),
              matching: find.byType(DecoratedBox),
            ),
          )
          .any(
            (DecoratedBox box) =>
                box.decoration is BoxDecoration &&
                (box.decoration as BoxDecoration).color == _focusedTrack,
          ),
      isTrue,
    );
  });
}
