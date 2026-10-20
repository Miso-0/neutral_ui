import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// Pumps a control with application keyboard bindings and NeutralUI theming.
Future<void> pumpNeutral(
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
        child: NeutralTheme(
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

/// Pumps route-based components with navigation, localization and NeutralUI themes.
Future<void> pumpNeutralApp(
  WidgetTester tester,
  Widget child, {
  ThemeData theme = const ThemeData(),
  TextDirection textDirection = TextDirection.ltr,
  bool disableAnimations = false,
  GlobalKey<NavigatorState>? navigatorKey,
}) async {
  await tester.pumpWidget(
    NeutralApp(
      color: const Color(0xFFFFFFFF),
      theme: theme,
      navigatorKey: navigatorKey,
      builder: (BuildContext context, Widget? child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(disableAnimations: disableAnimations),
        child: Directionality(textDirection: textDirection, child: child!),
      ),
      home: Center(child: child),
    ),
  );
  await tester.pumpAndSettle();
}

/// Samples a currently painted opacity, position, scale or other scalar value.
Future<List<double>> sampleValues(
  WidgetTester tester,
  double Function() readValue, {
  Duration duration = const Duration(milliseconds: 200),
  Duration step = const Duration(milliseconds: 10),
}) async {
  assert(step > Duration.zero);
  final List<double> samples = <double>[readValue()];
  for (Duration elapsed = Duration.zero; elapsed < duration; elapsed += step) {
    final Duration remaining = duration - elapsed;
    await tester.pump(remaining < step ? remaining : step);
    samples.add(readValue());
  }
  return samples;
}

/// Expects each successive value to move toward [to], without overshooting.
void expectMonotonicValues(
  List<double> samples, {
  required double from,
  required double to,
}) {
  const double tolerance = 1e-6;
  double previous = from;
  for (final double value in samples) {
    expect(
      value,
      inInclusiveRange(
        (from < to ? from : to) - tolerance,
        (from > to ? from : to) + tolerance,
      ),
    );
    expect(
      to >= from ? value - previous : previous - value,
      greaterThanOrEqualTo(-tolerance),
    );
    previous = value;
  }
}
