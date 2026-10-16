import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

const Color _clear = Color(0x00000000);
const Color _light = Color(0xFFF0F5F0);
const Color _dark = Color(0xFF142C2A);
const Duration _duration = Duration(milliseconds: 200);

Widget _frame(Widget child) => Directionality(
  textDirection: TextDirection.ltr,
  child: Align(alignment: Alignment.topLeft, child: child),
);

Widget _surface(Color color, {Duration duration = _duration, Key? key}) =>
    AnimatedSurface(
      key: key,
      duration: duration,
      decoration: BoxDecoration(color: color),
      child: const SizedBox(width: 40, height: 20),
    );

Finder get _surfaceFinder => find.byType(AnimatedSurface);

void main() {
  testWidgets('lays out exactly like AnimatedContainer', (
    WidgetTester tester,
  ) async {
    const Key child = Key('child');
    final BoxDecoration decoration = BoxDecoration(
      color: _light,
      border: Border.all(width: 3),
      borderRadius: BorderRadius.circular(6),
    );
    Future<(Rect, Rect)> measure(bool surface) async {
      const EdgeInsets padding = EdgeInsets.fromLTRB(4, 6, 8, 10);
      const Widget content = SizedBox(key: child, width: 30, height: 12);
      await tester.pumpWidget(
        _frame(
          surface
              ? AnimatedSurface(
                  duration: _duration,
                  width: 90,
                  constraints: const BoxConstraints(minHeight: 50),
                  padding: padding,
                  decoration: decoration,
                  clipBehavior: Clip.antiAlias,
                  child: content,
                )
              : AnimatedContainer(
                  duration: _duration,
                  width: 90,
                  constraints: const BoxConstraints(minHeight: 50),
                  padding: padding,
                  decoration: decoration,
                  clipBehavior: Clip.antiAlias,
                  child: content,
                ),
        ),
      );
      final Finder box = surface
          ? find.byType(AnimatedSurface)
          : find.byType(AnimatedContainer);
      return (tester.getRect(box), tester.getRect(find.byKey(child)));
    }

    final (Rect, Rect) container = await measure(false);
    final (Rect, Rect) surface = await measure(true);
    expect(surface, container);
    expect(surface.$2.topLeft, const Offset(7, 9));
  });

  testWidgets('fades the painted decoration over its duration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_frame(_surface(_clear)));
    expect(paintedColor(tester, _surfaceFinder), _clear);
    await tester.pumpWidget(_frame(_surface(_light)));
    await tester.pump(const Duration(milliseconds: 100));
    final Color middle = paintedColor(tester, _surfaceFinder)!;
    expect(middle.a, closeTo(0.5, 0.01));
    expect(middle.r, closeTo(_light.r, 1e-6));
    expect(middle.g, closeTo(_light.g, 1e-6));
    await tester.pump(const Duration(milliseconds: 100));
    expect(paintedColor(tester, _surfaceFinder), _light);
  });

  testWidgets('a zero duration jumps straight to the target', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_frame(_surface(_clear, duration: Duration.zero)));
    await tester.pumpWidget(_frame(_surface(_dark, duration: Duration.zero)));
    await tester.pump();
    expect(paintedColor(tester, _surfaceFinder), _dark);
  });

  testWidgets('retargeting mid-fade continues from the painted value', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_frame(_surface(_clear)));
    await tester.pumpWidget(_frame(_surface(_light)));
    await tester.pump(const Duration(milliseconds: 100));
    final double before = brightnessOverWhite(
      paintedColor(tester, _surfaceFinder),
    );
    await tester.pumpWidget(_frame(_surface(_clear)));
    expect(
      brightnessOverWhite(paintedColor(tester, _surfaceFinder)),
      closeTo(before, 1e-6),
    );
    final List<double> samples = await sampleBrightness(tester, _surfaceFinder);
    expect(samples.last, closeTo(1, 1e-6));
  });

  testWidgets('clipping waits for a decoration that is fading in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        AnimatedSurface(
          duration: _duration,
          child: const SizedBox(width: 10, height: 10),
        ),
      ),
    );
    await tester.pumpWidget(
      _frame(
        AnimatedSurface(
          duration: _duration,
          decoration: BoxDecoration(
            color: _light,
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: const SizedBox(width: 10, height: 10),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      tester.widget<Container>(find.byType(Container)).clipBehavior,
      Clip.antiAlias,
    );
  });
}
