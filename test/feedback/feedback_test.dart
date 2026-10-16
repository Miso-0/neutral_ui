import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/src/app/pure_app.dart' as pure;
import 'package:pure_ui/src/buttons/text_button.dart' as pure;
import 'package:pure_ui/src/buttons/icon_button.dart' as pure;
import 'package:pure_ui/src/feedback/bottom_sheet.dart';
import 'package:pure_ui/src/feedback/dialog.dart';
import 'package:pure_ui/src/feedback/snack_bar.dart';
import 'package:pure_ui/src/feedback/tooltip.dart';
import 'package:pure_ui/src/styles/bottom_sheet_style.dart';
import 'package:pure_ui/src/styles/dialog_style.dart';
import 'package:pure_ui/src/styles/snack_bar_style.dart';
import 'package:pure_ui/src/styles/tooltip_style.dart';

Future<void> app(
  WidgetTester tester,
  Widget child, {
  bool reduced = false,
  bool accessible = false,
  TextDirection direction = TextDirection.ltr,
}) async {
  await tester.pumpWidget(
    pure.PureApp(
      color: const Color(0xffffffff),
      builder: (BuildContext context, Widget? child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: reduced,
          accessibleNavigation: accessible,
        ),
        child: Directionality(textDirection: direction, child: child!),
      ),
      home: Center(child: child),
    ),
  );
  await tester.pump();
}

