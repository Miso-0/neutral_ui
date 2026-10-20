import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';

import '../helpers/pump.dart';

class _Registry<T> implements RadioGroupRegistry<T> {
  _Registry({this.groupValue, required this.onChanged});

  @override
  T? groupValue;

  @override
  final ValueChanged<T?> onChanged;

  final Set<RadioClient<T>> clients = <RadioClient<T>>{};

  @override
  void registerClient(RadioClient<T> radio) => clients.add(radio);

  @override
  void unregisterClient(RadioClient<T> radio) => clients.remove(radio);
}

void main() {
  testWidgets('explicit group mapping selects the represented value', (
    WidgetTester tester,
  ) async {
    int? selected = 1;
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final int value in <int>[1, 2])
              Radio<int>(
                value: value,
                groupValue: selected,
                onChanged: (int? next) => setState(() => selected = next),
              ),
          ],
        ),
      ),
    );
    await tester.tap(find.byType(Radio<int>).last);
    await tester.pumpAndSettle();
    expect(selected, 2);
    await tester.tap(find.byType(Radio<int>).last);
    await tester.pumpAndSettle();
    expect(selected, 2);
  });

  testWidgets('toggleable explicit radio requests null when selected', (
    WidgetTester tester,
  ) async {
    final List<int?> changes = <int?>[];
    await pumpNeutral(
      tester,
      Radio<int>(
        value: 1,
        groupValue: 1,
        toggleable: true,
        onChanged: changes.add,
      ),
    );
    await tester.tap(find.byType(Radio<int>));
    expect(changes, <int?>[null]);
  });

  testWidgets(
    'radio without a source and explicit disabled radio ignore taps',
    (WidgetTester tester) async {
      int calls = 0;
      await pumpNeutral(
        tester,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Radio<int>(value: 1),
            Radio<int>(
              value: 2,
              groupValue: 1,
              enabled: false,
              onChanged: (int? next) => calls += 1,
            ),
          ],
        ),
      );
      for (final Element radio in find.byType(Radio<int>).evaluate()) {
        await tester.tap(find.byWidget(radio.widget));
      }
      expect(calls, 0);
      expect(
        tester.getSize(find.byType(Radio<int>).first),
        const Size(48.0, 48.0),
      );
    },
  );

  testWidgets(
    'ancestor RadioGroup supplies selection and handles tap changes',
    (WidgetTester tester) async {
      int? selected = 1;
      final SemanticsHandle semantics = tester.ensureSemantics();
      await pumpNeutral(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) =>
              RadioGroup<int>(
                groupValue: selected,
                onChanged: (int? next) => setState(() => selected = next),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio<int>(value: 1),
                    Radio<int>(value: 2),
                  ],
                ),
              ),
        ),
      );
      expect(
        tester.getSemantics(find.byType(Radio<int>).first),
        isSemantics(isChecked: true, isInMutuallyExclusiveGroup: true),
      );
      await tester.tap(find.byType(Radio<int>).last);
      await tester.pumpAndSettle();
      expect(selected, 2);
      expect(
        tester.getSemantics(find.byType(Radio<int>).last),
        isSemantics(isChecked: true, isEnabled: true, hasTapAction: true),
      );
      semantics.dispose();
    },
  );

  testWidgets(
    'RadioGroup owns arrow navigation and Space while Enter activates',
    (WidgetTester tester) async {
      useTraditionalFocus();
      int? selected = 1;
      final FocusNode first = FocusNode();
      final FocusNode second = FocusNode();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      await pumpNeutral(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) =>
              RadioGroup<int>(
                groupValue: selected,
                onChanged: (int? next) => setState(() => selected = next),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio<int>(value: 1, focusNode: first, toggleable: true),
                    Radio<int>(value: 2, focusNode: second, toggleable: true),
                  ],
                ),
              ),
        ),
      );
      first.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(selected, 2);
      expect(second.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(selected, isNull);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selected, 2);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(selected, 1);
      expect(first.hasFocus, isTrue);
    },
  );

  testWidgets('registry takes precedence over explicit and ancestor groups', (
    WidgetTester tester,
  ) async {
    final List<int?> registryChanges = <int?>[];
    int explicitCalls = 0;
    int ancestorCalls = 0;
    final _Registry<int> registry = _Registry<int>(
      groupValue: 1,
      onChanged: registryChanges.add,
    );
    await pumpNeutral(
      tester,
      RadioGroup<int>(
        groupValue: 3,
        onChanged: (int? next) => ancestorCalls += 1,
        child: Radio<int>(
          value: 2,
          groupValue: 2,
          onChanged: (int? next) => explicitCalls += 1,
          groupRegistry: registry,
        ),
      ),
    );
    expect(registry.clients, hasLength(1));
    await tester.tap(find.byType(Radio<int>));
    expect(registryChanges, <int?>[2]);
    expect(explicitCalls, 0);
    expect(ancestorCalls, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(registry.clients, isEmpty);
  });

  testWidgets('explicit mode overrides an ancestor RadioGroup', (
    WidgetTester tester,
  ) async {
    int? explicit;
    int ancestorCalls = 0;
    await pumpNeutral(
      tester,
      RadioGroup<int>(
        groupValue: 2,
        onChanged: (int? next) => ancestorCalls += 1,
        child: Radio<int>(
          value: 2,
          groupValue: 1,
          onChanged: (int? next) => explicit = next,
        ),
      ),
    );
    await tester.tap(find.byType(Radio<int>));
    expect(explicit, 2);
    expect(ancestorCalls, 0);
  });

  testWidgets('changing registries unregisters the previous client', (
    WidgetTester tester,
  ) async {
    final _Registry<int> first = _Registry<int>(onChanged: (int? next) {});
    final _Registry<int> second = _Registry<int>(onChanged: (int? next) {});
    await pumpNeutral(tester, Radio<int>(value: 1, groupRegistry: first));
    expect(first.clients, hasLength(1));
    await pumpNeutral(tester, Radio<int>(value: 1, groupRegistry: second));
    expect(first.clients, isEmpty);
    expect(second.clients, hasLength(1));
    await tester.pumpWidget(const SizedBox.shrink());
    expect(second.clients, isEmpty);
  });

  testWidgets('radio releases owned nodes and keeps caller focus nodes alive', (
    WidgetTester tester,
  ) async {
    final FocusNode external = FocusNode();
    addTearDown(external.dispose);
    final _Registry<int> registry = _Registry<int>(onChanged: (int? next) {});
    await pumpNeutral(tester, Radio<int>(value: 1, groupRegistry: registry));
    final FocusNode owned = registry.clients.single.focusNode;
    await pumpNeutral(
      tester,
      Radio<int>(value: 1, groupRegistry: registry, focusNode: external),
    );
    expect(registry.clients.single.focusNode, same(external));
    expect(() => owned.addListener(() {}), throwsFlutterError);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(() => external.addListener(() {}), returnsNormally);
  });

  testWidgets('radio semantics identify checked membership and label', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await pumpNeutral(
      tester,
      Radio<int>(
        value: 1,
        groupValue: 1,
        onChanged: (int? next) {},
        semanticLabel: 'First option',
      ),
    );
    expect(
      tester.getSemantics(find.byType(Radio<int>)),
      isSemantics(
        label: 'First option',
        hasCheckedState: true,
        isChecked: true,
        isInMutuallyExclusiveGroup: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    semantics.dispose();
  });
}
