import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/menus/menu_panel.dart';

import '../helpers/pump.dart';

const Color _ink = Color(0xFF142C2A);
const Color _accent = Color(0xFF087F6D);

Finder _glyphPaint(Type glyph) =>
    find.descendant(of: find.byType(glyph), matching: find.byType(CustomPaint));

/// Whether the [index]th [CheckGlyph] in an open menu is shown.
bool _checkVisible(WidgetTester tester, int index) => tester
    .widget<Visibility>(
      find
          .ancestor(
            of: find
                .descendant(
                  of: find.byType(MenuPanel),
                  matching: find.byType(CheckGlyph),
                )
                .at(index),
            matching: find.byType(Visibility),
          )
          .first,
    )
    .visible;

void main() {
  group('glyph widgets', () {
    testWidgets('size and color follow the ambient icon theme like Icon', (
      WidgetTester tester,
    ) async {
      await pumpNeutral(
        tester,
        const IconTheme(
          data: IconThemeData(color: _accent, size: 18, opacity: 0.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[ChevronGlyph(), CheckGlyph(), DotsGlyph()],
          ),
        ),
      );
      final Color faded = _accent.withValues(alpha: 0.5);
      for (final Type glyph in <Type>[ChevronGlyph, CheckGlyph, DotsGlyph]) {
        expect(tester.getSize(find.byType(glyph)), const Size(18, 18));
      }
      expect(
        tester.renderObject(_glyphPaint(ChevronGlyph)),
        paints..path(color: faded),
      );
      expect(
        tester.renderObject(_glyphPaint(CheckGlyph)),
        paints..path(color: faded),
      );
      expect(
        tester.renderObject(_glyphPaint(DotsGlyph)),
        paints
          ..circle(color: faded)
          ..circle(color: faded)
          ..circle(color: faded),
      );
    });

    testWidgets('explicit size and color win and glyphs are decorative', (
      WidgetTester tester,
    ) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      await pumpNeutral(
        tester,
        const IconTheme(
          data: IconThemeData(color: _accent, size: 18),
          child: CheckGlyph(size: 10, color: _ink),
        ),
      );
      expect(tester.getSize(find.byType(CheckGlyph)), const Size(10, 10));
      expect(
        tester.renderObject(_glyphPaint(CheckGlyph)),
        paints..path(color: _ink),
      );
      expect(
        find.descendant(
          of: find.byType(CheckGlyph),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
      semantics.dispose();
    });
  });

  group('dropdown arrow default', () {
    testWidgets(
      'DropdownButton paints a chevron in its icon theme and flips it',
      (WidgetTester tester) async {
        await pumpNeutral(
          tester,
          DropdownButton<String>(
            items: const <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(value: 'a', child: Text('A')),
            ],
            value: 'a',
            onChanged: (String? value) {},
            style: const DropdownStyle(
              buttonStyle: ButtonStyle(
                iconTheme: StateProperty<IconThemeData?>.all(
                  IconThemeData(color: _ink, size: 14),
                ),
              ),
            ),
          ),
        );
        expect(find.byType(ChevronGlyph), findsOneWidget);
        expect(tester.getSize(find.byType(ChevronGlyph)), const Size(14, 14));
        expect(
          tester.renderObject(_glyphPaint(ChevronGlyph)),
          paints..path(color: _ink),
        );
        double turns() => tester
            .widget<RotationTransition>(
              find.ancestor(
                of: find.byType(ChevronGlyph),
                matching: find.byType(RotationTransition),
              ),
            )
            .turns
            .value;
        expect(turns(), 0);
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        expect(turns(), 0.5);
      },
    );

    testWidgets(
      'DropdownMenu paints a chevron unless showTrailingIcon is off',
      (WidgetTester tester) async {
        const List<DropdownMenuEntry<int>> entries = <DropdownMenuEntry<int>>[
          DropdownMenuEntry<int>(value: 1, label: 'One'),
        ];
        await pumpNeutral(
          tester,
          const DropdownMenu<int>(dropdownMenuEntries: entries),
        );
        expect(find.byType(ChevronGlyph), findsOneWidget);
        await pumpNeutral(
          tester,
          const DropdownMenu<int>(
            dropdownMenuEntries: entries,
            showTrailingIcon: false,
          ),
        );
        expect(find.byType(ChevronGlyph), findsNothing);
      },
    );
  });

  group('selection indicator default', () {
    testWidgets('dropdown rows check the chosen option and keep alignment', (
      WidgetTester tester,
    ) async {
      await pumpNeutral(
        tester,
        DropdownButton<String>(
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'a', child: Text('A')),
            DropdownMenuItem<String>(value: 'b', child: Text('B')),
          ],
          value: 'b',
          onChanged: (String? value) {},
          style: const DropdownStyle(
            itemStyle: ButtonStyle(
              iconTheme: StateProperty<IconThemeData?>.all(
                IconThemeData(color: _accent, size: 16),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(MenuPanel),
          matching: find.byType(CheckGlyph),
        ),
        findsNWidgets(2),
      );
      expect(_checkVisible(tester, 0), isFalse);
      expect(_checkVisible(tester, 1), isTrue);
      expect(
        tester
            .getTopLeft(
              find.descendant(
                of: find.byType(MenuPanel),
                matching: find.text('A'),
              ),
            )
            .dx,
        tester
            .getTopLeft(
              find.descendant(
                of: find.byType(MenuPanel),
                matching: find.text('B'),
              ),
            )
            .dx,
      );
      expect(
        tester.renderObject(
          find
              .descendant(
                of: find.byType(MenuPanel),
                matching: find.byType(CustomPaint),
              )
              .last,
        ),
        paints..path(color: _accent),
      );
    });

    testWidgets('DropdownMenu.multiple checks every selected entry', (
      WidgetTester tester,
    ) async {
      await pumpNeutral(
        tester,
        DropdownMenu<int>.multiple(
          dropdownMenuEntries: const <DropdownMenuEntry<int>>[
            DropdownMenuEntry<int>(value: 1, label: 'One'),
            DropdownMenuEntry<int>(value: 2, label: 'Two'),
            DropdownMenuEntry<int>(value: 3, label: 'Three'),
          ],
          selected: const <int>{1, 3},
          onSelectionChanged: (Set<int> value) {},
          selectOnly: true,
        ),
      );
      await tester.tap(find.byType(DropdownMenu<int>));
      await tester.pumpAndSettle();
      expect(_checkVisible(tester, 0), isTrue);
      expect(_checkVisible(tester, 1), isFalse);
      expect(_checkVisible(tester, 2), isTrue);
    });

    testWidgets('checked popup items default to a check', (
      WidgetTester tester,
    ) async {
      await pumpNeutral(
        tester,
        PopupMenuButton<int>(
          itemBuilder: (BuildContext context) => const <PopupMenuEntry<int>>[
            CheckedPopupMenuItem<int>(
              value: 1,
              checked: true,
              child: Text('On'),
            ),
            CheckedPopupMenuItem<int>(value: 2, child: Text('Off')),
            PopupMenuItem<int>(value: 3, child: Text('Plain')),
          ],
          child: const Text('Actions'),
        ),
      );
      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(MenuPanel),
          matching: find.byType(CheckGlyph),
        ),
        findsNWidgets(2),
      );
      expect(_checkVisible(tester, 0), isTrue);
      expect(_checkVisible(tester, 1), isFalse);
    });

    testWidgets('a provided token that resolves null opts out of the default', (
      WidgetTester tester,
    ) async {
      await pumpNeutral(
        tester,
        DropdownButton<String>(
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(value: 'a', child: Text('A')),
          ],
          value: 'a',
          onChanged: (String? value) {},
          style: const DropdownStyle(
            selectedIndicator: StateProperty<Widget?>.all(null),
          ),
        ),
      );
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      expect(find.byType(CheckGlyph), findsNothing);
    });
  });

  group('loading indicator default', () {
    testWidgets('loading buttons show painted dots over hidden content', (
      WidgetTester tester,
    ) async {
      await pumpNeutral(
        tester,
        ElevatedButton(
          onPressed: () {},
          isLoading: true,
          child: const Text('Save'),
        ),
      );
      expect(find.byType(DotsGlyph), findsOneWidget);
      expect(
        tester
            .widget<Visibility>(
              find.ancestor(
                of: find.text('Save'),
                matching: find.byType(Visibility),
              ),
            )
            .visible,
        isFalse,
      );
    });

    testWidgets('a null loading token keeps the content visible instead', (
      WidgetTester tester,
    ) async {
      await pumpNeutral(
        tester,
        ElevatedButton(
          onPressed: () {},
          isLoading: true,
          style: const ButtonStyle(
            loadingIndicator: StateProperty<Widget?>.all(null),
          ),
          child: const Text('Save'),
        ),
      );
      expect(find.byType(DotsGlyph), findsNothing);
      expect(
        tester
            .widget<Visibility>(
              find.ancestor(
                of: find.text('Save'),
                matching: find.byType(Visibility),
              ),
            )
            .visible,
        isTrue,
      );
    });
  });
}
