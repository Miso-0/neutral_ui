import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('keyboard pressed timeout runs while tickers are muted', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    InteractionState state = const InteractionState();
    await pumpNeutral(
      tester,
      TickerMode(
        enabled: false,
        child: InteractionDetector(
          focusNode: node,
          onTap: () {},
          builder: (BuildContext context, InteractionState current) {
            state = current;
            return const SizedBox(width: 100, height: 100);
          },
        ),
      ),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(state.isPressed, isTrue);
    await tester.pump(const Duration(milliseconds: 101));
    expect(state.isPressed, isFalse);
  });

  testWidgets('tap, long press and cancellation update pressed state', (
    WidgetTester tester,
  ) async {
    InteractionState state = const InteractionState();
    int taps = 0;
    int longs = 0;
    await pumpNeutral(
      tester,
      InteractionDetector(
        onTap: () {
          taps++;
        },
        onLongPress: () {
          longs++;
        },
        builder: (BuildContext context, InteractionState current) {
          state = current;
          return const SizedBox(width: 100, height: 100);
        },
      ),
    );
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byType(InteractionDetector)),
    );
    await tester.pump(const Duration(milliseconds: 150));
    expect(state.isPressed, isTrue);
    await tester.pump(const Duration(milliseconds: 500));
    expect(longs, 1);
    expect(state.isPressed, isTrue);
    await gesture.up();
    await tester.pump();
    expect(state.isPressed, isFalse);
    expect(taps, 0);
    await tester.tap(find.byType(InteractionDetector));
    await tester.pump();
    expect(taps, 1);
    final TestGesture cancel = await tester.startGesture(
      tester.getCenter(find.byType(InteractionDetector)),
    );
    await tester.pump(const Duration(milliseconds: 150));
    await cancel.cancel();
    await tester.pump();
    expect(state.isPressed, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard activation flashes pressed and disposal cancels it', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    InteractionState state = const InteractionState();
    int taps = 0;
    await pumpNeutral(
      tester,
      InteractionDetector(
        focusNode: node,
        onTap: () {
          taps++;
        },
        builder: (BuildContext context, InteractionState current) {
          state = current;
          return const SizedBox(width: 100, height: 100);
        },
      ),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(state.isFocused, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 1);
    expect(state.isPressed, isTrue);
    await tester.pump(const Duration(milliseconds: 110));
    expect(state.isPressed, isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(taps, 2);
    await pumpNeutral(tester, const SizedBox());
    await tester.pump(const Duration(milliseconds: 150));
    expect(tester.takeException(), isNull);
  });

  testWidgets('hover disable and controller swap synchronize state', (
    WidgetTester tester,
  ) async {
    final WidgetStatesController first = WidgetStatesController();
    final WidgetStatesController second = WidgetStatesController(<WidgetState>{
      WidgetState.selected,
    });
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    bool enabled = true;
    WidgetStatesController current = first;
    late StateSetter rebuild;
    InteractionState state = const InteractionState();
    final List<bool> hoverEvents = <bool>[];
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setter) {
          rebuild = setter;
          return InteractionDetector(
            enabled: enabled,
            statesController: current,
            onHover: hoverEvents.add,
            onTap: () {},
            builder: (BuildContext context, InteractionState value) {
              state = value;
              return const SizedBox(width: 100, height: 100);
            },
          );
        },
      ),
    );
    final TestGesture mouse = await hover(
      tester,
      find.byType(InteractionDetector),
    );
    expect(state.isHovered, isTrue);
    expect(first.value, contains(WidgetState.hovered));
    first.update(WidgetState.selected, true);
    await tester.pump();
    expect(state.isSelected, isTrue);
    rebuild(() {
      enabled = false;
      current = second;
    });
    await tester.pump();
    expect(state.isDisabled, isTrue);
    expect(state.isHovered, isFalse);
    expect(second.value, contains(WidgetState.disabled));
    expect(hoverEvents, <bool>[true, false]);
    await mouse.removePointer();
  });

  testWidgets('drag state and disable mid press clear immediately', (
    WidgetTester tester,
  ) async {
    bool enabled = true;
    late StateSetter rebuild;
    InteractionState state = const InteractionState();
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setter) {
          rebuild = setter;
          return InteractionDetector(
            enabled: enabled,
            onTap: () {},
            onHorizontalDragUpdate: (DragUpdateDetails details) {},
            builder: (BuildContext context, InteractionState value) {
              state = value;
              return const SizedBox(width: 200, height: 100);
            },
          );
        },
      ),
    );
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byType(InteractionDetector)),
    );
    await gesture.moveBy(const Offset(50, 0));
    await tester.pump();
    expect(state.isDragged, isTrue);
    rebuild(() {
      enabled = false;
    });
    await tester.pump();
    expect(state.isDragged, isFalse);
    expect(state.isPressed, isFalse);
    await gesture.up();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('repeated keyboard activation restarts the pressed timeout', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    InteractionState state = const InteractionState();
    int taps = 0;
    await pumpNeutral(
      tester,
      InteractionDetector(
        focusNode: node,
        onTap: () => taps++,
        builder: (BuildContext context, InteractionState current) {
          state = current;
          return const SizedBox(width: 100, height: 100);
        },
      ),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 70));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(taps, 2);
    expect(state.isPressed, isTrue);
    await tester.pump(const Duration(milliseconds: 61));
    expect(state.isPressed, isFalse);
  });

  testWidgets('disabling cancels keyboard pressed state before timeout', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    bool enabled = true;
    late StateSetter rebuild;
    InteractionState state = const InteractionState();
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setter) {
          rebuild = setter;
          return InteractionDetector(
            focusNode: node,
            enabled: enabled,
            onTap: () {},
            builder: (BuildContext context, InteractionState current) {
              state = current;
              return const SizedBox(width: 100, height: 100);
            },
          );
        },
      ),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(state.isPressed, isTrue);
    rebuild(() => enabled = false);
    await tester.pump();
    expect(state.isPressed, isFalse);
    expect(state.isDisabled, isTrue);
    await tester.pump(const Duration(milliseconds: 110));
    expect(state.isPressed, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'raw focus remains while focus visibility follows highlight mode',
    (WidgetTester tester) async {
      useTraditionalFocus();
      final FocusNode node = FocusNode();
      addTearDown(node.dispose);
      final List<bool> focusEvents = <bool>[];
      InteractionState state = const InteractionState();
      await pumpNeutral(
        tester,
        InteractionDetector(
          focusNode: node,
          onTap: () {},
          onFocusChange: focusEvents.add,
          builder: (BuildContext context, InteractionState current) {
            state = current;
            return const SizedBox(width: 100, height: 100);
          },
        ),
      );
      node.requestFocus();
      await tester.pumpAndSettle();
      expect(state.isFocused, isTrue);
      expect(focusEvents, <bool>[true]);
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      await tester.pump();
      expect(node.hasFocus, isTrue);
      expect(state.isFocused, isFalse);
      expect(focusEvents, <bool>[true]);
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      await tester.pump();
      expect(state.isFocused, isTrue);
      node.unfocus();
      await tester.pumpAndSettle();
      expect(focusEvents, <bool>[true, false]);
    },
  );

  testWidgets('disabled controls may receive visible directional focus only', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    InteractionState state = const InteractionState();
    await pumpNeutral(
      tester,
      MediaQuery(
        data: const MediaQueryData(navigationMode: NavigationMode.directional),
        child: InteractionDetector(
          enabled: false,
          focusNode: node,
          onTap: () {},
          builder: (BuildContext context, InteractionState current) {
            state = current;
            return const SizedBox(width: 100, height: 100);
          },
        ),
      ),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(node.hasFocus, isTrue);
    expect(state.isFocused, isTrue);
    expect(state.isDisabled, isTrue);
    await pumpNeutral(
      tester,
      InteractionDetector(
        enabled: false,
        focusNode: node,
        onTap: () {},
        builder: (BuildContext context, InteractionState current) {
          state = current;
          return const SizedBox(width: 100, height: 100);
        },
      ),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(node.canRequestFocus, isFalse);
    expect(state.isFocused, isFalse);
  });

  testWidgets(
    'hover notifications deduplicate across disabling and re-enabling',
    (WidgetTester tester) async {
      bool enabled = false;
      late StateSetter rebuild;
      final List<bool> hoverEvents = <bool>[];
      await pumpNeutral(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setter) {
            rebuild = setter;
            return InteractionDetector(
              enabled: enabled,
              onTap: () {},
              onHover: hoverEvents.add,
              builder: (BuildContext context, InteractionState current) =>
                  const SizedBox(width: 100, height: 100),
            );
          },
        ),
      );
      final TestGesture mouse = await hover(
        tester,
        find.byType(InteractionDetector),
      );
      expect(hoverEvents, isEmpty);
      rebuild(() => enabled = true);
      await tester.pump();
      expect(hoverEvents, <bool>[true]);
      await mouse.moveBy(const Offset(1, 1));
      await tester.pump();
      expect(hoverEvents, <bool>[true]);
      rebuild(() => enabled = false);
      await tester.pump();
      expect(hoverEvents, <bool>[true, false]);
      await mouse.removePointer();
      await tester.pump();
      expect(hoverEvents, <bool>[true, false]);
    },
  );

  testWidgets(
    'cursor resolves interaction state with click and basic fallbacks',
    (WidgetTester tester) async {
      bool enabled = true;
      bool styled = false;
      late StateSetter rebuild;
      MouseCursor cursor() => tester
          .widget<MouseRegion>(
            find.descendant(
              of: find.byType(InteractionDetector),
              matching: find.byType(MouseRegion),
            ),
          )
          .cursor;
      await pumpNeutral(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setter) {
            rebuild = setter;
            return InteractionDetector(
              enabled: enabled,
              onTap: () {},
              mouseCursor: styled
                  ? StateProperty<MouseCursor?>.resolveWith(
                      (InteractionState state) =>
                          state.isHovered ? SystemMouseCursors.precise : null,
                    )
                  : null,
              builder: (BuildContext context, InteractionState current) =>
                  const SizedBox(width: 100, height: 100),
            );
          },
        ),
      );
      expect(cursor(), SystemMouseCursors.click);
      rebuild(() => styled = true);
      await tester.pump();
      expect(cursor(), SystemMouseCursors.click);
      final TestGesture mouse = await hover(
        tester,
        find.byType(InteractionDetector),
      );
      expect(cursor(), SystemMouseCursors.precise);
      rebuild(() => enabled = false);
      await tester.pump();
      expect(cursor(), SystemMouseCursors.basic);
      await mouse.removePointer();
    },
  );

  testWidgets(
    'controller swaps detach the old listener and preserve selection',
    (WidgetTester tester) async {
      final WidgetStatesController first = WidgetStatesController();
      final WidgetStatesController second = WidgetStatesController();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      WidgetStatesController controller = first;
      late StateSetter rebuild;
      int builds = 0;
      InteractionState state = const InteractionState();
      await pumpNeutral(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setter) {
            rebuild = setter;
            return InteractionDetector(
              statesController: controller,
              onTap: () {},
              builder: (BuildContext context, InteractionState current) {
                builds++;
                state = current;
                return const SizedBox(width: 100, height: 100);
              },
            );
          },
        ),
      );
      first.update(WidgetState.selected, true);
      await tester.pump();
      expect(state.isSelected, isTrue);
      rebuild(() => controller = second);
      await tester.pump();
      expect(state.isSelected, isFalse);
      final int buildsAfterSwap = builds;
      first.update(WidgetState.selected, false);
      await tester.pump();
      expect(builds, buildsAfterSwap);
      second.update(WidgetState.selected, true);
      await tester.pump();
      expect(state.isSelected, isTrue);
    },
  );

  testWidgets(
    'custom intent actions win and disabled activation shadows ancestors',
    (WidgetTester tester) async {
      late BuildContext actionContext;
      int taps = 0;
      int customActivations = 0;
      int ancestorActivations = 0;
      await pumpNeutral(
        tester,
        InteractionDetector(
          onTap: () => taps++,
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent intent) {
                customActivations++;
                return null;
              },
            ),
          },
          builder: (BuildContext context, InteractionState current) {
            actionContext = context;
            return const SizedBox(width: 100, height: 100);
          },
        ),
      );
      Actions.invoke<ActivateIntent>(actionContext, const ActivateIntent());
      expect(customActivations, 1);
      expect(taps, 0);
      await pumpNeutral(
        tester,
        Actions(
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent intent) {
                ancestorActivations++;
                return null;
              },
            ),
          },
          child: InteractionDetector(
            enabled: false,
            onTap: () => taps++,
            builder: (BuildContext context, InteractionState current) {
              actionContext = context;
              return const SizedBox(width: 100, height: 100);
            },
          ),
        ),
      );
      Actions.maybeInvoke<ActivateIntent>(
        actionContext,
        const ActivateIntent(),
      );
      expect(ancestorActivations, 0);
      expect(taps, 0);
    },
  );

  testWidgets('drag gesture semantics do not leak scrolling actions', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await pumpNeutral(
      tester,
      InteractionDetector(
        onTap: () {},
        onHorizontalDragUpdate: (DragUpdateDetails details) {},
        builder: (BuildContext context, InteractionState current) =>
            const SizedBox(width: 100, height: 100),
      ),
    );
    expect(
      tester.getSemantics(find.byType(InteractionDetector)),
      matchesSemantics(
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    await pumpNeutral(
      tester,
      InteractionDetector(
        excludeFromSemantics: true,
        onTap: () {},
        onLongPress: () {},
        onHorizontalDragUpdate: (DragUpdateDetails details) {},
        builder: (BuildContext context, InteractionState current) =>
            const SizedBox(width: 100, height: 100),
      ),
    );
    expect(
      tester.getSemantics(find.byType(InteractionDetector)),
      matchesSemantics(isFocusable: true, hasFocusAction: true),
    );
    semantics.dispose();
  });

  testWidgets('pointer cancellation cancels an accepted drag exactly once', (
    WidgetTester tester,
  ) async {
    InteractionState state = const InteractionState();
    final List<String> events = <String>[];
    await pumpNeutral(
      tester,
      InteractionDetector(
        onTap: () {},
        onHorizontalDragStart: (DragStartDetails details) =>
            events.add('start'),
        onHorizontalDragUpdate: (DragUpdateDetails details) {},
        onHorizontalDragEnd: (DragEndDetails details) => events.add('end'),
        onHorizontalDragCancel: () => events.add('cancel'),
        builder: (BuildContext context, InteractionState current) {
          state = current;
          return const SizedBox(width: 200, height: 100);
        },
      ),
    );
    final Offset center = tester.getCenter(find.byType(InteractionDetector));
    final TestGesture canceled = await tester.startGesture(center);
    await canceled.moveBy(const Offset(50, 0));
    await tester.pump();
    expect(state.isDragged, isTrue);
    await canceled.cancel();
    await tester.pump();
    expect(state.isDragged, isFalse);
    expect(events, <String>['start', 'cancel']);
    final TestGesture completed = await tester.startGesture(center);
    await completed.moveBy(const Offset(50, 0));
    await tester.pump();
    await completed.up();
    await tester.pump();
    expect(events, <String>['start', 'cancel', 'start', 'end']);
  });

  testWidgets('canceling a secondary pointer preserves the active drag', (
    WidgetTester tester,
  ) async {
    int cancellations = 0;
    int ends = 0;
    InteractionState state = const InteractionState();
    await pumpNeutral(
      tester,
      InteractionDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {},
        onHorizontalDragEnd: (DragEndDetails details) => ends++,
        onHorizontalDragCancel: () => cancellations++,
        builder: (BuildContext context, InteractionState current) {
          state = current;
          return const SizedBox(width: 200, height: 100);
        },
      ),
    );
    final Offset center = tester.getCenter(find.byType(InteractionDetector));
    final TestGesture primary = await tester.startGesture(center, pointer: 1);
    await primary.moveBy(const Offset(50, 0));
    await tester.pump();
    final TestGesture secondary = await tester.startGesture(center, pointer: 2);
    await secondary.cancel();
    await tester.pump();
    expect(state.isDragged, isTrue);
    expect(cancellations, 0);
    await primary.up();
    await tester.pump();
    expect(ends, 1);
    expect(state.isDragged, isFalse);
  });

  testWidgets('disabling pending recognizers does not set state during build', (
    WidgetTester tester,
  ) async {
    bool enabled = true;
    late StateSetter rebuild;
    InteractionState state = const InteractionState();
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setter) {
          rebuild = setter;
          return InteractionDetector(
            enabled: enabled,
            onTap: () {},
            onLongPress: () {},
            onHorizontalDragUpdate: (DragUpdateDetails details) {},
            builder: (BuildContext context, InteractionState current) {
              state = current;
              return const SizedBox(width: 100, height: 100);
            },
          );
        },
      ),
    );
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byType(InteractionDetector)),
    );
    await tester.pump(const Duration(milliseconds: 150));
    expect(state.isPressed, isTrue);
    rebuild(() => enabled = false);
    await tester.pump();
    expect(state.isPressed, isFalse);
    expect(state.isDragged, isFalse);
    expect(tester.takeException(), isNull);
    await gesture.cancel();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('removing gesture callbacks cancels state without build errors', (
    WidgetTester tester,
  ) async {
    bool gesturesEnabled = true;
    late StateSetter rebuild;
    InteractionState state = const InteractionState();
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setter) {
          rebuild = setter;
          return InteractionDetector(
            onTap: gesturesEnabled ? () {} : null,
            onHorizontalDragUpdate: gesturesEnabled
                ? (DragUpdateDetails details) {}
                : null,
            builder: (BuildContext context, InteractionState current) {
              state = current;
              return const SizedBox(width: 100, height: 100);
            },
          );
        },
      ),
    );
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byType(InteractionDetector)),
    );
    await tester.pump(const Duration(milliseconds: 150));
    rebuild(() => gesturesEnabled = false);
    await tester.pump();
    expect(state.isPressed, isFalse);
    expect(state.isDragged, isFalse);
    expect(tester.takeException(), isNull);
    await gesture.cancel();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('disposing during keyboard flash leaves no pending timeout', (
    WidgetTester tester,
  ) async {
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    await pumpNeutral(
      tester,
      InteractionDetector(
        focusNode: node,
        onTap: () {},
        builder: (BuildContext context, InteractionState current) =>
            const SizedBox(width: 100, height: 100),
      ),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await pumpNeutral(tester, const SizedBox());
    expect(tester.takeException(), isNull);
  });
}
