import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui_example/examples/buttons/elevated_button_example.dart';
import 'package:neutral_ui_example/examples/buttons/favorite_icon_button_example.dart';
import 'package:neutral_ui_example/examples/buttons/loading_button_example.dart';
import 'package:neutral_ui_example/examples/foundations/consume_overlay_example.dart';
import 'package:neutral_ui_example/examples/foundations/decorations_example.dart';
import 'package:neutral_ui_example/examples/foundations/glyphs_example.dart';
import 'package:neutral_ui_example/examples/foundations/interaction_example.dart';
import 'package:neutral_ui_example/examples/foundations/localized_dates_example.dart';
import 'package:neutral_ui_example/examples/menus/dropdown_button_example.dart';
import 'package:neutral_ui_example/examples/menus/expanded_dropdown_example.dart';
import 'package:neutral_ui_example/examples/menus/filter_dropdown_example.dart';
import 'package:neutral_ui_example/examples/menus/multiple_dropdown_example.dart';
import 'package:neutral_ui_example/examples/menus/popup_menu_example.dart';
import 'package:neutral_ui_example/examples/menus/search_dropdown_example.dart';

void main() {
  testWidgets('standalone action examples own their controlled state', (
    WidgetTester tester,
  ) async {
    await _pumpExample(tester, const ElevatedButtonExample());
    await tester.tap(find.text('Create project'));
    await tester.pumpAndSettle();
    expect(find.text('Project created'), findsOneWidget);

    await _pumpExample(tester, const FavoriteIconButtonExample());
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).isSelected,
      isTrue,
    );
    expect(find.text('Favorited'), findsOneWidget);

    await _pumpExample(tester, const LoadingButtonExample());
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).isLoading,
      isTrue,
    );
    await tester.tap(find.text('Reset loading'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).isLoading,
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  for (final TextDirection direction in TextDirection.values) {
    testWidgets('standalone menus select values in ${direction.name}', (
      WidgetTester tester,
    ) async {
      await _pumpExample(
        tester,
        const DropdownButtonExample(),
        direction: direction,
      );
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mobile app').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.text('Project type: Mobile app'), findsOneWidget);

      await _pumpExample(
        tester,
        const ExpandedDropdownExample(),
        direction: direction,
      );
      expect(find.text('No workspaces available'), findsOneWidget);
      final Finder expanded = find.byType(DropdownButton<String>).first;
      expect(
        tester.widget<DropdownButton<String>>(expanded).isExpanded,
        isTrue,
      );
      await tester.tap(expanded);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Shared workspace').hitTestable().last);
      await tester.pumpAndSettle();
      expect(
        tester.widget<DropdownButton<String>>(expanded).value,
        'Shared workspace',
      );

      await _pumpExample(
        tester,
        const FilterDropdownExample(),
        direction: direction,
      );
      final Finder cityField = find.descendant(
        of: find.byType(FilterDropdownExample),
        matching: find.byType(EditableText),
      );
      await tester.tap(cityField);
      await tester.pumpAndSettle();
      await tester.enterText(cityField, 'dur');
      await tester.pumpAndSettle();
      expect(find.text('Cape Town').hitTestable(), findsNothing);
      await tester.tap(find.text('Durban').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.text('City: Durban'), findsOneWidget);

      await _pumpExample(
        tester,
        const SearchDropdownExample(),
        direction: direction,
      );
      final Finder languageField = find.descendant(
        of: find.byType(SearchDropdownExample),
        matching: find.byType(EditableText),
      );
      await tester.tap(languageField);
      await tester.pumpAndSettle();
      await tester.enterText(languageField, 'sw');
      await tester.pumpAndSettle();
      expect(find.text('Dart').hitTestable(), findsOneWidget);
      expect(find.text('Kotlin').hitTestable(), findsOneWidget);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('Language: Swift'), findsOneWidget);

      await _pumpExample(
        tester,
        const MultipleDropdownExample(),
        direction: direction,
      );
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Design').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.text('Teams: Engineering, Design'), findsOneWidget);
      await tester.tap(find.text('Research').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.text('Teams: Engineering, Design, Research'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(
        find
            .descendant(
              of: find.byType(MultipleDropdownExample),
              matching: find.text('Design'),
            )
            .hitTestable(),
        findsOneWidget,
      );
      expect(
        find
            .descendant(
              of: find.byType(MultipleDropdownExample),
              matching: find.text('Research'),
            )
            .hitTestable(),
        findsOneWidget,
      );

      await _pumpExample(
        tester,
        const PopupMenuExample(),
        direction: direction,
      );
      final Finder popup = find.byType(PopupMenuButton<String>);
      expect(
        tester.widget<PopupMenuButton<String>>(popup.first).position,
        PopupMenuPosition.over,
      );
      expect(
        tester.widget<PopupMenuButton<String>>(popup.last).position,
        PopupMenuPosition.under,
      );
      await tester.tap(popup.first);
      await tester.pumpAndSettle();
      expect(find.text('Archive project').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Archive project').hitTestable());
      await tester.pumpAndSettle();
      expect(find.text('Duplicate project').hitTestable(), findsOneWidget);
      expect(find.text('Choose an action'), findsOneWidget);
      await tester.tap(find.text('Duplicate project').hitTestable());
      await tester.pumpAndSettle();
      expect(find.text('Project action: duplicate'), findsOneWidget);
      await tester.tap(popup.last);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<CheckedPopupMenuItem<String>>(
              find.byType(CheckedPopupMenuItem<String>),
            )
            .checked,
        isTrue,
      );
      await tester.tap(find.text('Pin to sidebar').hitTestable());
      await tester.pumpAndSettle();
      expect(find.text('Project action: pin'), findsOneWidget);
      expect(find.text('Duplicate project').hitTestable(), findsNothing);
      await tester.tap(popup.last);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<CheckedPopupMenuItem<String>>(
              find.byType(CheckedPopupMenuItem<String>),
            )
            .checked,
        isFalse,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('dropdown focus transitions from hover without layout shifts', (
    WidgetTester tester,
  ) async {
    await _pumpExample(tester, const FilterDropdownExample());
    final Finder field = find.descendant(
      of: find.byType(FilterDropdownExample),
      matching: find.byType(EditableText),
    );
    final Finder fieldSurface = find.ancestor(
      of: field,
      matching: find.byWidgetPredicate(
        (Widget widget) => widget.runtimeType.toString() == 'AnimatedSurface',
      ),
    );
    BoxDecoration surface() =>
        tester
                .widget<DecoratedBox>(
                  find
                      .descendant(
                        of: fieldSurface,
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;
    final Rect bounds = tester.getRect(field);
    final BoxDecoration idle = surface();
    final TestGesture mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(field));
    await tester.pumpAndSettle();
    final BoxDecoration hovered = surface();
    expect(hovered.color, isNot(idle.color));
    expect(tester.getRect(field), bounds);

    await mouse.down(tester.getCenter(field));
    await mouse.up();
    await tester.pump();
    final FocusNode focus = tester.widget<EditableText>(field).focusNode;
    expect(focus.hasFocus, isTrue);
    await tester.pump(const Duration(milliseconds: 100));
    final BoxDecoration transitioning = surface();
    await tester.pumpAndSettle();
    final BoxDecoration focused = surface();
    expect(focused.color, isNot(hovered.color));
    expect(focused.border, isNot(hovered.border));
    expect(transitioning.color, isNot(hovered.color));
    expect(transitioning.color, isNot(focused.color));
    expect(tester.getRect(field), bounds);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isTrue);
    await mouse.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect(surface(), focused);
    await mouse.moveTo(tester.getCenter(field));
    await tester.pumpAndSettle();
    expect(surface(), focused);
    focus.unfocus();
    await tester.pump();
    expect(focus.hasFocus, isFalse);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(surface().color, isNot(focused.color));
    expect(surface().color, isNot(hovered.color));
    await tester.pumpAndSettle();
    expect(surface(), hovered);
    expect(tester.getRect(field), bounds);
    await mouse.removePointer();
  });

  testWidgets('direct decorations resolve the asset and stay interactive', (
    WidgetTester tester,
  ) async {
    await _pumpExample(tester, const DecorationsExample());
    final Finder tile = find.descendant(
      of: find.byType(DecorationsExample),
      matching: find.byType(ListTile),
    );
    final BoxDecoration decoration = tester.widget<ListTile>(tile).decoration!;
    final ImageProvider<Object> image = decoration.image!.image;
    expect(image, const AssetImage('assets/decoration_pattern.png'));
    await tester.runAsync(() async {
      final Completer<ImageInfo> loaded = Completer<ImageInfo>();
      final ImageStream stream = image.resolve(ImageConfiguration.empty);
      final ImageStreamListener listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) => loaded.complete(info),
        onError: (Object error, StackTrace? stack) =>
            loaded.completeError(error, stack),
      );
      stream.addListener(listener);
      try {
        final ImageInfo info = await loaded.future;
        expect(info.image.width, 64);
        expect(info.image.height, 64);
        info.dispose();
      } finally {
        stream.removeListener(listener);
      }
    });
    await tester.tap(find.text('A gradient, directly'));
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pumpAndSettle();
    final Finder slider = find.descendant(
      of: find.byType(DecorationsExample),
      matching: find.byType(Slider),
    );
    final Rect bounds = tester.getRect(slider);
    await tester.tapAt(Offset(bounds.right - 40, bounds.center.dy));
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(slider).value, greaterThan(0.35));
    final Finder toggle = find.descendant(
      of: find.byType(DecorationsExample),
      matching: find.byType(Switch),
    );
    final BoxDecoration? thumb = tester.widget<Switch>(toggle).thumbDecoration;
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(toggle).value, isFalse);
    expect(tester.widget<Switch>(toggle).thumbDecoration, thumb);
    expect(tester.widget<ListTile>(tile).decoration, decoration);
    expect(tester.takeException(), isNull);
  });

  testWidgets('foundation dates and glyphs use the standalone examples', (
    WidgetTester tester,
  ) async {
    await _pumpExample(tester, const LocalizedDatesExample());
    expect(find.text('Friday, October 16, 2026'), findsOneWidget);
    final BuildContext context = tester.element(
      find.byType(LocalizedDatesExample),
    );
    expect(
      find.text(
        NeutralLocalizations.of(context)
            .formatCompactDate(DateTime(2026, 10, 16)),
      ),
      findsOneWidget,
    );
    await _pumpExample(
      tester,
      const GlyphsExample(),
      direction: TextDirection.rtl,
    );
    expect(
      find.descendant(
        of: find.byType(GlyphsExample),
        matching: find.byType(CalendarGlyph),
      ),
      findsOneWidget,
    );
    expect(
      Directionality.of(tester.element(find.byType(ArrowGlyph).first)),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'consume outside taps prevents activating the underlying action',
    (WidgetTester tester) async {
      await _pumpExample(tester, const ConsumeOverlayExample());
      await tester.tap(find.text('Open an overlay'));
      await tester.pumpAndSettle();
      expect(find.text('Select foundation').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Underlying action: 0'));
      await tester.pumpAndSettle();
      expect(find.text('Select foundation').hitTestable(), findsNothing);
      expect(find.text('Underlying action: 0'), findsOneWidget);
      await tester.tap(find.text('Underlying action: 0'));
      await tester.pumpAndSettle();
      expect(find.text('Underlying action: 1'), findsOneWidget);
      await tester.tap(find.text('Open an overlay'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select foundation').hitTestable());
      await tester.pumpAndSettle();
      expect(find.text('Foundation selected'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('interaction detector reports focus hover and activation', (
    WidgetTester tester,
  ) async {
    await _pumpExample(tester, const InteractionExample());
    final Finder target = find.text('LIVE INTERACTION STATE');
    final TestGesture mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(target));
    await tester.pumpAndSettle();
    expect(find.textContaining('hovered true'), findsOneWidget);
    await tester.tap(target);
    await tester.pumpAndSettle();
    expect(find.text('Activated 1 times'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(find.textContaining('focused true'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Activated 2 times'), findsOneWidget);
    await mouse.removePointer();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpExample(
  WidgetTester tester,
  Widget example, {
  TextDirection direction = TextDirection.ltr,
}) async {
  tester.view.physicalSize = const Size(900, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    NeutralApp(
      key: UniqueKey(),
      color: const Color(0xFFFFFFFF),
      theme: const ThemeData(),
      builder: (BuildContext context, Widget? child) =>
          Directionality(textDirection: direction, child: child!),
      home: Padding(
        padding: const EdgeInsets.all(32),
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: example,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
