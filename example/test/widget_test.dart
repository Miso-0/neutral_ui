import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui_example/main.dart';

void main() {
  testWidgets(
    'dropdown focus takes over hover smoothly without moving content',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const GalleryApp());
      await tester.pumpAndSettle();
      final Finder dropdown = find.byKey(const ValueKey<String>('filter-menu'));
      await tester.ensureVisible(dropdown);
      await tester.pumpAndSettle();
      final Finder field = find.descendant(
        of: dropdown,
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
                    find.descendant(
                      of: fieldSurface,
                      matching: find.byType(DecoratedBox),
                    ),
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
    },
  );

  testWidgets('gallery renders and controlled interactions work', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();
    expect(find.text('neutralui'), findsOneWidget);
    expect(find.text('Create project'), findsOneWidget);
    await tester.tap(find.text('Create project'));
    await tester.pumpAndSettle();
    expect(find.text('Primary action activated'), findsOneWidget);
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
    expect(
      tester.widget<IconButton>(find.byType(IconButton).first).isSelected,
      isTrue,
    );
    final Finder rtl = find.byType(Switch).first;
    await tester.tap(rtl);
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.text('neutralui'))),
      TextDirection.rtl,
    );
    await tester.ensureVisible(find.text('05 / Local themes'));
    await tester.pumpAndSettle();
    expect(find.text('Local button theme'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final bool rtl in <bool>[false, true]) {
    testWidgets('gallery menus select values in ${rtl ? 'RTL' : 'LTR'}', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const GalleryApp());
      await tester.pumpAndSettle();
      if (rtl) {
        await tester.tap(find.byType(Switch).first);
        await tester.pumpAndSettle();
      }
      await tester.ensureVisible(find.text('06 / Menus'));
      await tester.pumpAndSettle();
      expect(find.text('No workspaces available'), findsOneWidget);

      await _openGalleryMenu(tester, 'classic-select');
      await tester.tap(find.text('Mobile app').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.text('Project type: Mobile app'), findsOneWidget);

      await _openGalleryMenu(tester, 'expanded-select');
      await tester.tap(find.text('Shared workspace').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.text('Workspace: Shared workspace'), findsOneWidget);

      await _openGalleryMenu(tester, 'filter-menu');
      final Finder cityField = find.descendant(
        of: find.byKey(const ValueKey<String>('filter-menu')),
        matching: find.byType(EditableText),
      );
      await tester.enterText(cityField, 'dur');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Durban').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.text('City: Durban'), findsOneWidget);

      await _openGalleryMenu(tester, 'search-menu');
      final Finder languageField = find.descendant(
        of: find.byKey(const ValueKey<String>('search-menu')),
        matching: find.byType(EditableText),
      );
      await tester.enterText(languageField, 'sw');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Swift').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.text('Language: Swift'), findsOneWidget);

      await _openGalleryMenu(tester, 'multiple-menu');
      await tester.tap(find.text('Design').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.text('Teams: Engineering, Design'), findsOneWidget);
      await tester.tap(find.text('Research').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.text('Teams: Engineering, Design, Research'), findsOneWidget);
      await tester.tapAt(const Offset(12, 12));
      await tester.pumpAndSettle();

      await _openGalleryMenu(tester, 'popup-over');
      expect(find.text('Archive project').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Duplicate project').hitTestable());
      await tester.pumpAndSettle();
      expect(find.text('Project action: duplicate'), findsOneWidget);

      await _openGalleryMenu(tester, 'popup-under');
      await tester.tap(find.text('Pin to sidebar').hitTestable());
      await tester.pumpAndSettle();
      expect(find.text('Project action: pin'), findsOneWidget);
      expect(find.text('Duplicate project').hitTestable(), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('decoration gallery resolves its image and remains interactive', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('07 / Decorations'));
    await tester.pumpAndSettle();

    final Finder tile = find.byKey(const ValueKey<String>('decorated-tile'));
    final BoxDecoration decoration = tester.widget<ListTile>(tile).decoration!;
    final ImageProvider image = decoration.image!.image;
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

    final Finder button = find.byKey(
      const ValueKey<String>('decorated-button'),
    );
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('Decorated button activated'), findsOneWidget);
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.text('Decorated tile activated'), findsOneWidget);

    final Finder slider = find.byKey(
      const ValueKey<String>('decorated-slider'),
    );
    await tester.ensureVisible(slider);
    await tester.pumpAndSettle();
    final Rect bounds = tester.getRect(slider);
    await tester.tapAt(Offset(bounds.right - 40, bounds.center.dy));
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(slider).value, greaterThan(0.35));

    final Finder toggle = find.byKey(
      const ValueKey<String>('decorated-switch'),
    );
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(toggle).value, isFalse);
    expect(tester.widget<ListTile>(tile).decoration, decoration);
    expect(tester.takeException(), isNull);
  });
  testWidgets('foundations gallery localizes dates and consumes outside taps', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('08 / Foundations'));
    await tester.pumpAndSettle();
    expect(find.text('Friday, October 16, 2026'), findsOneWidget);
    final Finder foundations = find
        .ancestor(
          of: find.text('08 / Foundations'),
          matching: find.byType(Container),
        )
        .first;
    expect(
      find.descendant(of: foundations, matching: find.byType(CalendarGlyph)),
      findsOneWidget,
    );
    await tester.tap(find.text('Open an overlay'));
    await tester.pumpAndSettle();
    expect(find.text('Select foundation').hitTestable(), findsOneWidget);
    await tester.tap(find.text('LIVE INTERACTION STATE'));
    await tester.pumpAndSettle();
    expect(find.text('Select foundation').hitTestable(), findsNothing);
    expect(find.text('Ready to interact'), findsOneWidget);
    await tester.tap(find.text('LIVE INTERACTION STATE'));
    await tester.pumpAndSettle();
    expect(find.text('Custom interaction surface activated'), findsOneWidget);
    await tester.tap(find.text('Open an overlay'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select foundation').hitTestable());
    await tester.pumpAndSettle();
    expect(find.text('Foundation selected'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('roadmap families render and gallery interactions complete', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();
    for (final String section in <String>[
      '09 / Overlays and feedback',
      '10 / Text input and search',
      '11 / Date and time',
      '12 / Chips and button variants',
      '13 / Navigation and feedback',
    ]) {
      expect(find.text(section), findsOneWidget);
    }
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('roadmap-dialog')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Create a workspace?'), findsOneWidget);
    await tester.tap(find.text('Create workspace'));
    await tester.pumpAndSettle();
    expect(find.text('Workspace created'), findsOneWidget);
    await tester.tap(find.text('Queue a message'));
    await tester.pumpAndSettle();
    expect(find.text('Your changes are saved'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Save undone'), findsOneWidget);
    final Finder input = find.byKey(const ValueKey<String>('roadmap-text'));
    await tester.ensureVisible(input);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(of: input, matching: find.byType(EditableText)),
      'Demo',
    );
    await tester.pumpAndSettle();
    expect(find.text('Project: Demo'), findsOneWidget);
    await tester.ensureVisible(find.text('13 / Navigation and feedback'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings').hitTestable());
    await tester.pumpAndSettle();
    expect(find.text('Your preferences'), findsOneWidget);
    await tester.tap(find.text('Project details'));
    await tester.pumpAndSettle();
    expect(
      find.text('This content stays mounted while collapsed.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('gallery RTL and reduced motion apply inside modal routes', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    final Finder preference = find.text('Reduced motion for new components');
    await tester.ensureVisible(preference);
    await tester.pumpAndSettle();
    final Finder preferenceRow = find
        .ancestor(of: preference, matching: find.byType(Row))
        .first;
    await tester.tap(
      find.descendant(of: preferenceRow, matching: find.byType(Switch)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open dialog'));
    await tester.pump();
    final BuildContext dialog = tester.element(
      find.text('Create a workspace?'),
    );
    expect(Directionality.of(dialog), TextDirection.rtl);
    expect(MediaQuery.disableAnimationsOf(dialog), isTrue);
    expect(ModalRoute.of(dialog)!.animation!.value, 1);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _openGalleryMenu(WidgetTester tester, String key) async {
  final Finder trigger = find.byKey(ValueKey<String>(key));
  await tester.ensureVisible(trigger);
  await tester.pumpAndSettle();
  await tester.tap(trigger);
  await tester.pumpAndSettle();
}
