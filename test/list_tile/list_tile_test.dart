import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('layout reverses slots in RTL and supports content height', (
    WidgetTester tester,
  ) async {
    Widget tile() => const SizedBox(
      width: 300,
      child: ListTile(
        leading: SizedBox(
          key: ValueKey<String>('leading'),
          width: 20,
          height: 20,
        ),
        title: Text('Title'),
        subtitle: Text('Subtitle'),
        trailing: SizedBox(
          key: ValueKey<String>('trailing'),
          width: 20,
          height: 20,
        ),
        style: ListTileStyle(
          minTileHeight: 40,
          minTwoLineTileHeight: 80,
          horizontalTitleGap: 12,
          contentPadding: EdgeInsetsDirectional.only(start: 10, end: 20),
        ),
      ),
    );
    await pumpNeutral(tester, tile());
    expect(tester.getSize(find.byType(ListTile)).height, 80);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey<String>('leading'))).dx,
      lessThan(tester.getTopLeft(find.text('Title')).dx),
    );
    await pumpNeutral(tester, tile(), textDirection: TextDirection.rtl);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey<String>('leading'))).dx,
      greaterThan(tester.getTopLeft(find.text('Title')).dx),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('per-state inline null falls through local theme', (
    WidgetTester tester,
  ) async {
    const BoxDecoration global = BoxDecoration(color: Color(0xFF000001));
    const BoxDecoration local = BoxDecoration(color: Color(0xFF000002));
    const BoxDecoration pressed = BoxDecoration(color: Color(0xFF000003));
    await pumpNeutral(
      tester,
      ListTileTheme(
        data: const ListTileStyle(
          decoration: StateProperty<Decoration?>.all(local),
        ),
        child: ListTile(
          title: const Text('Tile'),
          onTap: () {},
          style: ListTileStyle(
            decoration: StateProperty<Decoration?>.resolveWith(
              (InteractionState state) => state.isPressed ? pressed : null,
            ),
          ),
        ),
      ),
      theme: const ThemeData(
        listTileStyle: ListTileStyle(
          decoration: StateProperty<Decoration?>.all(global),
        ),
      ),
    );
    AnimatedSurface surface() => tester.widget<AnimatedSurface>(
      find
          .descendant(
            of: find.byType(ListTile),
            matching: find.byType(AnimatedSurface),
          )
          .first,
    );
    expect(surface().decoration, local);
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.byType(ListTile)),
    );
    await tester.pump(const Duration(milliseconds: 150));
    expect(surface().decoration, pressed);
    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('alignment modes position slots against minimum tile height', (
    WidgetTester tester,
  ) async {
    for (final ListTileTitleAlignment mode in ListTileTitleAlignment.values) {
      await pumpNeutral(
        tester,
        SizedBox(
          width: 300,
          child: ListTile(
            leading: const SizedBox(
              key: ValueKey<String>('leading'),
              width: 10,
              height: 10,
            ),
            title: const Text('Title'),
            style: ListTileStyle(minTileHeight: 100, titleAlignment: mode),
          ),
        ),
      );
      final Rect tile = tester.getRect(find.byType(ListTile));
      final Rect leading = tester.getRect(
        find.byKey(const ValueKey<String>('leading')),
      );
      if (mode == ListTileTitleAlignment.top) {
        expect(leading.top, tile.top);
      } else if (mode == ListTileTitleAlignment.bottom) {
        expect(leading.bottom, tile.bottom);
      } else {
        expect(leading.center.dy, tile.center.dy);
      }
    }
  });

  testWidgets('actions, disabled state, semantics and focus eligibility', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    final FocusNode focus = FocusNode();
    addTearDown(focus.dispose);
    int taps = 0;
    await pumpNeutral(
      tester,
      ListTile(
        title: const Text('Tile'),
        selected: true,
        onTap: () {
          taps++;
        },
      ),
    );
    await tester.tap(find.text('Tile'));
    expect(taps, 1);
    expect(
      tester.getSemantics(find.byType(ListTile)),
      matchesSemantics(
        label: 'Tile',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    await pumpNeutral(
      tester,
      ListTile(
        title: const Text('Passive'),
        enabled: false,
        focusNode: focus,
        onTap: () {
          taps++;
        },
      ),
    );
    await tester.tap(find.text('Passive'));
    expect(taps, 1);
    expect(focus.canRequestFocus, isFalse);
    await pumpNeutral(
      tester,
      ListTile(title: const Text('Static'), focusNode: focus),
    );
    expect(focus.canRequestFocus, isFalse);
    semantics.dispose();
  });

  test('three-line tiles require a subtitle', () {
    expect(() => ListTile(isThreeLine: true), throwsAssertionError);
  });
}
