import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets(
    'tapping one field focuses only that field and positions its caret',
    (WidgetTester tester) async {
      final FocusNode first = FocusNode();
      final FocusNode second = FocusNode();
      final TextEditingController text = TextEditingController(text: 'abcdef');
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      addTearDown(text.dispose);
      await pumpNeutralApp(
        tester,
        SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(controller: text, focusNode: first),
              TextField(focusNode: second),
            ],
          ),
        ),
      );
      await tester.tapAt(
        tester.getTopLeft(find.byType(EditableText).first) + const Offset(2, 8),
      );
      await tester.pump();
      expect(first.hasFocus, isTrue);
      expect(second.hasFocus, isFalse);
      expect(text.selection.isValid, isTrue);
      expect(text.selection.baseOffset, lessThan(2));
      await tester.tap(find.byType(EditableText).last);
      await tester.pump();
      expect(first.hasFocus, isFalse);
      expect(second.hasFocus, isTrue);
    },
  );

  testWidgets('disabled fields are excluded from keyboard traversal', (
    WidgetTester tester,
  ) async {
    final FocusNode first = FocusNode();
    final FocusNode disabled = FocusNode();
    final FocusNode last = FocusNode();
    addTearDown(first.dispose);
    addTearDown(disabled.dispose);
    addTearDown(last.dispose);
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(focusNode: first),
            TextField(focusNode: disabled, enabled: false),
            TextField(focusNode: last),
          ],
        ),
      ),
    );
    first.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(disabled.hasFocus, isFalse);
    expect(last.hasFocus, isTrue);
  });

  testWidgets(
    'character limits count emoji families and combining accents as graphemes',
    (WidgetTester tester) async {
      final TextEditingController text = TextEditingController();
      addTearDown(text.dispose);
      String? changed;
      await pumpNeutralApp(
        tester,
        SizedBox(
          width: 300,
          child: TextField(
            controller: text,
            maxLength: 2,
            onChanged: (String value) {
              changed = value;
            },
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), '👨‍👩‍👧‍👦e\u0301x');
      await tester.pump();
      expect(text.text, '👨‍👩‍👧‍👦e\u0301');
      expect(changed, text.text);
      expect(find.text('2/2'), findsOneWidget);
      expect(text.selection.extentOffset, text.text.length);
    },
  );

  testWidgets(
    'maxLength preserves active composing text then limits committed text',
    (WidgetTester tester) async {
      final TextEditingController text = TextEditingController();
      addTearDown(text.dispose);
      await pumpNeutralApp(
        tester,
        SizedBox(width: 300, child: TextField(controller: text, maxLength: 1)),
      );
      await tester.showKeyboard(find.byType(EditableText));
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: 'ab',
          selection: TextSelection.collapsed(offset: 2),
          composing: TextRange(start: 0, end: 2),
        ),
      );
      await tester.pump();
      expect(text.text, 'ab');
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: 'ab',
          selection: TextSelection.collapsed(offset: 2),
          composing: TextRange.collapsed(0),
        ),
      );
      await tester.pump();
      expect(text.text, 'a');
      expect(text.value.composing, TextRange.empty);
    },
  );

  testWidgets(
    'field state controller follows editable focus and validation error',
    (WidgetTester tester) async {
      final FocusNode focus = FocusNode();
      final WidgetStatesController states = WidgetStatesController();
      addTearDown(focus.dispose);
      addTearDown(states.dispose);
      await pumpNeutralApp(
        tester,
        SizedBox(
          width: 300,
          child: TextField(
            focusNode: focus,
            statesController: states,
            errorText: 'Invalid',
          ),
        ),
      );
      focus.requestFocus();
      await tester.pumpAndSettle();
      expect(
        states.value,
        containsAll(<WidgetState>[WidgetState.focused, WidgetState.error]),
      );
      focus.unfocus();
      await tester.pumpAndSettle();
      expect(states.value, isNot(contains(WidgetState.focused)));
      expect(states.value, contains(WidgetState.error));
    },
  );

  testWidgets('repeated edits do not restart the floating label animation', (
    WidgetTester tester,
  ) async {
    final FocusNode focus = FocusNode();
    addTearDown(focus.dispose);
    const Key label = ValueKey<String>('floating-label');
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 300,
        child: TextField(
          focusNode: focus,
          label: const Text('Name', key: label),
          style: const TextFieldStyle(
            labelBehavior: TextFieldLabelBehavior.floating,
            animationDuration: Duration(milliseconds: 200),
          ),
        ),
      ),
    );
    double scale() => tester
        .widget<Transform>(
          find
              .ancestor(
                of: find.byKey(label),
                matching: find.byWidgetPredicate(
                  (Widget widget) =>
                      widget is Transform && widget.alignment != null,
                ),
              )
              .first,
        )
        .transform
        .entry(0, 0);
    focus.requestFocus();
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final double before = scale();
    expect(before, inExclusiveRange(.8, 1));
    await tester.enterText(find.byType(EditableText), 'a');
    await tester.pump(const Duration(milliseconds: 60));
    await tester.enterText(find.byType(EditableText), 'ab');
    await tester.pump(const Duration(milliseconds: 100));
    expect(scale(), closeTo(.8, 1e-9));
  });

  testWidgets('form controller swaps preserve text and external ownership', (
    WidgetTester tester,
  ) async {
    final TextEditingController external = TextEditingController(
      text: 'external',
    );
    final ValueNotifier<bool> supplied = ValueNotifier<bool>(false);
    addTearDown(external.dispose);
    addTearDown(supplied.dispose);
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 300,
        child: ValueListenableBuilder<bool>(
          valueListenable: supplied,
          builder: (BuildContext context, bool value, Widget? child) =>
              TextFormField(
                controller: value ? external : null,
                initialValue: value ? null : 'initial',
              ),
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'owned edit');
    supplied.value = true;
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller,
      external,
    );
    supplied.value = false;
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      'external',
    );
    external.text = 'still alive';
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('autocomplete reverses its exit when editing resumes', (
    WidgetTester tester,
  ) async {
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 300,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue value) =>
              value.text.isEmpty ? <String>[] : <String>['Alpha', 'Alpine'],
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'a');
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    await tester.enterText(find.byType(EditableText), 'al');
    await tester.pumpAndSettle();
    expect(find.text('Alpha').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      'Alpha',
    );
  });

  testWidgets('custom autocomplete options retain highlighted-option context', (
    WidgetTester tester,
  ) async {
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 300,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue value) =>
              value.text.isEmpty ? <String>[] : <String>['Alpha', 'Alpine'],
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<String> select,
            Iterable<String> options,
          ) => Text('Highlight ${AutocompleteHighlightedOption.of(context)}'),
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'a');
    await tester.pumpAndSettle();
    expect(find.text('Highlight 0'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(find.text('Highlight 1'), findsOneWidget);
  });

  testWidgets('autocomplete ignores stale asynchronous options', (
    WidgetTester tester,
  ) async {
    final Map<String, Completer<Iterable<String>>> pending =
        <String, Completer<Iterable<String>>>{};
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 300,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue value) =>
              (pending[value.text] = Completer<Iterable<String>>()).future,
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'a');
    await tester.pump();
    await tester.enterText(find.byType(EditableText), 'ab');
    await tester.pump();
    pending['ab']!.complete(<String>['Current']);
    await tester.pumpAndSettle();
    pending['a']!.complete(<String>['Stale']);
    await tester.pumpAndSettle();
    expect(find.text('Current'), findsOneWidget);
    expect(find.text('Stale'), findsNothing);
  });

  for (final bool fullScreen in <bool>[false, true]) {
    testWidgets(
      'search Escape retains its exit and restores focus ($fullScreen)',
      (WidgetTester tester) async {
        final SearchController controller = SearchController();
        final FocusNode trigger = FocusNode();
        addTearDown(controller.dispose);
        addTearDown(trigger.dispose);
        await pumpNeutralApp(
          tester,
          SizedBox(
            width: 300,
            child: SearchAnchor(
              isFullScreen: fullScreen,
              searchController: controller,
              builder: (BuildContext context, SearchController search) =>
                  TextButton(
                    focusNode: trigger,
                    onPressed: search.openView,
                    child: const Text('Search trigger'),
                  ),
              suggestionsBuilder: (
                BuildContext context,
                SearchController search,
              ) => <Widget>[const Text('Suggestion')],
            ),
          ),
        );
        trigger.requestFocus();
        await tester.pump();
        controller.openView();
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump(const Duration(milliseconds: 40));
        expect(controller.isOpen, isTrue);
        await tester.pumpAndSettle();
        expect(controller.isOpen, isFalse);
        expect(trigger.hasFocus, isTrue);
      },
    );

    testWidgets(
      'search reopening during exit preserves its single view ($fullScreen)',
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
              viewOnClose: () {
                closed++;
              },
              suggestionsBuilder: (
                BuildContext context,
                SearchController search,
              ) => <Widget>[const Text('Suggestion')],
            ),
          ),
        );
        controller.openView();
        await tester.pumpAndSettle();
        controller.closeView(null);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));
        controller.openView();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);
        expect(find.text('Suggestion'), findsOneWidget);
        expect(closed, 0);
        controller.closeView(null);
        await tester.pumpAndSettle();
        expect(closed, 1);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('search reduced motion closes immediately ($fullScreen)', (
      WidgetTester tester,
    ) async {
      final SearchController controller = SearchController();
      addTearDown(controller.dispose);
      await pumpNeutralApp(
        tester,
        SizedBox(
          width: 300,
          child: SearchAnchor.bar(
            searchController: controller,
            isFullScreen: fullScreen,
            suggestionsBuilder: (
              BuildContext context,
              SearchController search,
            ) => <Widget>[const Text('Suggestion')],
          ),
        ),
        disableAnimations: true,
      );
      controller.openView();
      await tester.pumpAndSettle();
      controller.closeView(null);
      await tester.pumpAndSettle();
      expect(controller.isOpen, isFalse);
      expect(find.text('Suggestion'), findsNothing);
    });
  }

  testWidgets(
    'removing a full-screen search anchor also removes its view safely',
    (WidgetTester tester) async {
      final SearchController controller = SearchController();
      final ValueNotifier<bool> visible = ValueNotifier<bool>(true);
      addTearDown(controller.dispose);
      addTearDown(visible.dispose);
      await pumpNeutralApp(
        tester,
        SizedBox(
          width: 300,
          child: ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (BuildContext context, bool value, Widget? child) => value
                ? SearchAnchor.bar(
                    searchController: controller,
                    isFullScreen: true,
                    suggestionsBuilder: (
                      BuildContext context,
                      SearchController search,
                    ) => <Widget>[const Text('Suggestion')],
                  )
                : const Text('Removed'),
          ),
        ),
      );
      controller.openView();
      await tester.pumpAndSettle();
      visible.value = false;
      await tester.pumpAndSettle();
      expect(controller.isAttached, isFalse);
      expect(find.text('Suggestion'), findsNothing);
      expect(find.text('Removed'), findsOneWidget);
      controller.text = 'still alive';
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('search selection changes do not rerun suggestions', (
    WidgetTester tester,
  ) async {
    final SearchController controller = SearchController(text: 'query');
    addTearDown(controller.dispose);
    int builds = 0;
    await pumpNeutralApp(
      tester,
      SizedBox(
        width: 300,
        child: SearchAnchor.bar(
          searchController: controller,
          suggestionsBuilder: (BuildContext context, SearchController search) {
            builds++;
            return <Widget>[const Text('Suggestion')];
          },
        ),
      ),
    );
    controller.openView();
    await tester.pumpAndSettle();
    final int before = builds;
    controller.selection = const TextSelection.collapsed(offset: 1);
    await tester.pumpAndSettle();
    expect(builds, before);
  });
  testWidgets(
    'text field labels its editable semantics and announces validation errors',
    (WidgetTester tester) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      await pumpNeutralApp(
        tester,
        const SizedBox(
          width: 300,
          child: TextField(
            labelText: 'Email',
            hintText: 'Your address',
            errorText: 'Invalid email',
          ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(EditableText)).getSemanticsData().label,
        contains('Email'),
      );
      expect(find.bySemanticsLabel('Invalid email'), findsOneWidget);
      semantics.dispose();
    },
  );
  for (final OutsideTapBehavior behavior in OutsideTapBehavior.values) {
    testWidgets('search outside behavior ${behavior.name} is respected', (
      WidgetTester tester,
    ) async {
      final SearchController controller = SearchController();
      addTearDown(controller.dispose);
      int taps = 0;
      await pumpNeutralApp(
        tester,
        SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SearchAnchor.bar(
                searchController: controller,
                style: SearchStyle(outsideTapBehavior: behavior),
                suggestionsBuilder: (
                  BuildContext context,
                  SearchController search,
                ) => <Widget>[const Text('Suggestion')],
              ),
              const SizedBox(height: 400),
              TextButton(
                onPressed: () {
                  taps++;
                },
                child: const Text('Outside'),
              ),
            ],
          ),
        ),
      );
      controller.openView();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Outside'));
      await tester.pumpAndSettle();
      expect(taps, behavior == OutsideTapBehavior.passThrough ? 1 : 0);
      expect(controller.isOpen, isFalse);
    });

    testWidgets('autocomplete outside behavior ${behavior.name} is respected', (
      WidgetTester tester,
    ) async {
      int taps = 0;
      await pumpNeutralApp(
        tester,
        SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Autocomplete<String>(
                style: AutocompleteStyle(
                  menuStyle: MenuStyle(outsideTapBehavior: behavior),
                ),
                optionsBuilder: (TextEditingValue value) =>
                    value.text.isEmpty ? <String>[] : <String>['Alpha'],
              ),
              const SizedBox(height: 400),
              TextButton(
                onPressed: () {
                  taps++;
                },
                child: const Text('Outside'),
              ),
            ],
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Outside'));
      await tester.pumpAndSettle();
      expect(taps, behavior == OutsideTapBehavior.passThrough ? 1 : 0);
      expect(find.text('Alpha'), findsNothing);
    });
  }

  testWidgets(
    'search controller replacement closes old full-screen views and detaches ownership',
    (WidgetTester tester) async {
      final SearchController first = SearchController();
      final SearchController second = SearchController();
      final ValueNotifier<SearchController> current =
          ValueNotifier<SearchController>(first);
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      addTearDown(current.dispose);
      await pumpNeutralApp(
        tester,
        SizedBox(
          width: 300,
          child: ValueListenableBuilder<SearchController>(
            valueListenable: current,
            builder:
                (BuildContext context, SearchController value, Widget? child) =>
                    SearchAnchor.bar(
                      searchController: value,
                      isFullScreen: true,
                      suggestionsBuilder: (
                        BuildContext context,
                        SearchController search,
                      ) => <Widget>[const Text('Suggestion')],
                    ),
          ),
        ),
      );
      first.openView();
      await tester.pumpAndSettle();
      current.value = second;
      await tester.pumpAndSettle();
      expect(first.isAttached, isFalse);
      expect(second.isAttached, isTrue);
      expect(second.isOpen, isFalse);
      first.text = 'independent';
      second.openView();
      await tester.pumpAndSettle();
      expect(find.text('Suggestion'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'editable text merges partial style tokens with inherited typography',
    (WidgetTester tester) async {
      await pumpNeutralApp(
        tester,
        const DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'Arial',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          child: SizedBox(
            width: 300,
            child: TextField(
              style: TextFieldStyle(
                textStyle: StateProperty<TextStyle?>.all(
                  TextStyle(fontSize: 19, color: Color(0xFF123456)),
                ),
              ),
            ),
          ),
        ),
      );
      final TextStyle style = tester
          .widget<EditableText>(find.byType(EditableText))
          .style;
      expect(style.fontFamily, 'Arial');
      expect(style.fontWeight, FontWeight.w700);
      expect(style.fontSize, 19);
      expect(style.color, const Color(0xFF123456));
    },
  );
}
