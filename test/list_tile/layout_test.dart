import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('tiles have no implicit height, slot gaps, or padding', (
    WidgetTester tester,
  ) async {
    await pumpPure(
      tester,
      const SizedBox(
        width: 200.0,
        child: ListTile(
          title: SizedBox(
            key: ValueKey<String>('title'),
            width: double.infinity,
            height: 12.0,
          ),
        ),
      ),
    );
    expect(tester.getSize(find.byType(ListTile)).height, 12.0);
    expect(
      tester.getRect(find.byKey(const ValueKey<String>('title'))),
      tester.getRect(find.byType(ListTile)),
    );
  });

  testWidgets(
    'adjacent slots alone create their gaps and leading minimum width',
    (WidgetTester tester) async {
      Widget tile({bool leading = false, bool trailing = false}) => SizedBox(
        width: 200.0,
        child: ListTile(
          leading: leading
              ? const SizedBox(
                  key: ValueKey<String>('leading'),
                  width: 10.0,
                  height: 10.0,
                )
              : null,
          title: const SizedBox(
            key: ValueKey<String>('title'),
            width: double.infinity,
            height: 10.0,
          ),
          trailing: trailing
              ? const SizedBox(
                  key: ValueKey<String>('trailing'),
                  width: 12.0,
                  height: 10.0,
                )
              : null,
          style: const ListTileStyle(
            minLeadingWidth: 30.0,
            horizontalTitleGap: 8.0,
          ),
        ),
      );
      await pumpPure(tester, tile());
      expect(
        tester.getSize(find.byKey(const ValueKey<String>('title'))).width,
        200.0,
      );
      await pumpPure(tester, tile(leading: true));
      expect(
        tester.getTopLeft(find.byKey(const ValueKey<String>('title'))).dx -
            tester.getTopLeft(find.byType(ListTile)).dx,
        38.0,
      );
      await pumpPure(tester, tile(trailing: true));
      expect(
        tester.getSize(find.byKey(const ValueKey<String>('title'))).width,
        180.0,
      );
    },
  );

  testWidgets('line modes resolve minimum heights and their fallback chain', (
    WidgetTester tester,
  ) async {
    Future<void> check(
      ListTileStyle style,
      double expected, {
      bool subtitle = false,
      bool threeLine = false,
    }) async {
      await pumpPure(
        tester,
        SizedBox(
          width: 200.0,
          child: ListTile(
            title: const SizedBox(height: 10.0),
            subtitle: subtitle ? const SizedBox(height: 10.0) : null,
            isThreeLine: threeLine,
            style: style.copyWith(animationDuration: Duration.zero),
          ),
        ),
      );
      expect(tester.getSize(find.byType(ListTile)).height, expected);
    }

    const ListTileStyle style = ListTileStyle(
      minTileHeight: 40.0,
      minTwoLineTileHeight: 60.0,
      minThreeLineTileHeight: 90.0,
      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
    );
    await check(style, 40.0);
    await check(style, 60.0, subtitle: true);
    await check(style, 90.0, subtitle: true, threeLine: true);
    await check(const ListTileStyle(minTileHeight: 40.0), 40.0, subtitle: true);
    await check(
      const ListTileStyle(minTwoLineTileHeight: 60.0),
      60.0,
      subtitle: true,
      threeLine: true,
    );
  });

  testWidgets(
    'every slot keeps vertical padding and subtitle spacing is explicit',
    (WidgetTester tester) async {
      await pumpPure(
        tester,
        const SizedBox(
          width: 200.0,
          child: ListTile(
            leading: SizedBox(
              key: ValueKey<String>('leading'),
              width: 10.0,
              height: 10.0,
            ),
            title: SizedBox(
              key: ValueKey<String>('title'),
              width: double.infinity,
              height: 10.0,
            ),
            subtitle: SizedBox(key: ValueKey<String>('subtitle'), height: 10.0),
            trailing: SizedBox(
              key: ValueKey<String>('trailing'),
              width: 10.0,
              height: 10.0,
            ),
            style: ListTileStyle(
              minVerticalPadding: 6.0,
              subtitleSpacing: 4.0,
              titleAlignment: ListTileTitleAlignment.top,
            ),
          ),
        ),
      );
      final Rect tile = tester.getRect(find.byType(ListTile));
      expect(tile.height, 36.0);
      for (final String slot in <String>['leading', 'title', 'trailing']) {
        expect(
          tester.getTopLeft(find.byKey(ValueKey<String>(slot))).dy,
          tile.top + 6.0,
        );
      }
      expect(
        tester.getTopLeft(find.byKey(const ValueKey<String>('subtitle'))).dy -
            tester
                .getBottomLeft(find.byKey(const ValueKey<String>('title')))
                .dy,
        4.0,
      );
    },
  );

  testWidgets(
    'threeLine alignment puts adjacent slots at the top only in three-line mode',
    (WidgetTester tester) async {
      for (final bool threeLine in <bool>[false, true]) {
        await pumpPure(
          tester,
          SizedBox(
            width: 200.0,
            child: ListTile(
              leading: const SizedBox(
                key: ValueKey<String>('leading'),
                width: 10.0,
                height: 10.0,
              ),
              title: const SizedBox(height: 10.0),
              subtitle: const SizedBox(height: 10.0),
              isThreeLine: threeLine,
              style: const ListTileStyle(
                minTileHeight: 80.0,
                minVerticalPadding: 4.0,
              ),
            ),
          ),
        );
        final Rect tile = tester.getRect(find.byType(ListTile));
        final Rect leading = tester.getRect(
          find.byKey(const ValueKey<String>('leading')),
        );
        expect(
          leading.top,
          threeLine ? tile.top + 4.0 : tile.center.dy - leading.height / 2.0,
        );
      }
    },
  );

  testWidgets('directional content padding mirrors in RTL', (
    WidgetTester tester,
  ) async {
    for (final TextDirection direction in TextDirection.values) {
      await pumpPure(
        tester,
        const SizedBox(
          width: 200.0,
          child: ListTile(
            title: SizedBox(
              key: ValueKey<String>('title'),
              width: double.infinity,
              height: 10.0,
            ),
            style: ListTileStyle(
              contentPadding: EdgeInsetsDirectional.only(start: 8.0, end: 16.0),
            ),
          ),
        ),
        textDirection: direction,
      );
      final Rect tile = tester.getRect(find.byType(ListTile));
      final Rect title = tester.getRect(
        find.byKey(const ValueKey<String>('title')),
      );
      expect(
        title.left - tile.left,
        direction == TextDirection.ltr ? 8.0 : 16.0,
      );
      expect(
        tile.right - title.right,
        direction == TextDirection.ltr ? 16.0 : 8.0,
      );
    }
  });

  testWidgets(
    'a slider subtitle receives a bounded width without intrinsic layout',
    (WidgetTester tester) async {
      await pumpPure(
        tester,
        SizedBox(
          width: 300.0,
          child: ListTile(
            title: const Text('Volume'),
            subtitle: Slider(value: 0.5, onChanged: (double value) {}),
          ),
        ),
      );
      expect(tester.getSize(find.byType(Slider)).width, 300.0);
      expect(tester.takeException(), isNull);
    },
  );
}
