import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('positions follow a thumb that grows on hover', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      SizedBox(
        width: 200,
        child: Slider(
          value: 1,
          onChanged: (double value) {},
          style: SliderStyle(
            animationDuration: const Duration(milliseconds: 200),
            animationCurve: Curves.linear,
            thumbSize: StateProperty<Size?>.resolveWith(
              (InteractionState state) =>
                  state.isHovered ? const Size(30, 30) : const Size(10, 10),
            ),
            thumbDecoration: const StateProperty<Decoration?>.all(
              BoxDecoration(color: Color(0xFF087F6D)),
            ),
          ),
        ),
      ),
    );
    final Finder thumb = find.byType(AnimatedSurface).last;
    final double start = tester.getCenter(thumb).dx;
    final TestGesture mouse = await hover(tester, find.byType(Slider));
    final List<double> centers = await sampleValues(
      tester,
      () => tester.getCenter(thumb).dx,
      step: const Duration(milliseconds: 20),
    );
    // The thumb ends 10 pixels further in, getting there frame by frame.
    expect(centers.last, closeTo(start - 10, 0.01));
    expectMonotonicValues(centers, from: start, to: start - 10);
    for (int index = 1; index < centers.length; index++) {
      expect((centers[index] - centers[index - 1]).abs(), lessThan(2));
    }
    await mouse.removePointer();
  });
}
