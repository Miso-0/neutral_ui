import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('inline tokens resolve above local and global tile themes', (
    WidgetTester tester,
  ) async {
    const BoxDecoration global = BoxDecoration(color: Color(0xFF000001));
    const BoxDecoration local = BoxDecoration(color: Color(0xFF000002));
    const BoxDecoration inline = BoxDecoration(color: Color(0xFF000003));
    const ListTileStyle globalStyle = ListTileStyle(
      decoration: StateProperty<Decoration?>.all(global),
      minTileHeight: 80.0,
    );
    await pumpNeutral(
      tester,
      const ListTile(title: Text('Tile')),
      theme: const ThemeData(listTileStyle: globalStyle),
    );
    expect(
      tester.widget<AnimatedSurface>(find.byType(AnimatedSurface)).decoration,
      global,
    );
    await pumpNeutral(
      tester,
      const ListTileTheme(
        data: ListTileStyle(decoration: StateProperty<Decoration?>.all(local)),
        child: ListTile(
          title: Text('Tile'),
          style: ListTileStyle(
            decoration: StateProperty<Decoration?>.all(inline),
          ),
        ),
      ),
      theme: const ThemeData(listTileStyle: globalStyle),
    );
    expect(
      tester.widget<AnimatedSurface>(find.byType(AnimatedSurface)).decoration,
      inline,
    );
    expect(tester.getSize(find.byType(ListTile)).height, lessThan(80.0));
  });

  testWidgets(
    'ListTileTheme.merge inherits tokens through nested component themes',
    (WidgetTester tester) async {
      const BoxDecoration decoration = BoxDecoration(color: Color(0xFF000001));
      await pumpNeutral(
        tester,
        ListTileTheme.merge(
          data: const ListTileStyle(contentPadding: EdgeInsets.all(6.0)),
          child: Builder(
            builder: (BuildContext context) => ListTileTheme.merge(
              data: const ListTileStyle(horizontalTitleGap: 7.0),
              child: const ListTile(
                leading: SizedBox(width: 10.0, height: 10.0),
                title: SizedBox(key: ValueKey<String>('title'), height: 10.0),
              ),
            ),
          ),
        ),
        theme: const ThemeData(
          listTileStyle: ListTileStyle(
            decoration: StateProperty<Decoration?>.all(decoration),
            minTileHeight: 60.0,
          ),
        ),
      );
      expect(
        tester.widget<AnimatedSurface>(find.byType(AnimatedSurface)).decoration,
        decoration,
      );
      expect(tester.getSize(find.byType(ListTile)).height, 60.0);
      expect(
        tester.getTopLeft(find.byKey(const ValueKey<String>('title'))).dx -
            tester.getTopLeft(find.byType(ListTile)).dx,
        23.0,
      );
    },
  );

  testWidgets('every slot receives its text style and the shared icon theme', (
    WidgetTester tester,
  ) async {
    final Map<String, TextStyle> textStyles = <String, TextStyle>{};
    final Map<String, IconThemeData> iconThemes = <String, IconThemeData>{};
    Widget slot(String name) => Builder(
      builder: (BuildContext context) {
        textStyles[name] = DefaultTextStyle.of(context).style;
        iconThemes[name] = IconTheme.of(context);
        return const SizedBox(width: 10.0, height: 10.0);
      },
    );
    await pumpNeutral(
      tester,
      ListTile(
        leading: slot('leading'),
        title: slot('title'),
        subtitle: slot('subtitle'),
        trailing: slot('trailing'),
        style: const ListTileStyle(
          titleTextStyle: StateProperty<TextStyle?>.all(
            TextStyle(fontSize: 21.0),
          ),
          subtitleTextStyle: StateProperty<TextStyle?>.all(
            TextStyle(fontSize: 15.0),
          ),
          leadingAndTrailingTextStyle: StateProperty<TextStyle?>.all(
            TextStyle(fontSize: 17.0),
          ),
          iconTheme: StateProperty<IconThemeData?>.all(
            IconThemeData(size: 23.0, color: Color(0xFF123456)),
          ),
        ),
      ),
    );
    expect(textStyles['title']!.fontSize, 21.0);
    expect(textStyles['subtitle']!.fontSize, 15.0);
    expect(textStyles['leading']!.fontSize, 17.0);
    expect(textStyles['trailing']!.fontSize, 17.0);
    for (final IconThemeData theme in iconThemes.values) {
      expect(theme.size, 23.0);
      expect(theme.color, const Color(0xFF123456));
    }
  });

  testWidgets('long press and Enter activation reach tile callbacks', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    final FocusNode focus = FocusNode();
    addTearDown(focus.dispose);
    int taps = 0;
    int presses = 0;
    await pumpNeutral(
      tester,
      ListTile(
        title: const Text('Tile'),
        focusNode: focus,
        onTap: () => taps += 1,
        onLongPress: () => presses += 1,
      ),
    );
    await tester.longPress(find.text('Tile'));
    expect(presses, 1);
    expect(taps, 0);
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets(
    'selected, hovered, focused and disabled flags reach tile resolvers',
    (WidgetTester tester) async {
      useTraditionalFocus();
      final FocusNode focus = FocusNode();
      addTearDown(focus.dispose);
      final List<InteractionState> states = <InteractionState>[];
      final List<bool> hovers = <bool>[];
      final List<bool> focuses = <bool>[];
      final WidgetStatesController controller = WidgetStatesController();
      addTearDown(controller.dispose);
      final ListTileStyle style = ListTileStyle(
        decoration: StateProperty<Decoration?>.resolveWith((
          InteractionState state,
        ) {
          states.add(state);
          return null;
        }),
      );
      Widget tile({bool enabled = true}) => ListTile(
        title: const Text('Tile'),
        enabled: enabled,
        selected: true,
        focusNode: focus,
        statesController: controller,
        onTap: () {},
        onHover: hovers.add,
        onFocusChange: focuses.add,
        style: style,
      );
      await pumpNeutral(tester, tile());
      final TestGesture mouse = await hover(tester, find.byType(ListTile));
      focus.requestFocus();
      await tester.pumpAndSettle();
      expect(states.last.isSelected, isTrue);
      expect(states.last.isHovered, isTrue);
      expect(states.last.isFocused, isTrue);
      expect(
        controller.value,
        containsAll(<WidgetState>[
          WidgetState.selected,
          WidgetState.focused,
          WidgetState.hovered,
        ]),
      );
      expect(hovers, <bool>[true]);
      expect(focuses, contains(true));
      await pumpNeutral(tester, tile(enabled: false));
      expect(states.last.isDisabled, isTrue);
      expect(states.last.isHovered, isFalse);
      expect(controller.value, contains(WidgetState.disabled));
      await mouse.removePointer();
    },
  );
}
