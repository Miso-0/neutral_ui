import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('onTap waits for an accepted tap release', (
    WidgetTester tester,
  ) async {
    int taps = 0;
    await pumpPure(
      tester,
      SizedBox(width: 280, child: TextField(onTap: () => taps++)),
    );
    final TestGesture pointer = await tester.startGesture(
      tester.getCenter(find.byType(EditableText)),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pump();
    expect(taps, 0);
    await pointer.up();
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('canceled text-selection drag never invokes onTap', (
    WidgetTester tester,
  ) async {
    int taps = 0;
    final TextEditingController text = TextEditingController(
      text: 'Select this text by dragging',
    );
    addTearDown(text.dispose);
    await pumpPure(
      tester,
      SizedBox(
        width: 280,
        child: TextField(controller: text, onTap: () => taps++),
      ),
    );
    final TestGesture pointer = await tester.startGesture(
      tester.getCenter(find.byType(EditableText)),
      kind: PointerDeviceKind.mouse,
    );
    await pointer.moveBy(const Offset(45, 0));
    await tester.pump();
    await pointer.cancel();
    await tester.pump();
    expect(taps, 0);
  });

  for (final TextDirection direction in TextDirection.values) {
    testWidgets('decorated padding focuses and activates in $direction', (
      WidgetTester tester,
    ) async {
      final FocusNode focus = FocusNode();
      addTearDown(focus.dispose);
      int taps = 0;
      await pumpPure(
        tester,
        SizedBox(
          width: 280,
          child: TextField(
            focusNode: focus,
            onTap: () => taps++,
            style: const TextFieldStyle(
              contentPadding: StateProperty<EdgeInsetsGeometry?>.all(
                EdgeInsets.all(24),
              ),
            ),
          ),
        ),
        textDirection: direction,
      );
      final Rect field = tester.getRect(find.byType(TextField));
      await tester.tapAt(Offset(field.left + 4, field.center.dy));
      await tester.pump();
      expect(focus.hasFocus, isTrue);
      expect(taps, 1);
    });
  }

  testWidgets('clear suffix acts independently and keeps editable focus', (
    WidgetTester tester,
  ) async {
    final FocusNode focus = FocusNode();
    final TextEditingController text = TextEditingController(
      text: 'Clear this',
    );
    addTearDown(focus.dispose);
    addTearDown(text.dispose);
    int taps = 0;
    final List<String> changes = <String>[];
    await pumpPure(
      tester,
      SizedBox(
        width: 280,
        child: TextField(
          controller: text,
          focusNode: focus,
          showClearButton: true,
          onTap: () => taps++,
          onChanged: changes.add,
        ),
      ),
    );
    focus.requestFocus();
    await tester.pump();
    await tester.tap(find.byType(CloseGlyph));
    await tester.pump();
    expect(text.text, isEmpty);
    expect(changes, <String>['']);
    expect(focus.hasFocus, isTrue);
    expect(taps, 0);
  });

  for (final bool fullScreen in <bool>[false, true]) {
    testWidgets(
      'SearchAnchor fullScreen=$fullScreen waits for bar pointer up before opening',
      (WidgetTester tester) async {
        final SearchController controller = SearchController();
        addTearDown(controller.dispose);
        await pumpPureApp(
          tester,
          SizedBox(
            width: 300,
            child: SearchAnchor.bar(
              searchController: controller,
              isFullScreen: fullScreen,
              suggestionsBuilder: (
                BuildContext context,
                SearchController controller,
              ) => const <Widget>[Text('Suggestion')],
            ),
          ),
        );
        final TestGesture pointer = await tester.startGesture(
          tester.getCenter(find.byType(SearchBar)),
          kind: PointerDeviceKind.mouse,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));
        expect(controller.isOpen, isFalse);
        expect(find.byType(EditableText), findsOneWidget);
        await pointer.up();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);
        expect(find.text('Suggestion'), findsOneWidget);
        controller.closeView(null);
        await tester.pumpAndSettle();
      },
    );
  }
}
