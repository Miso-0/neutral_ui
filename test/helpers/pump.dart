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
          child: Center(child: child),
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

/// Makes keyboard focus visible and restores the previous strategy afterward.
void useTraditionalFocus() {
  final FocusHighlightStrategy old = FocusManager.instance.highlightStrategy;
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(() {
    FocusManager.instance.highlightStrategy = old;
  });
}
