import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

/// Pumps a control with application keyboard bindings and PureUI theming.
Future<void> pumpPure(
  WidgetTester tester,
  Widget child, {
  ThemeData? theme,
  TextDirection textDirection = TextDirection.ltr,
}) async {
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      builder: (BuildContext context, Widget? appChild) => Directionality(
        textDirection: textDirection,
        child: PureTheme(
          data: theme ?? const ThemeData(),
          child: Overlay(
            key: UniqueKey(),
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (BuildContext context) => Center(child: child),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Moves a mouse to the center of a control.
Future<TestGesture> hover(WidgetTester tester, Finder finder) async {
  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer(location: Offset.zero);
  await gesture.moveTo(tester.getCenter(finder));
  await tester.pump();
  return gesture;
}

/// Returns the background color currently painted inside [surface].
///
/// This reads the animated value that is on screen, not the transition target.
Color? paintedColor(WidgetTester tester, Finder surface) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: surface,
          matching: find.byWidgetPredicate(
            (Widget widget) =>
                widget is DecoratedBox &&
                widget.position == DecorationPosition.background,
          ),
        )
        .first,
  );
  final Decoration decoration = box.decoration;
  return decoration is BoxDecoration ? decoration.color : null;
}

/// The mean channel brightness of [color] composited over white.
double brightnessOverWhite(Color? color) {
  if (color == null) return 1;
  double channel(double value) => value * color.a + (1 - color.a);
  return (channel(color.r) + channel(color.g) + channel(color.b)) / 3;
}

/// Samples the brightness of [surface] every [step] until [duration] elapses.
Future<List<double>> sampleBrightness(
  WidgetTester tester,
  Finder surface, {
  Duration duration = const Duration(milliseconds: 200),
  Duration step = const Duration(milliseconds: 20),
}) async {
  final List<double> samples = <double>[];
  for (Duration elapsed = Duration.zero; elapsed < duration; elapsed += step) {
    await tester.pump(step);
    samples.add(brightnessOverWhite(paintedColor(tester, surface)));
  }
  return samples;
}

/// Expects a fade to stay between its endpoints and to show intermediate frames.
void expectNoDip(
  List<double> samples, {
  required double from,
  required double to,
}) {
  const double tolerance = 1e-6;
  final double low = from < to ? from : to;
  final double high = from < to ? to : from;
  for (final double sample in samples) {
    expect(sample, greaterThanOrEqualTo(low - tolerance));
    expect(sample, lessThanOrEqualTo(high + tolerance));
  }
  expect(
    samples.any(
      (double sample) => sample > low + tolerance && sample < high - tolerance,
    ),
    isTrue,
    reason: 'the transition should be sampled part-way through',
  );
}

/// Makes keyboard focus visible and restores the previous strategy afterward.
void useTraditionalFocus() {
  final FocusHighlightStrategy old = FocusManager.instance.highlightStrategy;
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(() {
    FocusManager.instance.highlightStrategy = old;
  });
}
