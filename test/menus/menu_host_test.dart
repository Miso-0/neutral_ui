import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/menus/menu_host.dart';
import 'package:pure_ui/src/menus/menu_item_button.dart';

import '../helpers/pump.dart';

class _Host extends StatefulWidget {
  const _Host({
    super.key,
    this.controller,
    this.focusNode,
    this.style = const MenuStyle(),
  });

  final MenuController? controller;
  final FocusNode? focusNode;
  final MenuStyle style;

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
      child: const Text('Open'),
    ),
    children: <Widget>[
      MenuItemButton(onPressed: closeMenu, child: const Text('Option')),
    ],
  );
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
}
