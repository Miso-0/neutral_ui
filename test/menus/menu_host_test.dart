import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/menus/menu_host.dart';
import 'package:pure_ui/src/menus/menu_item_button.dart';
import 'package:pure_ui/src/menus/menu_panel.dart';

import '../helpers/pump.dart';

class _Host extends StatefulWidget {
  const _Host({
    super.key,
    this.controller,
    this.focusNode,
    this.optionFocusNode,
    this.style = const MenuStyle(),
    this.label = 'Open',
    this.children,
  });

  final MenuController? controller;
  final FocusNode? focusNode;
  final FocusNode? optionFocusNode;
  final MenuStyle style;
  final String label;
  final List<Widget>? children;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host>
    with TickerProviderStateMixin, MenuHost<_Host> {
  @override
  void initState() {
    super.initState();
    initMenuHost(controller: widget.controller, focusNode: widget.focusNode);
  }

  @override
  void didUpdateWidget(_Host oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateMenuHost(controller: widget.controller, focusNode: widget.focusNode);
  }

  @override
  Widget build(BuildContext context) => buildMenuHost(
    style: widget.style,
    child: ElevatedButton(
      focusNode: anchorFocusNode,
      onPressed: toggleMenu,
      child: Text(widget.label),
    ),
    children:
        widget.children ??
        <Widget>[
          MenuItemButton(
            onPressed: closeMenu,
            focusNode: widget.optionFocusNode,
            child: const Text('Option'),
          ),
        ],
  );
}

class _ZeroIntrinsicProbe extends LeafRenderObjectWidget {
  const _ZeroIntrinsicProbe({required this.onIntrinsicWidth});

  final VoidCallback onIntrinsicWidth;

  @override
  RenderBox createRenderObject(BuildContext context) =>
      _RenderZeroIntrinsicProbe(onIntrinsicWidth);
}

class _RenderZeroIntrinsicProbe extends RenderBox {
  _RenderZeroIntrinsicProbe(this.onIntrinsicWidth);

  final VoidCallback onIntrinsicWidth;

  @override
  double computeMaxIntrinsicWidth(double height) {
    onIntrinsicWidth();
    return 0;
  }

