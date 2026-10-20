import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets(
    'autocomplete supports keyboard selection and completes its exit',
    (WidgetTester tester) async {
      String? selected;
      await pumpNeutralApp(
        tester,
        SizedBox(
          width: 240,
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue value) =>
                <String>['Alpha', 'Alpine'].where(
                  (String word) =>
                      value.text.isNotEmpty && word.startsWith(value.text),
                ),
            onSelected: (String value) => selected = value,
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'Al');
      await tester.pumpAndSettle();
      expect(find.text('Alpha').hitTestable(), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(selected, isNull);
      await tester.pumpAndSettle();
      expect(selected, isNotNull);
      expect(find.text('Alpha').hitTestable(), findsNothing);
    },
  );

  for (final bool fullScreen in <bool>[false, true]) {
    testWidgets(
      'search view selects and closes in ${fullScreen ? 'route' : 'overlay'} mode',
      (WidgetTester tester) async {
        final SearchController controller = SearchController();
        addTearDown(controller.dispose);
        int closed = 0;
        await pumpNeutralApp(
          tester,
          SizedBox(
            width: 300,
            child: SearchAnchor.bar(
              searchController: controller,
              isFullScreen: fullScreen,
              viewOnClose: () => closed++,
              suggestionsBuilder:
                  (BuildContext context, SearchController search) => <Widget>[
                    TextButton(
                      onPressed: () => search.closeView('chosen'),
                      child: const Text('Suggestion'),
                    ),
                  ],
            ),
          ),
        );
        controller.openView();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);
        await tester.tap(find.text('Suggestion'));
        await tester.pump();
        expect(closed, 0);
        await tester.pumpAndSettle();
        expect(controller.isOpen, isFalse);
        expect(controller.text, 'chosen');
        expect(closed, 1);
      },
    );
  }

  testWidgets('search ignores stale asynchronous suggestions', (
    WidgetTester tester,
  ) async {
    final SearchController controller = SearchController();
    addTearDown(controller.dispose);
    final Map<String, Completer<Iterable<Widget>>> pending =
        <String, Completer<Iterable<Widget>>>{};
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 300,
        child: SearchAnchor.bar(
          searchController: controller,
          suggestionsBuilder: (BuildContext context, SearchController search) =>
              (pending[search.text] = Completer<Iterable<Widget>>()).future,
        ),
      ),
    );
    controller.openView();
    await tester.pump();
    controller.text = 'new';
    await tester.pump();
    pending['new']!.complete(const <Widget>[Text('Current')]);
    await tester.pumpAndSettle();
    pending['']!.complete(const <Widget>[Text('Stale')]);
    await tester.pumpAndSettle();
    expect(find.text('Current'), findsOneWidget);
    expect(find.text('Stale'), findsNothing);
    controller.closeView(null);
    await tester.pumpAndSettle();
  });
}
