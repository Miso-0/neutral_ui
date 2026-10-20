import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/src/overlay/overlay_behavior.dart';
import 'package:neutral_ui/src/overlay/overlay_host.dart';
import 'package:neutral_ui/src/overlay/overlay_placement.dart';

void main() {
  Widget app(Widget child, {MediaQueryData media = const MediaQueryData()}) =>
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: media,
          child: TapRegionSurface(
            child: Overlay(
              key: UniqueKey(),
              initialEntries: <OverlayEntry>[
                OverlayEntry(builder: (BuildContext context) => child),
              ],
            ),
          ),
        ),
      );

  for (final OverlayLocation location in OverlayLocation.values) {
    testWidgets('$location chooses the correct overlay bounds', (
      WidgetTester tester,
    ) async {
      final OverlayPortalController controller = OverlayPortalController();
      const Key panelKey = Key('panel');
      await tester.pumpWidget(
        app(
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 80,
              child: Overlay(
                initialEntries: <OverlayEntry>[
                  OverlayEntry(
                    builder: (BuildContext context) => Align(
                      alignment: Alignment.topLeft,
                      child: OverlayHost(
                        controller: controller,
                        overlayLocation: location,
                        overlayBuilder: (BuildContext context) =>
                            const SizedBox(
                              key: panelKey,
                              width: 200,
                              height: 100,
                            ),
                        child: const SizedBox(width: 40, height: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      controller.show();
      await tester.pump();
      expect(
        tester.getSize(find.byKey(panelKey)),
        location == OverlayLocation.root
            ? const Size(200, 100)
            : const Size(100, 60),
      );
      expect(find.byType(RawMenuAnchor), findsNothing);
      controller.hide();
      await tester.pump();
      expect(find.byKey(panelKey), findsNothing);
    });
  }

  testWidgets('default root host follows anchor movement during layout', (
    WidgetTester tester,
  ) async {
    final OverlayPortalController controller = OverlayPortalController();
    final ValueNotifier<double> left = ValueNotifier<double>(10);
    addTearDown(left.dispose);
    const Key panelKey = Key('panel');
    await tester.pumpWidget(
      app(
        ValueListenableBuilder<double>(
          valueListenable: left,
          builder: (BuildContext context, double value, Widget? child) => Stack(
            children: <Widget>[
              Positioned(
                left: value,
                top: 20,
                child: OverlayHost(
                  controller: controller,
                  overlayBuilder: (BuildContext context) =>
                      const SizedBox(key: panelKey, width: 100, height: 60),
                  child: const SizedBox(width: 40, height: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    controller.show();
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(panelKey)), const Offset(10, 40));
    left.value = 80;
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(panelKey)), const Offset(80, 40));
  });

  testWidgets(
    'nearest overlay applies only intersecting safe and keyboard insets',
    (WidgetTester tester) async {
      const Key panelKey = Key('panel');
      for (final double top in <double>[100, 350]) {
        final OverlayPortalController controller = OverlayPortalController();
        await tester.pumpWidget(
          app(
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: top),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Overlay(
                    initialEntries: <OverlayEntry>[
                      OverlayEntry(
                        builder: (BuildContext context) => Align(
                          alignment: Alignment.topLeft,
                          child: OverlayHost(
                            controller: controller,
                            overlayLocation: OverlayLocation.nearest,
                            overlayBuilder: (BuildContext context) =>
                                const SizedBox(
                                  key: panelKey,
                                  width: 100,
                                  height: 60,
                                ),
                            child: const SizedBox(width: 40, height: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            media: const MediaQueryData(
              size: Size(800, 600),
              padding: EdgeInsets.only(top: 40),
              viewInsets: EdgeInsets.only(bottom: 200),
            ),
          ),
        );
        controller.show();
        await tester.pump();
        expect(
          tester.getSize(find.byKey(panelKey)),
          Size(100, top == 100 ? 60 : 30),
        );
        expect(tester.getTopLeft(find.byKey(panelKey)), Offset(0, top + 20));
      }
    },
  );

  testWidgets('root overlay retains safe padding consumed around its anchor', (
    WidgetTester tester,
  ) async {
    final OverlayPortalController controller = OverlayPortalController();
    const Key panelKey = Key('panel');
    await tester.pumpWidget(
      app(
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: OverlayHost(
              controller: controller,
              placement: const OverlayPlacement(crossOffset: -30),
              overlayBuilder: (BuildContext context) =>
                  const SizedBox(key: panelKey, width: 100, height: 60),
              child: const SizedBox(width: 40, height: 20),
            ),
          ),
        ),
        media: const MediaQueryData(
          size: Size(800, 600),
          padding: EdgeInsets.all(20),
        ),
      ),
    );
    controller.show();
    await tester.pump();
    expect(tester.getTopLeft(find.byKey(panelKey)), const Offset(20, 40));
  });

  for (final OutsideTapBehavior behavior in OutsideTapBehavior.values) {
    testWidgets('$behavior handles only outside taps while shown', (
      WidgetTester tester,
    ) async {
      final OverlayPortalController controller = OverlayPortalController();
      int outsideTaps = 0;
      int underlyingTaps = 0;
      int panelTaps = 0;
      const Key anchorKey = Key('anchor');
      const Key panelKey = Key('panel');
      await tester.pumpWidget(
        app(
          Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => underlyingTaps++,
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: OverlayHost(
                  controller: controller,
                  outsideTapBehavior: behavior,
                  onTapOutside: (PointerDownEvent event) => outsideTaps++,
                  overlayBuilder: (BuildContext context) => GestureDetector(
                    key: panelKey,
                    behavior: HitTestBehavior.opaque,
                    onTap: () => panelTaps++,
                    child: const SizedBox(width: 100, height: 60),
                  ),
                  child: const SizedBox(key: anchorKey, width: 40, height: 20),
                ),
              ),
            ],
          ),
        ),
      );
      await tester.tapAt(const Offset(300, 300));
      expect(outsideTaps, 0);
      expect(underlyingTaps, 1);
      controller.show();
      await tester.pump();
      await tester.tap(find.byKey(panelKey));
      expect(panelTaps, 1);
      expect(outsideTaps, 0);
      await tester.tapAt(tester.getCenter(find.byKey(anchorKey)));
      expect(outsideTaps, 0);
      final int previousUnderlying = underlyingTaps;
      await tester.tapAt(const Offset(300, 300));
      expect(outsideTaps, 1);
      expect(
        underlyingTaps,
        previousUnderlying +
            (behavior == OutsideTapBehavior.passThrough ? 1 : 0),
      );
      controller.hide();
      await tester.pump();
      await tester.tapAt(const Offset(300, 300));
      expect(outsideTaps, 1);
      expect(
        underlyingTaps,
        previousUnderlying +
            (behavior == OutsideTapBehavior.passThrough ? 2 : 1),
      );
    });
  }

  testWidgets('opening leaves focus with the caller and applies safe insets', (
    WidgetTester tester,
  ) async {
    final OverlayPortalController controller = OverlayPortalController();
    final FocusNode focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    const Key panelKey = Key('panel');
    AxisDirection? side;
    await tester.pumpWidget(
      app(
        Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 350,
              child: OverlayHost(
                controller: controller,
                placement: const OverlayPlacement(gap: 8),
                onSideResolved: (AxisDirection value) => side = value,
                overlayBuilder: (BuildContext context) =>
                    const SizedBox(key: panelKey, width: 100, height: 100),
                child: Focus(
                  focusNode: focusNode,
                  child: const SizedBox(width: 40, height: 20),
                ),
              ),
            ),
          ],
        ),
        media: const MediaQueryData(
          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
          viewInsets: EdgeInsets.only(bottom: 200),
        ),
      ),
    );
    focusNode.requestFocus();
    await tester.pump();
    controller.show();
    await tester.pump();
    expect(focusNode.hasPrimaryFocus, isTrue);
    expect(side, AxisDirection.up);
    expect(
      tester.getRect(find.byKey(panelKey)),
      const Rect.fromLTWH(20, 242, 100, 100),
    );
  });
}