  @override
  void performLayout() => size = constraints.constrain(const Size(20, 1));
}

void main() {
  testWidgets(
    'removing an external controller creates an internal controller',
    (WidgetTester tester) async {
      final MenuController external = MenuController();
      MenuController? controller = external;
      final GlobalKey<_HostState> key = GlobalKey<_HostState>();
      late StateSetter update;
      await pumpPure(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            update = setState;
            return _Host(key: key, controller: controller);
          },
        ),
      );
      external.open();
      await tester.pumpAndSettle();
      expect(find.text('Option'), findsOneWidget);
      update(() => controller = null);
      await tester.pumpAndSettle();
      expect(key.currentState!.menuController, isNot(same(external)));
      expect(find.text('Option'), findsNothing);
      key.currentState!.openMenu();
      await tester.pumpAndSettle();
      expect(find.text('Option'), findsOneWidget);
    },
  );

  testWidgets('replacing external controllers detaches the old controller', (
    WidgetTester tester,
  ) async {
    final MenuController first = MenuController();
    final MenuController second = MenuController();
    MenuController controller = first;
    final GlobalKey<_HostState> key = GlobalKey<_HostState>();
    late StateSetter update;
    await pumpPure(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return _Host(key: key, controller: controller);
        },
      ),
    );
    first.open();
    await tester.pumpAndSettle();
    update(() => controller = second);
    await tester.pumpAndSettle();
    expect(key.currentState!.menuController, same(second));
    expect(first.isOpen, isFalse);
    second.open();
    await tester.pumpAndSettle();
    expect(find.text('Option'), findsOneWidget);
  });

  testWidgets('disposing during a reverse transition cancels pending work', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    await pumpPure(
      tester,
      _Host(
        controller: controller,
        style: const MenuStyle(transitionDuration: Duration(milliseconds: 100)),
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    controller.close();
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('external focus nodes survive replacing and disposing a host', (
    WidgetTester tester,
  ) async {
    final FocusNode external = FocusNode();
    addTearDown(external.dispose);
    FocusNode? focusNode = external;
    final GlobalKey<_HostState> key = GlobalKey<_HostState>();
    late StateSetter update;
    await pumpPure(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return _Host(key: key, focusNode: focusNode);
        },
      ),
    );
    update(() => focusNode = null);
    await tester.pumpAndSettle();
    expect(key.currentState!.anchorFocusNode, isNot(same(external)));
    await tester.pumpWidget(const SizedBox.shrink());
    void listener() {}
    expect(() => external.addListener(listener), returnsNormally);
    external.removeListener(listener);
  });

  testWidgets('global pointer routes exist only while menus are visible', (
    WidgetTester tester,
  ) async {
    final int routes =
        WidgetsBinding.instance.pointerRouter.debugGlobalRouteCount;
    final MenuController controller = MenuController();
    await pumpPure(tester, _Host(controller: controller));
    expect(WidgetsBinding.instance.pointerRouter.debugGlobalRouteCount, routes);
    controller.open();
    await tester.pumpAndSettle();
    expect(
      WidgetsBinding.instance.pointerRouter.debugGlobalRouteCount,
      routes + 1,
    );
    controller.close();
    await tester.pumpAndSettle();
    expect(WidgetsBinding.instance.pointerRouter.debugGlobalRouteCount, routes);
    controller.open();
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    expect(WidgetsBinding.instance.pointerRouter.debugGlobalRouteCount, routes);
  });

  testWidgets('nested panel taps keep their root menu open', (
    WidgetTester tester,
  ) async {
    final MenuController root = MenuController();
    final MenuController nested = MenuController();
    int selected = 0;
    await pumpPure(
      tester,
      _Host(
        controller: root,
        children: <Widget>[
          _Host(
            controller: nested,
            label: 'Nested',
            children: <Widget>[
              MenuItemButton(
                onPressed: () => selected++,
                child: const Text('Nested option'),
              ),
            ],
          ),
        ],
      ),
    );
    root.open();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nested'));
    await tester.pumpAndSettle();
    expect(nested.isOpen, isTrue);
    await tester.tap(find.text('Nested option'));
    await tester.pumpAndSettle();
    expect(selected, 1);
    expect(root.isOpen, isTrue);
    expect(nested.isOpen, isTrue);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(root.isOpen, isFalse);
    expect(nested.isOpen, isFalse);
  });

  testWidgets('focus moved during exit is preserved when closing finishes', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    final FocusNode other = FocusNode();
    final FocusNode option = FocusNode();
    addTearDown(other.dispose);
    addTearDown(option.dispose);
    await pumpPure(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            focusNode: other,
            onPressed: () {},
            child: const Text('Other'),
          ),
          _Host(controller: controller, optionFocusNode: option),
        ],
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    option.requestFocus();
    await tester.pump();
    expect(option.hasPrimaryFocus, isTrue);
    controller.close();
    await tester.pump(const Duration(milliseconds: 30));
    other.requestFocus();
    await tester.pumpAndSettle();
    expect(other.hasPrimaryFocus, isTrue);
    expect(controller.isOpen, isFalse);
  });

  testWidgets('focus still in the panel returns to its anchor after exit', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    final FocusNode anchor = FocusNode();
    final FocusNode option = FocusNode();
    addTearDown(anchor.dispose);
    addTearDown(option.dispose);
    await pumpPure(
      tester,
      _Host(controller: controller, focusNode: anchor, optionFocusNode: option),
    );
    controller.open();
    await tester.pumpAndSettle();
    option.requestFocus();
    await tester.pump();
    expect(option.hasPrimaryFocus, isTrue);
    controller.close();
    await tester.pump(const Duration(milliseconds: 30));
    expect(option.hasPrimaryFocus, isTrue);
    await tester.pumpAndSettle();
    expect(anchor.hasPrimaryFocus, isTrue);
  });

  testWidgets('consume outside taps dismisses without activating controls', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    int activated = 0;
    await pumpPure(
      tester,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => activated++,
            child: const Text('Other'),
          ),
          _Host(
            controller: controller,
            style: const MenuStyle(
              outsideTapBehavior: OutsideTapBehavior.consume,
            ),
          ),
        ],
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other'));
    await tester.pumpAndSettle();
    expect(controller.isOpen, isFalse);
    expect(activated, 0);
  });

  testWidgets('turning off the anchor ticker closes an open panel', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    bool enabled = true;
    late StateSetter update;
    await pumpPure(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return TickerMode(
            enabled: enabled,
            child: _Host(controller: controller),
          );
        },
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    update(() => enabled = false);
    await tester.pumpAndSettle();
    expect(controller.isOpen, isFalse);
    expect(find.text('Option'), findsNothing);
  });

  testWidgets('pushing a route dismisses the old route menu', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
    await pumpPureApp(
      tester,
      _Host(controller: controller),
      navigatorKey: navigator,
    );
    controller.open();
    await tester.pumpAndSettle();
    navigator.currentState!.push<void>(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => const Center(child: Text('Next route')),
      ),
    );
    await tester.pumpAndSettle();
    expect(controller.isOpen, isFalse);
    expect(find.text('Option'), findsNothing);
  });

  testWidgets('root overlay avoids a nested overlay width constraint', (
    WidgetTester tester,
  ) async {
    for (final OverlayLocation location in OverlayLocation.values) {
      final MenuController controller = MenuController();
      await pumpPure(
        tester,
        SizedBox(
          width: 100,
          height: 100,
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (BuildContext context) => Center(
                  child: _Host(
                    controller: controller,
                    style: MenuStyle(overlayLocation: location),
                    children: const <Widget>[SizedBox(width: 200, height: 20)],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      controller.open();
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byType(MenuPanel)).width,
        location == OverlayLocation.root ? 200 : 100,
      );
    }
  });

  testWidgets('default fade and scale are monotonic and reverse continuously', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    await pumpPure(tester, _Host(controller: controller));
    double opacity() => tester
        .widget<FadeTransition>(
          find
              .ancestor(
                of: find.byType(MenuPanel),
                matching: find.byType(FadeTransition),
              )
              .first,
        )
        .opacity
        .value;
    double scale() => tester
        .widget<ScaleTransition>(
          find
              .ancestor(
                of: find.byType(MenuPanel),
                matching: find.byType(ScaleTransition),
              )
              .first,
        )
        .scale
        .value;
    controller.open();
    await tester.pump();
    expect(opacity(), 0);
    expect(scale(), 0.96);
    final List<double> entering = await sampleValues(
      tester,
      opacity,
      duration: const Duration(milliseconds: 60),
    );
    expectMonotonicValues(entering, from: 0, to: 1);
    final double before = opacity();
    controller.close();
    await tester.pump();
    expect(opacity(), closeTo(before, 1e-8));
    await tester.pump(const Duration(milliseconds: 20));
    final double closing = opacity();
    expect(closing, lessThan(before));
    controller.open();
    await tester.pump();
    expect(opacity(), closeTo(closing, 1e-8));
    final List<double> reopened = await sampleValues(
      tester,
      opacity,
      duration: const Duration(milliseconds: 150),
    );
    expectMonotonicValues(reopened, from: closing, to: 1);
    expect(scale(), 1);
    expect(find.byType(IntrinsicWidth), findsNothing);
    controller.close();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 99));
    expect(controller.isOpen, isTrue);
    await tester.pump(const Duration(milliseconds: 2));
    expect(controller.isOpen, isFalse);
  });

  testWidgets('reduced motion opens and closes immediately', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    await pumpPureApp(
      tester,
      _Host(controller: controller),
      disableAnimations: true,
    );
    controller.open();
    await tester.pump();
    final FadeTransition fade = tester.widget<FadeTransition>(
      find
          .ancestor(
            of: find.byType(MenuPanel),
            matching: find.byType(FadeTransition),
          )
          .first,
    );
    expect(fade.opacity.value, 1);
    controller.close();
    await tester.pump();
    expect(find.text('Option'), findsNothing);
    expect(controller.isOpen, isFalse);
  });

  testWidgets('a parent waits for the longest nested closing transition', (
    WidgetTester tester,
  ) async {
    final MenuController parent = MenuController();
    final MenuController nested = MenuController();
    await pumpPure(
      tester,
      _Host(
        controller: parent,
        style: const MenuStyle(
          reverseTransitionDuration: Duration(milliseconds: 100),
        ),
        children: <Widget>[
          _Host(
            controller: nested,
            label: 'Nested',
            style: const MenuStyle(
              reverseTransitionDuration: Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
    parent.open();
    await tester.pumpAndSettle();
    nested.open();
    await tester.pumpAndSettle();
    parent.close();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    expect(parent.isOpen, isTrue);
    expect(nested.isOpen, isTrue);
    expect(find.text('Option'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(parent.isOpen, isFalse);
    expect(nested.isOpen, isFalse);
  });

  testWidgets('reverse duration and curve are independent motion tokens', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    Animation<double>? transition;
    await pumpPure(
      tester,
      _Host(
        controller: controller,
        style: MenuStyle(
          transitionCurve: Curves.linear,
          reverseTransitionCurve: Curves.easeInQuad,
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionBuilder: (_, Animation<double> animation, Widget child) {
            transition = animation;
            return child;
          },
        ),
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    controller.close();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(transition!.value, closeTo(Curves.easeInQuad.transform(0.8), 1e-6));
    await tester.pump(const Duration(milliseconds: 80));
    expect(controller.isOpen, isTrue);
    await tester.pumpAndSettle();
    expect(controller.isOpen, isFalse);
  });

  testWidgets(
    'measured menu width ignores dividers and stays stable on reversal',
    (WidgetTester tester) async {
      final MenuController controller = MenuController();
      await pumpPure(
        tester,
        _Host(
          controller: controller,
          children: <Widget>[
            MenuItemButton(onPressed: () {}, child: const Text('Short')),
            const SizedBox(width: 200, height: 20),
            Container(height: 0),
          ],
        ),
      );
      controller.open();
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(MenuPanel)).width, 200);
      expect(tester.getSize(find.byType(MenuItemButton)).width, 200);
      controller.close();
      await tester.pump();
      expect(tester.getSize(find.byType(MenuItemButton)).width, 200);
      controller.open();
      await tester.pump();
      expect(tester.getSize(find.byType(MenuItemButton)).width, 200);
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(MenuPanel)).width, 200);
    },
  );
  testWidgets('measured menu width supports expanded rows and long text', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    await pumpPure(
      tester,
      _Host(
        controller: controller,
        style: const MenuStyle(maximumSize: Size(180, 200)),
        children: <Widget>[
          MenuItemButton(
            onPressed: () {},
            child: Row(
              children: const <Widget>[
                Expanded(
                  child: Text('A label longer than the available width'),
                ),
              ],
            ),
          ),
          Container(height: 0),
        ],
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(MenuPanel)).width, 180);
    expect(tester.getSize(find.byType(MenuPanel)).height, greaterThan(20));
    controller.close();
    await tester.pumpAndSettle();
  });

  testWidgets('constraint-driven mixed content skips intrinsic width queries', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    int intrinsicQueries = 0;
    await pumpPure(
      tester,
      _Host(
        controller: controller,
        style: const MenuStyle(maximumSize: Size(180, 200)),
        children: <Widget>[
          _ZeroIntrinsicProbe(onIntrinsicWidth: () => intrinsicQueries++),
          const Text('x'),
          LayoutBuilder(
            builder: (_, BoxConstraints constraints) =>
                SizedBox(width: constraints.maxWidth, height: 20),
          ),
        ],
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(intrinsicQueries, 0);
    expect(tester.getSize(find.byType(MenuPanel)).width, 180);
  });

  testWidgets('nested viewport content keeps its measured bounded width', (
    WidgetTester tester,
  ) async {
    final MenuController controller = MenuController();
    int intrinsicQueries = 0;
    await pumpPure(
      tester,
      _Host(
        controller: controller,
        style: const MenuStyle(maximumSize: Size(180, 200)),
        children: <Widget>[
          _ZeroIntrinsicProbe(onIntrinsicWidth: () => intrinsicQueries++),
          const Text('x'),
          SizedBox(
            height: 20,
            child: ListView(children: const <Widget>[Text('Nested content')]),
          ),
        ],
      ),
    );
    controller.open();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(intrinsicQueries, 0);
    expect(tester.getSize(find.byType(MenuPanel)).width, 180);
  });
}
