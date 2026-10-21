import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';

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
      tester
          .widget<ClipPath>(
            find.descendant(
              of: _surfaceFinder,
              matching: find.byType(ClipPath),
            ),
          )
          .clipBehavior,
      Clip.antiAlias,
    );
  });

  testWidgets('a decoration appearing from null fades in', (
    WidgetTester tester,
  ) async {
    Widget build(Decoration? decoration) => _frame(
      AnimatedSurface(
        duration: _duration,
        decoration: decoration,
        child: const SizedBox(width: 40, height: 20),
      ),
    );
    await tester.pumpWidget(build(null));
    await tester.pumpWidget(build(const BoxDecoration(color: _light)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(paintedColor(tester, _surfaceFinder)!.a, closeTo(0.5, 0.01));
    await tester.pump(const Duration(milliseconds: 100));
    expect(paintedColor(tester, _surfaceFinder), _light);

    await tester.pumpWidget(build(null));
    await tester.pump(const Duration(milliseconds: 100));
    expect(paintedColor(tester, _surfaceFinder)!.a, closeTo(0.5, 0.01));
    await tester.pump(const Duration(milliseconds: 100));
    expect(paintedColor(tester, _surfaceFinder), isNull);
  });

  testWidgets('null and non-null values never remount the child', (
    WidgetTester tester,
  ) async {
    final GlobalKey<_ProbeState> probe = GlobalKey<_ProbeState>();
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    Widget build(bool decorated) => _frame(
      AnimatedSurface(
        duration: _duration,
        padding: decorated ? const EdgeInsets.all(2) : null,
        decoration: decorated
            ? BoxDecoration(
                color: _light,
                borderRadius: BorderRadius.circular(4),
              )
            : null,
        foregroundDecoration: decorated
            ? BoxDecoration(border: Border.all(color: _dark))
            : null,
        constraints: decorated ? const BoxConstraints(minWidth: 60) : null,
        clipBehavior: Clip.antiAlias,
        child: _Probe(key: probe, focusNode: node),
      ),
    );
    await tester.pumpWidget(build(false));
    node.requestFocus();
    await tester.pump();
    final _ProbeState state = probe.currentState!;
    for (final bool decorated in <bool>[true, false, true]) {
      await tester.pumpWidget(build(decorated));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();
      expect(identical(probe.currentState, state), isTrue);
      expect(node.hasPrimaryFocus, isTrue);
    }
  });

  testWidgets('an undecorated surface lets taps through to what is behind', (
    WidgetTester tester,
  ) async {
    int taps = 0;
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            children: <Widget>[
              Positioned.fill(child: GestureDetector(onTap: () => taps++)),
              Positioned.fill(
                child: AnimatedSurface(
                  duration: _duration,
                  clipBehavior: Clip.antiAlias,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tapAt(const Offset(50, 50));
    expect(taps, 1);
  });

  testWidgets('an unchanged transition key follows values without fading', (
    WidgetTester tester,
  ) async {
    Widget build(Color color, Object key) => _frame(
      AnimatedSurface(
        duration: _duration,
        transitionKey: key,
        decoration: BoxDecoration(color: color),
        child: const SizedBox(width: 40, height: 20),
      ),
    );
    await tester.pumpWidget(build(_light, 'idle'));
    await tester.pumpWidget(build(_dark, 'idle'));
    expect(paintedColor(tester, _surfaceFinder), _dark);

    // A key change fades from the painted value, and later values under that
    // key retarget the same transition instead of restarting it.
    await tester.pumpWidget(build(_clear, 'hovered'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpWidget(build(_light, 'hovered'));
    final Color blended = paintedColor(tester, _surfaceFinder)!;
    expect(blended.a, closeTo(1, 1e-6));
    expect(blended.r, closeTo((_dark.r + _light.r) / 2, 0.01));
    await tester.pump(const Duration(milliseconds: 100));
    expect(paintedColor(tester, _surfaceFinder), _light);
  });
}

class _Probe extends StatefulWidget {
  const _Probe({super.key, required this.focusNode});

  final FocusNode focusNode;

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  @override
  Widget build(BuildContext context) => Focus(
    focusNode: widget.focusNode,
    child: const SizedBox(width: 20, height: 20),
  );
}