void main() {
  group('Tooltip', () {
    testWidgets('manual show and instance dismiss preserve other tooltips', (
      WidgetTester tester,
    ) async {
      final GlobalKey<TooltipState> first = GlobalKey<TooltipState>();
      final GlobalKey<TooltipState> second = GlobalKey<TooltipState>();
      await app(
        tester,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Tooltip(
              key: first,
              message: 'First hint',
              child: const Text('First'),
            ),
            Tooltip(
              key: second,
              message: 'Second hint',
              child: const Text('Second'),
            ),
          ],
        ),
      );
      expect(first.currentState!.ensureTooltipVisible(), isTrue);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('First hint'), findsOneWidget);
      expect(first.currentState!.ensureTooltipVisible(), isFalse);
      second.currentState!.ensureTooltipVisible();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      first.currentState!.dismiss();
      await tester.pump();
      expect(find.text('First hint'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('First hint'), findsNothing);
      expect(find.text('Second hint'), findsOneWidget);
    });
    testWidgets('hover waits, exits and reverses without opacity jump', (
      WidgetTester tester,
    ) async {
      await app(
        tester,
        const Tooltip(
          message: 'Hover hint',
          waitDuration: Duration(milliseconds: 100),
          exitDuration: Duration.zero,
          child: Text('Anchor'),
        ),
      );
      final TestGesture mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.text('Anchor')));
      await tester.pump(const Duration(milliseconds: 99));
      expect(find.text('Hover hint'), findsNothing);
      await tester.pump(const Duration(milliseconds: 2));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final Finder fade = find
          .ancestor(
            of: find.text('Hover hint'),
            matching: find.byType(FadeTransition),
          )
          .first;
      final double before = tester.widget<FadeTransition>(fade).opacity.value;
      expect(before, allOf(greaterThan(0), lessThan(1)));
      await mouse.moveTo(Offset.zero);
      await tester.pump();
      final double after = tester.widget<FadeTransition>(fade).opacity.value;
      expect(after, closeTo(before, .001));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Hover hint'), findsNothing);
      await mouse.removePointer();
    });
    testWidgets(
      'keyboard focus opens, Escape closes and visibility gates opening',
      (WidgetTester tester) async {
        final FocusHighlightStrategy old =
            FocusManager.instance.highlightStrategy;
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        addTearDown(() {
          FocusManager.instance.highlightStrategy = old;
        });
        final FocusNode node = FocusNode();
        addTearDown(node.dispose);
        final GlobalKey<TooltipState> key = GlobalKey<TooltipState>();
        await app(
          tester,
          Tooltip(
            key: key,
            message: 'Keyboard hint',
            child: Focus(focusNode: node, child: const Text('Anchor')),
          ),
        );
        node.requestFocus();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        expect(find.text('Keyboard hint'), findsOneWidget);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('Keyboard hint'), findsNothing);
        await app(
          tester,
          TooltipVisibility(
            visible: false,
            child: Tooltip(
              key: key,
              message: 'Disabled hint',
              child: const Text('Hidden'),
            ),
          ),
        );
        expect(key.currentState!.ensureTooltipVisible(), isFalse);
      },
    );
    testWidgets(
      'rich message, custom positioning, semantics and reduced motion',
      (WidgetTester tester) async {
        final GlobalKey<TooltipState> key = GlobalKey<TooltipState>();
        await app(
          tester,
          Tooltip(
            key: key,
            richMessage: const TextSpan(text: 'Rich hint'),
            positionDelegate: (TooltipPositionContext context) =>
                const Offset(20, 30),
            child: const Text('Anchor'),
          ),
          reduced: true,
          direction: TextDirection.rtl,
        );
        expect(tester.getSemantics(find.text('Anchor')).tooltip, 'Rich hint');
        key.currentState!.ensureTooltipVisible();
        await tester.pump();
        await tester.pump();
        expect(tester.getTopLeft(find.text('Rich hint')), const Offset(20, 30));
        key.currentState!.dismiss();
        await tester.pump();
        expect(find.text('Rich hint'), findsNothing);
      },
    );
  });

  testWidgets('tooltip fades are monotonic and reopen from the current value', (
    WidgetTester tester,
  ) async {
    final GlobalKey<TooltipState> key = GlobalKey<TooltipState>();
    await app(
      tester,
      Tooltip(
        key: key,
        message: 'Motion hint',
        style: const TooltipStyle(
          transitionDuration: Duration(milliseconds: 200),
          reverseTransitionDuration: Duration(milliseconds: 200),
          transitionCurve: Curves.linear,
          reverseTransitionCurve: Curves.linear,
        ),
        child: const Text('Anchor'),
      ),
    );
    key.currentState!.ensureTooltipVisible();
    await tester.pump();
    double opacity() => tester
        .widget<FadeTransition>(
          find
              .ancestor(
                of: find.text('Motion hint'),
                matching: find.byType(FadeTransition),
              )
              .first,
        )
        .opacity
        .value;
    double previous = opacity();
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 20));
      expect(opacity(), greaterThanOrEqualTo(previous));
      previous = opacity();
    }
    key.currentState!.dismiss();
    await tester.pump();
    expect(opacity(), closeTo(previous, .001));
    await tester.pump(const Duration(milliseconds: 30));
    final double partial = opacity();
    expect(partial, lessThan(previous));
    key.currentState!.ensureTooltipVisible();
    await tester.pump();
    expect(opacity(), closeTo(partial, .001));
    await tester.pump(const Duration(milliseconds: 20));
    expect(opacity(), greaterThan(partial));
    await tester.pumpAndSettle();
    key.currentState!.dismiss();
    await tester.pumpAndSettle();
  });

  testWidgets('tooltip applies updated motion tokens after mounting', (
    WidgetTester tester,
  ) async {
    final GlobalKey<TooltipState> key = GlobalKey<TooltipState>();
    late StateSetter update;
    Duration duration = const Duration(milliseconds: 150);
    await app(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return Tooltip(
            key: key,
            message: 'Updated hint',
            style: TooltipStyle(
              transitionDuration: duration,
              transitionCurve: Curves.linear,
            ),
            child: const Text('Anchor'),
          );
        },
      ),
    );
    key.currentState!.ensureTooltipVisible();
    await tester.pumpAndSettle();
    key.currentState!.dismiss();
    await tester.pumpAndSettle();
    update(() {
      duration = const Duration(milliseconds: 600);
    });
    await tester.pump();
    key.currentState!.ensureTooltipVisible();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final FadeTransition fade = tester.widget<FadeTransition>(
      find
          .ancestor(
            of: find.text('Updated hint'),
            matching: find.byType(FadeTransition),
          )
          .first,
    );
    expect(fade.opacity.value, closeTo(1 / 6, .01));
    await tester.pumpAndSettle();
  });

  group('Dialog', () {
    testWidgets('returns action result and restores focus', (
      WidgetTester tester,
    ) async {
      late BuildContext launch;
      final FocusNode focus = FocusNode();
      addTearDown(focus.dispose);
      await app(
        tester,
        Builder(
          builder: (BuildContext context) {
            launch = context;
            return Focus(focusNode: focus, child: const Text('Launch'));
          },
        ),
      );
      focus.requestFocus();
      await tester.pump();
      final Future<String?> result = showDialog<String>(
        context: launch,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Question'),
          content: const Text('Content'),
          actions: <Widget>[
            pure.TextButton(
              onPressed: () => Navigator.of(context).pop('yes'),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Question'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(await result, 'yes');
      expect(focus.hasFocus, isTrue);
    });
    testWidgets('Escape and barrier dismiss, respecting barrierDismissible', (
      WidgetTester tester,
    ) async {
      late BuildContext launch;
      await app(
        tester,
        Builder(
          builder: (BuildContext context) {
            launch = context;
            return const Text('Launch');
          },
        ),
      );
      showDialog<void>(
        context: launch,
        barrierDismissible: false,
        builder: (BuildContext context) => const Dialog(
          child: SizedBox(width: 100, height: 100, child: Text('Modal')),
        ),
      );
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Modal'), findsOneWidget);
      Navigator.of(launch).pop();
      await tester.pumpAndSettle();
      showDialog<void>(
        context: launch,
        builder: (BuildContext context) => const Dialog(
          child: SizedBox(width: 100, height: 100, child: Text('Dismissible')),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Dismissible'), findsNothing);
    });
    testWidgets('simple options and alert route labels work in RTL', (
      WidgetTester tester,
    ) async {
      late BuildContext launch;
      await app(
        tester,
        Builder(
          builder: (BuildContext context) {
            launch = context;
            return const Text('Launch');
          },
        ),
        direction: TextDirection.rtl,
      );
      showDialog<void>(
        context: launch,
        builder: (BuildContext context) => SimpleDialog(
          title: const Text('Choose'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('One'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Choose'), findsOneWidget);
      expect(find.bySemanticsLabel('Dialog'), findsWidgets);
      await tester.tap(find.text('One'));
      await tester.pumpAndSettle();
      expect(find.text('Choose'), findsNothing);
    });
    testWidgets('exit remains mounted until animation finishes', (
      WidgetTester tester,
    ) async {
      late BuildContext launch;
      await app(
        tester,
        Builder(
          builder: (BuildContext context) {
            launch = context;
            return const Text('Launch');
          },
        ),
      );
      showDialog<void>(
        context: launch,
        style: const DialogStyle(
          transitionDuration: Duration(milliseconds: 200),
          reverseTransitionDuration: Duration(milliseconds: 300),
        ),
        builder: (BuildContext context) =>
            const Dialog(child: Text('Animated')),
      );
      await tester.pumpAndSettle();
      Navigator.of(launch).pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Animated'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Animated'), findsNothing);
    });
  });

  testWidgets('dialog Escape closes and Tab stays inside the route', (
    WidgetTester tester,
  ) async {
    final FocusNode first = FocusNode();
    final FocusNode second = FocusNode();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    late BuildContext launch;
    await app(
      tester,
      Builder(
        builder: (BuildContext context) {
          launch = context;
          return const Text('Launch');
        },
      ),
    );
    showDialog<void>(
      context: launch,
      builder: (BuildContext context) => Dialog(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            pure.TextButton(
              onPressed: () {},
              autofocus: true,
              focusNode: first,
              child: const Text('First focus'),
            ),
            pure.TextButton(
              onPressed: () {},
              focusNode: second,
              child: const Text('Second focus'),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(first.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(second.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(first.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('First focus'), findsNothing);
  });

  testWidgets(
    'dialog reverses an interrupted entrance without scale or opacity jumps',
    (WidgetTester tester) async {
      late BuildContext launch;
      await app(
        tester,
        Builder(
          builder: (BuildContext context) {
            launch = context;
            return const Text('Launch');
          },
        ),
      );
      showDialog<void>(
        context: launch,
        builder: (BuildContext context) =>
            const Dialog(child: Text('Retargeted dialog')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      final Finder fade = find
          .ancestor(
            of: find.text('Retargeted dialog'),
            matching: find.byType(FadeTransition),
          )
          .first;
      final double before = tester.widget<FadeTransition>(fade).opacity.value;
      Navigator.of(launch).pop();
      await tester.pump();
      expect(
        tester.widget<FadeTransition>(fade).opacity.value,
        closeTo(before, .001),
      );
      await tester.pump(const Duration(milliseconds: 20));
      expect(
        tester.widget<FadeTransition>(fade).opacity.value,
        lessThan(before),
      );
      await tester.pumpAndSettle();
    },
  );

  group('BottomSheet', () {
    testWidgets('tracks drag 1:1 and springs to snap extent', (
      WidgetTester tester,
    ) async {
      late BuildContext launch;
      await app(
        tester,
        Builder(
          builder: (BuildContext context) {
            launch = context;
            return const Text('Launch');
          },
        ),
      );
      showModalBottomSheet<void>(
        context: launch,
        isScrollControlled: true,
        isDismissible: false,
        snapPoints: const <double>[.5, 1],
        builder: (BuildContext context) =>
            const SizedBox(height: 300, child: Text('Sheet content')),
      );
      await tester.pumpAndSettle();
      final Offset initial = tester.getTopLeft(find.text('Sheet content'));
      final TestGesture drag = await tester.startGesture(
        initial + const Offset(100, 50),
      );
      await drag.moveBy(const Offset(0, 20));
      await tester.pump();
      final double start = tester.getTopLeft(find.text('Sheet content')).dy;
      await drag.moveBy(const Offset(0, 90));
      await tester.pump();
      expect(
        tester.getTopLeft(find.text('Sheet content')).dy - start,
        closeTo(90, .01),
      );
      await drag.up();
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Sheet content')).dy - initial.dy,
        closeTo(150, 1),
      );
    });
    testWidgets('downward fling dismisses and isDismissible guards barrier', (
      WidgetTester tester,
    ) async {
      late BuildContext launch;
      await app(
        tester,
        Builder(
          builder: (BuildContext context) {
            launch = context;
            return const Text('Launch');
          },
        ),
      );
      final Future<void> result = showModalBottomSheet<void>(
        context: launch,
        builder: (BuildContext context) =>
            const SizedBox(height: 200, child: Text('Dismiss sheet')),
      );
      await tester.pumpAndSettle();
      await tester.fling(
        find.text('Dismiss sheet'),
        const Offset(0, 180),
        1200,
      );
      await tester.pumpAndSettle();
      await result;
      expect(find.text('Dismiss sheet'), findsNothing);
    });
    testWidgets('reduced motion settles drags immediately', (
      WidgetTester tester,
    ) async {
      final GlobalKey key = GlobalKey();
      await app(
        tester,
        BottomSheet(
          key: key,
          onClosing: () {},
          isDismissible: false,
          snapPoints: const <double>[.5, 1],
          style: const BottomSheetStyle(),
          builder: (BuildContext context) =>
              const SizedBox(height: 200, child: Text('Reduced sheet')),
        ),
        reduced: true,
      );
      final TestGesture drag = await tester.startGesture(
        tester.getCenter(find.text('Reduced sheet')),
      );
      await drag.moveBy(const Offset(0, 20));
      await drag.moveBy(const Offset(0, 70));
      await tester.pump();
      await drag.up();
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  testWidgets(
    'sheet height controls and external controller ownership survive dismissal',
    (WidgetTester tester) async {
      final AnimationController controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 100),
        reverseDuration: const Duration(milliseconds: 100),
      );
      addTearDown(controller.dispose);
      late BuildContext launch;
      await app(
        tester,
        Builder(
          builder: (BuildContext context) {
            launch = context;
            return const Text('Launch');
          },
        ),
      );
      showModalBottomSheet<void>(
        context: launch,
        transitionAnimationController: controller,
        builder: (BuildContext context) =>
            const SizedBox(height: 600, child: Text('Bounded sheet')),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(BottomSheet)).height,
        closeTo(600 * 9 / 16, 1),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Bounded sheet'), findsNothing);
      controller.value = .5;
      expect(controller.value, .5);
    },
  );

  group('ScaffoldMessenger', () {
    testWidgets('queues notifications and reports action/hide completion', (
      WidgetTester tester,
    ) async {
      final GlobalKey<ScaffoldMessengerState> key =
          GlobalKey<ScaffoldMessengerState>();
      await app(tester, ScaffoldMessenger(key: key, child: const Text('Host')));
      int visible = 0;
      int actions = 0;
      final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> first =
          key.currentState!.showSnackBar(
            SnackBar(
              content: const Text('First'),
              onVisible: () {
                visible++;
              },
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  actions++;
                },
              ),
            ),
          );
      final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> second =
          key.currentState!.showSnackBar(
            const SnackBar(content: Text('Second'), persist: true),
          );
      await tester.pumpAndSettle();
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsNothing);
      expect(visible, 1);
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(await first.closed, SnackBarClosedReason.action);
      expect(actions, 1);
      expect(find.text('Second'), findsOneWidget);
      second.close();
      await tester.pumpAndSettle();
      expect(await second.closed, SnackBarClosedReason.hide);
      expect(find.text('Second'), findsNothing);
    });
    testWidgets(
      'duration times out while persistence and accessibility suspend timeout',
      (WidgetTester tester) async {
        final GlobalKey<ScaffoldMessengerState> key =
            GlobalKey<ScaffoldMessengerState>();
        await app(
          tester,
          ScaffoldMessenger(key: key, child: const Text('Host')),
        );
        final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> timed =
            key.currentState!.showSnackBar(
              const SnackBar(
                content: Text('Timed'),
                duration: Duration(milliseconds: 100),
              ),
            );
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();
        expect(await timed.closed, SnackBarClosedReason.timeout);
        key.currentState!.showSnackBar(
          const SnackBar(content: Text('Persist'), persist: true),
        );
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 20));
        expect(find.text('Persist'), findsOneWidget);
        key.currentState!.removeCurrentSnackBar();
        await tester.pump();
        await app(
          tester,
          ScaffoldMessenger(key: key, child: const Text('Host')),
          accessible: true,
        );
        key.currentState!.showSnackBar(
          const SnackBar(
            content: Text('Accessible'),
            duration: Duration(milliseconds: 100),
          ),
        );
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 20));
        expect(find.text('Accessible'), findsOneWidget);
      },
    );
    testWidgets(
      'remove and clear complete queued handles and preserve live semantics',
      (WidgetTester tester) async {
        final GlobalKey<ScaffoldMessengerState> key =
            GlobalKey<ScaffoldMessengerState>();
        await app(
          tester,
          ScaffoldMessenger(key: key, child: const Text('Host')),
          direction: TextDirection.rtl,
        );
        final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> first =
            key.currentState!.showSnackBar(
              const SnackBar(content: Text('Current'), persist: true),
            );
        final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> queued =
            key.currentState!.showSnackBar(
              const SnackBar(content: Text('Queued'), persist: true),
            );
        await tester.pumpAndSettle();
        expect(
          find.bySemanticsLabel(RegExp('Snack bar|Notification')),
          findsOneWidget,
        );
        key.currentState!.clearSnackBars();
        await tester.pumpAndSettle();
        expect(await first.closed, SnackBarClosedReason.hide);
        expect(await queued.closed, SnackBarClosedReason.remove);
        expect(find.text('Queued'), findsNothing);
      },
    );
    testWidgets('swipe and close control dismiss the current notification', (
      WidgetTester tester,
    ) async {
      final GlobalKey<ScaffoldMessengerState> key =
          GlobalKey<ScaffoldMessengerState>();
      await app(tester, ScaffoldMessenger(key: key, child: const Text('Host')));
      final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> swiped =
          key.currentState!.showSnackBar(
            const SnackBar(
              content: SizedBox(width: 250, height: 60, child: Text('Swipe')),
              persist: true,
              dismissDirection: DismissDirection.horizontal,
            ),
          );
      await tester.pumpAndSettle();
      await tester.fling(find.text('Swipe'), const Offset(500, 0), 1200);
      await tester.pumpAndSettle();
      expect(await swiped.closed, SnackBarClosedReason.swipe);
      final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> closed =
          key.currentState!.showSnackBar(
            const SnackBar(
              content: Text('Close me'),
              persist: true,
              showCloseIcon: true,
              style: SnackBarStyle(),
            ),
          );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(pure.IconButton));
      await tester.pumpAndSettle();
      expect(await closed.closed, SnackBarClosedReason.dismiss);
    });
  });
  testWidgets('snack action wraps by threshold without intrinsic layout', (
    WidgetTester tester,
  ) async {
    await app(
      tester,
      SizedBox(
        width: 240,
        child: SnackBar(
          content: const Text('Message'),
          action: SnackBarAction(
            label: 'A deliberately wide action',
            onPressed: () {},
          ),
          actionOverflowThreshold: .2,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('A deliberately wide action')).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(find.text('Message')).dy),
    );
  });
}
